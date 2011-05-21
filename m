Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab1EUIXw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 04:23:52 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60069 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab1EUIXt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 04:23:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=q918Dd+T9yASjXzql7SFgELQCnKKg0+fudTwjzebgFoTN2Af3WOEYRRNetHyznpWnk
         q29MAfNWypdNLizBx+/JbMFEqaCZdvlc78JDTwtMavIubMhEAad1r50tRVhxS/bEdTR2
         4N+5l4gpCFoz3IwDsc7lzCduSe2wT95WJcdRQ=
MIME-Version: 1.0
In-Reply-To: <20110520220314.GA8271@siel.b>
References: <BANLkTikGxbcMBD=3W_9_mpZBoVDc8HrX8A@mail.gmail.com>
 <9534.1305905293@localhost> <BANLkTikCivzqf5OJEa=ouKSvaLMTS3ayng@mail.gmail.com>
 <20110520220314.GA8271@siel.b>
From: "D. Jansen" <d.g.jansen@googlemail.com>
Date: Sat, 21 May 2011 10:23:09 +0200
Message-ID: <BANLkTikpFeQxxUY_qmx8jc4GPTdWijXTyg@mail.gmail.com>
Subject: Re: [rfc] Ignore Fsync Calls in Laptop_Mode
To: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, tytso@mit.edu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 21, 2011 at 12:03 AM, torbenh <torbenh@gmx.de> wrote:
> On Fri, May 20, 2011 at 06:40:49PM +0200, D. Jansen wrote:
>> On Fri, May 20, 2011 at 5:28 PM,  <Valdis.Kletnieks@vt.edu> wrote:
>> > On Thu, 19 May 2011 15:34:46 +0200, Dennis Jansen said:
>> >
>> >> Testing:
>> >> I've been using this workaround on my netbook for over six months now.
>> >> It works as expected for me with all software in a Ubuntu 9.10
>> >> environment and saves me at least 0.5 Watt or roughly 10 % battery
>> >> time - without destroying my hard disk. I have seen no negative side
>> >> effects.
>> >
>> > How much destructive testing did you do?  In the 6 months, how many times did
>> > the system crash (or had the battery pulled out, or whatever) while large
>> > amounts of data were still pending after apps thought they were fsync'ed? How
>> > much crash testing was done against apps that use fsync for ordering or
>> > correctness reasons?
>>
>> I don't see the point in verifying the obvious. Of course applications
>> that rely on fsync will lose data.
>> The real problem comes with ordering correctness, which could actually
>> _destroy previous data_ as well.
>> In my scenario (office applications, browsing) I have not hit such a problem.
>
> how about making fsync block until the harddisk spins up ?
> this would also enable you to detect these apps you wouldnt be using in
> laptop mode anyways ?

Very nice idea. I had tried that some time ago. Depending on the error codes I
have, the apps either failed to save and complained to the user - or -
kept trying to fsync again and again. Of course the latter wouldn't
really be a problem unless a race occurs. And we have the benefit of
being honest to user
space and letting them know we are not fsyncing. And the fsync occurs
as soon as we disable laptop mode and plug into AC. I have to try that
out again.
