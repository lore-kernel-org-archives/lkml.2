Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab2KEGPE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 01:15:04 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:39028 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab2KEGPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 01:15:01 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Pavel Machek <pavel@ucw.cz>, Chris Friesen <chris.friesen@genband.com>,
        Eric Paris <eparis@parisplace.org>, Jiri Kosina <jkosina@suse.cz>,
        Oliver Neukum <oneukum@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
References: <20121102175416.GA11816@srcf.ucam.org>
	<1351879058.2439.46.camel@dabdike.int.hansenpartnership.com>
	<20121102180458.GA12052@srcf.ucam.org>
	<1351899503.2439.49.camel@dabdike.int.hansenpartnership.com>
	<20121103002244.GC18691@srcf.ucam.org>
	<1351944236.2417.7.camel@dabdike.int.hansenpartnership.com>
	<20121103134630.GA28166@srcf.ucam.org>
	<1351983400.2417.21.camel@dabdike.int.hansenpartnership.com>
	<20121104042802.GA11295@srcf.ucam.org>
	<1352020487.2427.5.camel@dabdike.int.hansenpartnership.com>
	<20121104135251.GA17894@srcf.ucam.org>
Date: Sun, 04 Nov 2012 22:14:44 -0800
In-Reply-To: <20121104135251.GA17894@srcf.ucam.org> (Matthew Garrett's message
	of "Sun, 4 Nov 2012 13:52:51 +0000")
Message-ID: <87d2zsmv8r.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX197A2fyjJ94fRXmtRFZsGaDAlTYxepqI7Y=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0016]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Matthew Garrett <mjg59@srcf.ucam.org>
X-Spam-Relay-Country: 
Subject: Re: [RFC] Second attempt at kernel secure boot support
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett <mjg59@srcf.ucam.org> writes:

> On Sun, Nov 04, 2012 at 09:14:47AM +0000, James Bottomley wrote:
>
>> I've actually had more than enough experience with automated installs
>> over my career: they're either done by paying someone or using a
>> provisioning system.  In either case, they provision a static image and
>> boot environment description, including EFI boot services variables, so
>> you can provision a default MOK database if you want the ignition image
>> not to pause on firstboot.
>
> And now you've moved the attack vector to a copy of your provisioning 
> system instead.
>
>> There is obviously the question of making the provisioning systems
>> secure, but it's a separate one from making boot secure.
>
> You don't get to punt on making the kernel secure by simply asserting 
> that some other system can be secure instead. The chain of trust needs 
> to go all the way back - if your security model is based on all installs 
> needing a physically present end user, all installs need a physically 
> present end user. That's not acceptable, so we need a different security 
> model.

Bzzzt.  Theory and reality disagreeing.

I have done a lot of automatic installs.  At the very least someone has
to be present to apply power to the hardware.  So someone being present
is not a requirement you can remove.

Furthermore in most cases an automatic install requires kicking the
system into network boot mode or into inserting an install cd.  Both are
actions that require a user to be present.

The goal is to reduce what a user must do to a minimum to remove the
possibility of human error, not to reduce what must happen into
absurdity.

The other side is that a general purpose configuration of firmware
almost never is suitable for a general install.  So either some small
amount of time must be spent fixing the BIOS settings or have an
appropriate set of BIOS settings come from your supplier.



In practice what I would expect of a UEFI system that ships ready for
automatic installs is a system that initiall boots up in "setup mode"
where it is possible to install your own platform signing key.

What I would expect to happen in that situation is that during the first
boot software would come over the network or from an install cd and
install my platform signing key.  Then a bootloader signed with my key
would be installed, and then everything would chain from there.

In most cases where I would be setting up an automatic install I would
not install Microsoft's key, and I would definitely not sign my
bootloader with Microsoft's key.  At most I would sign my own "key
install" with Microsoft's key.

Then in cases of automatic reinstallation my key would be in the
firmware and I could change my bootloader and my kernels at will
with no risk that some third party could do anything to the machine
unless they manged to get physical access.

If I was a distroy my key would that I would install by default would be
the distro's signing key.  Although honestly I would still prefer a
solution where I could lock things down a little farther.



In any case the notion that unattended install with no user interaction
on any uefi machine in any state is complete and total rubbish.  It
can't be done.  You need power and you need boot media.

Eric
