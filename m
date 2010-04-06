Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310Ab0DFGYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 02:24:15 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:53836 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab0DFGYH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 02:24:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=orvCefzjPtxOaxkgM0dtmhZfnFbTMK6H4MuN1cHE0g8ZK7MiPlH7yqCeSiO+5Bxx4g
         y3vDW7kLTuVcBNNhQLQa1c/hGxxNEJhnunp0y2ij0r/7yS6607YtqyGUGeG4HX9+WLqd
         Nof25UWUXY7eZJwxNGGoF2mG3hZnZMWLCkiLg=
MIME-Version: 1.0
In-Reply-To: <20100406054305.GB18217@localhost>
References: <1270499041.9013.15.camel@edumazet-laptop>
	 <1270501448.9013.23.camel@edumazet-laptop>
	 <1270502345.9013.31.camel@edumazet-laptop>
	 <y2h2375c9f91004052230i557aab00t7189369ba42f940d@mail.gmail.com>
	 <20100406054305.GB18217@localhost>
Date: Tue, 6 Apr 2010 14:24:05 +0800
Message-ID: <x2j2375c9f91004052324h67872928o492547cf00b5bb62@mail.gmail.com>
Subject: Re: [PATCH] /dev/mem: Allow rewinding
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Dave Jones <davej@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 6, 2010 at 1:43 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> On Tue, Apr 06, 2010 at 01:30:29PM +0800, Américo Wang wrote:
>> On Tue, Apr 6, 2010 at 5:19 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>> > Le lundi 05 avril 2010 à 23:04 +0200, Eric Dumazet a écrit :
>> >> Andrew, commit dcefafb6ac90ece8d68a6c203105f3d313e52da4 seems to be the
>> >> problem.
>> >>
>> >> It breaks rewinds (negative offsets to lseek (... SEEK_CUR))
>> >>
>> >
>> > Here is a patch to make rewind working again on /dev/mem
>> >
>> > [PATCH] /dev/mem: Allow rewinding
>> >
>> > commit dcefafb6 (/dev/mem: dont allow seek to last page)
>> > inadvertently disabled rewinding on /dev/mem.
>> >
>> > This broke x86info for example.
>> >
>> > Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
>> > ---
>> > diff --git a/drivers/char/mem.c b/drivers/char/mem.c
>> > index 1f3215a..3973a1d 100644
>> > --- a/drivers/char/mem.c
>> > +++ b/drivers/char/mem.c
>> > @@ -710,11 +710,6 @@ static loff_t memory_lseek(struct file *file, loff_t offset, int orig)
>> >        switch (orig) {
>> >        case SEEK_CUR:
>> >                offset += file->f_pos;
>> > -               if ((unsigned long long)offset <
>> > -                   (unsigned long long)file->f_pos) {
>> > -                       ret = -EOVERFLOW;
>> > -                       break;
>> > -               }
>>
>> Why completely dropping the overflow check? What you need to do is just
>> adding the 'offset < 0' case check.
>
> It will fall through to the next EOVERFLOW check in the SEEK_SET case :)
>

Oh, right, I didn't read the code, merely the patch.

Thanks.
