Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab2I0Njb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 09:39:31 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:32865 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab2I0Nj3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 09:39:29 -0400
MIME-Version: 1.0
In-Reply-To: <506382B0.8040908@cs.tu-berlin.de>
References: <1348682325-8402-1-git-send-email-schnhrr@cs.tu-berlin.de>
 <20120926211526.GA30261@kroah.com> <506382B0.8040908@cs.tu-berlin.de>
From: Kay Sievers <kay@vrfy.org>
Date: Thu, 27 Sep 2012 15:39:08 +0200
Message-ID: <CAPXgP11xwBDSZ9q9thzbXd5xZW_jeq-OW96hSoXFbXQBjQWbqw@mail.gmail.com>
Subject: Re: [PATCH] printk: drop ambiguous LOG_CONT flag
To: =?UTF-8?Q?Jan_H=2E_Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 12:33 AM, "Jan H. Schönherr"
<schnhrr@cs.tu-berlin.de> wrote:
> Am 26.09.2012 23:15, schrieb Greg Kroah-Hartman:
>> On Wed, Sep 26, 2012 at 07:58:45PM +0200, Jan H. Schönherr wrote:
>>> Against v3.6-rc7, only lightly tested.
>>
>> Well, against linux-next and highly tested would be best.  It's a bit
>> late to get this into linux-next for 3.7, how important is it really?
>
> There are no conflicting commits in linux-next, so it should apply there
> as well.
>
> "Tested" as in: it fixes my use case: multiple printk()s shortly after each
> other -- with KERN_prefix but without a newline at the end. Those were
> sometimes concatenated since that printk-rewrite.

Please provide the output of /dev/kmsg so we can see what's going on here.

> All other printk()s that I come across more often look as usual, before and
> after the patch. (Mostly singular printk()s, but I also checked the output
> from the oom-killer.)
>
> There is no need to include this hastily -- at least not from my point of view
> -- as it is already broken in 3.5 and nobody else seems to notice it
> (... and I have now a fix for my development printk()s). Should I resend the
> patch later?
>
> I was also hoping that Kay might share his opinion, as the LOG_CONT
> flag is rather young, and he might have some different plans for it.

It is a flag that we have not been able to merge a continuation line
in the buffer, because we had a race with another thread, or the
console lock was taken for a long time and we couldn't use the merge
buffer.

LOG_CONT is used to merge (not intended to be) separate records at
time we read them from the record buffer, and print them, it is also
exported as a flag in /dev/kmsg.

I don't think we can just remove it, we can not get that information
from the prefix+newlines, they are not sufficient.

Thanks,
Kay
