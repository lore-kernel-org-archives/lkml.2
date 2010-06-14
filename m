Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab0FNTwD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 15:52:03 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63252 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab0FNTwA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 15:52:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cm0qSBk296JGGpIwGDN2enRIvJcychK4v+tiZ58TJ6R+F10IdbzaUhtaoQBoM09Bl7
         2hP6f5MVf7s9pz0Fg5ul884gftW6i/6gzyo71zIjMuFUoq/xacrXazp9RTYY5HDLb2a3
         yugpFpmFh+szBtcHsylTpcvFBIa4iwZIOjIRI=
MIME-Version: 1.0
In-Reply-To: <201006142103.54616.rjw@sisk.pl>
References: <201006141653.03879.rjw@sisk.pl>
	<AANLkTimQ_yCV5Xdwd_D1zFM1oom2D3ZIBeSczJh4LN1T@mail.gmail.com>
	<201006142103.54616.rjw@sisk.pl>
Date: Mon, 14 Jun 2010 21:51:58 +0200
Message-ID: <AANLkTil-o-dB8f4hwM6qHTQzJ0_o5vx9TAX73gNdi9iH@mail.gmail.com>
Subject: Re: [Regression, post-2.6.34] Hibernation broken on machines with 
	radeon/KMS and r300
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alex Deucher <alexdeucher@gmail.com>, linux-kernel@vger.kernel.org,
       dri-devel <dri-devel@lists.freedesktop.org>,
       Dave Airlie <airlied@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/14 Rafael J. Wysocki <rjw@sisk.pl>:
> On Monday, June 14, 2010, Alex Deucher wrote:
>> On Mon, Jun 14, 2010 at 10:53 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > Alex, Dave,
>> >
>> > I'm afraid hibernation is broken on all machines using radeon/KMS with r300
>> > after commit ce8f53709bf440100cb9d31b1303291551cf517f
>> > (drm/radeon/kms/pm: rework power management).  At least, I'm able to reproduce
>> > the symptom, which is that the machine hangs hard around the point where an
>> > image is created (probably during the device thaw phase), on two different
>> > boxes with r300 (the output of lspci from one of them is attached for
>> > reference, the other one is HP nx6325).
>> >
>> > Suspend to RAM appears to work fine at least on one of the affected boxes.
>> >
>> > Unfortunately, the commit above changes a lot of code and it's not too easy to
>> > figure out what's wrong with it and I didn't have the time to look more into
>> > details of this failure.  However, it looks like you use .suspend() and
>> > .resume() callbacks as .freeze() and .thaw() which may not be 100% correct
>> > (in fact it looks like the "legacy" PCI suspend/resume is used, which is not
>> > recommended any more).
>> >
>>
>> Does it work any better after Dave's last drm pull request?
>
> Nope.  The symptom is slightly different, though, because now it hangs after
> turning off the screen.

"Just" turning the screen off (like dpms force off) or turning it off
while suspending?

Maybe it could be worth enabling drm.debug option and logging using
netconsole or similar...

-- 
Rafał
