Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245Ab0E0XDP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 19:03:15 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45840 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757548Ab0E0XDJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 19:03:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FMNXNyTk5LK6mAbG22LxjIChG5Ov4krT2VNd2S36O9sLKZcZl86VfYLoFuVQ1/+uVC
         fLW7P02sixRrNHAgncPr0wEqbiJFp6frT+ooD4qa/AfRp1bN1XVZ8nC72aQfBjm3d/RQ
         2vObe1Gev9ewjPmWbWU4zgcF8+mY85lGPCY8c=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1005270956380.3689@i5.linux-foundation.org>
References: <20100513075728.GF30110@core.coreip.homeip.net>
	<alpine.LFD.2.00.1005130724280.3711@i5.linux-foundation.org>
	<20100513160117.GB22238@core.coreip.homeip.net>
	<alpine.LFD.2.00.1005130943460.3711@i5.linux-foundation.org>
	<4BFE0FAB.9040009@gmail.com>
	<alpine.LFD.2.00.1005270956380.3689@i5.linux-foundation.org>
Date: Thu, 27 May 2010 17:03:08 -0600
Message-ID: <AANLkTimkI2rLOO2vaPFBQUbzr5t0pAQGQ5R5noTOBp4K@mail.gmail.com>
Subject: Re: [git pull] Input updates for 2.6.34-rc6
From: Robert Hancock <hancockrwd@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org, Bastien Nocera <hadess@hadess.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 11:06 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Thu, 27 May 2010, Robert Hancock wrote:
>>
>> I don't think they did anything wrong in their BIOS, it's working exactly as
>> the spec intended. There is no PS/2 controller, and the ACPI PnP tables do not
>> list one.
>
> You seem to be unable to read.
>
> First off, there _is_ a PS2 controller. You can't get any normal Intel
> chips without one, as far as I can tell. The lines may not be brought out,
> but that's immaterial.

I believe the PS/2 controller is normally on the LPC SuperIO chip, not
the chipset itself. It's entirely possible that Apple used a chip that
didn't include any such controller at all. It's also possible they
reused the IO ports normally assigned to it for something else (which
would be a questionable decision, yes), which is why the machine blows
up when the ports get probed.

>
> Secondly, even if there wasn't any - or the controller is actively
> disabled, Linux handles that situation perfectly fine. The fact is, the
> low ports (< 0x100) are reserved for motherboard devices, and Linux probes
> the things fine.
>
> Thirdly, the thing is, PnP tables are incomplete. Always. They don't prove
> a negative. Deal with it. It's a _fact_.

It's highly unlikely that they are incomplete in this respect, as
since I mentioned, Windows would fail to recognize the PS/2 controller
that people would expect to work, which would most likely get
noticed..

>
> So Apple must have actively screwed things up. If you can't admit that,
> it's your problem.
>
>> Long and the short of it is, it seems pretty safe to say that on any ACPI
>> machine, if there's no PnP entry for PS/2 devices, the BIOS does not intend
>> for the OS to use them.
>
> And your argument is pure and utter sh*t. I don't know why I even bother
> replying to it, but I'll try one more time:
>
>  - BIOS writers are incompetent drug-addled morons. Your argument that
>   "the BIOS does not intend for the OS to use them" is a totally idiotic
>   argument, for the simple reason that it's not up to the BIOS writers,
>   and even if it _was_ up to them, they always screw things up.
>
> The thing boils down to: we cannot trust the firmware anyway (this is a
> simple _fact_, not some random opinion), and no, the BIOS writers do not
> have some magic powers that allow them to determine how hardware should be
> used.

I think this is a case where it has to be trusted, because that's what
Windows does. Experience has shown time and again that deviating from
Windows behavior with these kinds of ACPI platform-related issues is
fraught with problems, since hardware vendors test only with Windows.
If Linux behaved the same as Windows here, and left the PS/2 IO ports
alone since there was no PNP device defined for it, this problem
presumably wouldn't have come up.

Since many machines are moving towards no longer including legacy PS/2
ports, this kind of thing seems likely to come up elsewhere..
