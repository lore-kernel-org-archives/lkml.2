Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab0JQMGz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 08:06:55 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55657 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045Ab0JQMGy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 08:06:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tDJqL3SSUVxS4aiwyPZ8E2QbtEjmuskf4TXIxvqMCVvopcRq+HlbDn7xB3ANyNEzNz
         otSAeS+1OsY+5OFbkpZT0RB4EZFuKj2VTs6VAeh+0kMQe+3VzIGvjf4WMZWnQ5V/hvHG
         lLPfjdbau3xLIjIpz1x384yxUFbOtm6khCx2E=
MIME-Version: 1.0
In-Reply-To: <20101015201453.GB12981@n2100.arm.linux.org.uk>
References: <1287152120-7201-1-git-send-email-felipe.contreras@gmail.com>
	<1287153021.27165.6.camel@e102109-lin.cambridge.arm.com>
	<20101015194255.GA12981@n2100.arm.linux.org.uk>
	<AANLkTinmAy13niqRKrray1Gk4hkr19tA2gWwYbfnFoh7@mail.gmail.com>
	<20101015201453.GB12981@n2100.arm.linux.org.uk>
Date: Sun, 17 Oct 2010 15:06:44 +0300
Message-ID: <AANLkTimyEZp4ygmM7WeES3h5bixBNF2rY0x==x7SZ+GQ@mail.gmail.com>
Subject: Re: [PATCH .36-rc8] arm: mm: allow, but warn, when issuing ioremap()
 on RAM
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        linux-main <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Richard Woodruff <r-woodruff2@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 11:14 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Fri, Oct 15, 2010 at 11:00:40PM +0300, Felipe Contreras wrote:
>> On Fri, Oct 15, 2010 at 10:42 PM, Russell King - ARM Linux
>> <linux@arm.linux.org.uk> wrote:
>> > As soon as the first ARM merge hits during the merge window, I'll be
>> > restoring the 'always fail' behaviour.
>>
>> Ok, are you going to merge also your patch to use memblock for the
>> initialization? Many drivers could certainly use that to fix the
>> issue.
>
> There's a lot of work going on with memblock in x86-land which impacts
> ARM and means major conflicts for that patch - I think first we'll have
> to deal with the fallout from that (iow, finding out what's been broken
> by this activity and fix that), and then I'll have to re-do my patch from
> the beginning.
>
> Technically, following the rules, that means it has to miss this merge
> window - so it looks like it's going to take another six months to solve
> this issue (three months to get the memblock patch in, and another three
> months for driver fixes to find their way through.)

I don't think that's a good idea. Drivers would not have a way to get
fixed, even for .37.

Are these x86 changes in some branch? Would it help if I try to port
your patch on top of that? IOW; is there any chance of getting these
drivers fixed on .37?

If not, I guess people would have to revert the patch that disables
ioremap() on RAM on their trees.

> I find these timescales (12 months) rather unacceptable to fix a problem
> such as this.  Makes me wonder why I even bother trying.

As I said, if the warning was merged on .35 (or even before) I think
things would have gone smoother, but I guess we'll see on .36 what
happens.

-- 
Felipe Contreras
