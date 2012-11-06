Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab2KFH4l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 02:56:41 -0500
Received: from ka.mail.enyo.de ([87.106.162.201]:48775 "EHLO ka.mail.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752816Ab2KFH4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 02:56:39 -0500
From: Florian Weimer <fw@deneb.enyo.de>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Pavel Machek <pavel@ucw.cz>, Chris Friesen <chris.friesen@genband.com>,
        Eric Paris <eparis@parisplace.org>, Jiri Kosina <jkosina@suse.cz>,
        Oliver Neukum <oneukum@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
References: <20121104135251.GA17894@srcf.ucam.org>
	<87d2zsmv8r.fsf@xmission.com> <509766DB.9090906@zytor.com>
	<87625kh5r2.fsf@xmission.com> <20121105123858.GB4374@srcf.ucam.org>
	<87sj8nc137.fsf@xmission.com> <20121105202557.GA16076@srcf.ucam.org>
	<87hap3zbw7.fsf@xmission.com> <20121106031219.GB24235@srcf.ucam.org>
	<87fw4nv1vj.fsf@xmission.com> <20121106035352.GA24698@srcf.ucam.org>
	<87hap3s3yl.fsf@xmission.com>
Date: Tue, 06 Nov 2012 08:56:01 +0100
In-Reply-To: <87hap3s3yl.fsf@xmission.com> (Eric W. Biederman's message of
	"Mon, 05 Nov 2012 21:19:46 -0800")
Message-ID: <878vafqi5q.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eric W. Biederman:

> If windows is not present on a system linux can not be used to boot a
> compromised version of windows without user knowledge because windows is
> not present.

Interesting idea.  Unfortunately, it is very hard to detect reliably
that Windows is not present from the bootloader, so it's not possible
to use this approach to simplify matters.

> If windows is present on a system then to install linux a user must be
> present and push buttons to get the system to boot off of install media.

That's not necessarily true.

> If a user is present a user presence test may be used to prevent a
> bootloader signed with  Microsoft's key from booting linux without the
> users consent, and thus prevent Linux from attacking windows users.

As already explained, I don't think that user presence accomplishes
anything.  You need informed consent, and it's impossible to cram that
on a 80x25 screen.  You also need to make sure that you aren't
unnecessarily alarmist.  We don't want a "Linux may harm your
computer" warning.

> Therefore preventing the revokation of a signature with Microsoft's
> signature from your bootloader does not justify elaborate kernel
> modifications to prevent the booting a compromised version of windows.

I don't like this approach, either.

> Furthermore no matter how hard we try with current techniques there will
> eventually be kernel bugs that allow attackers to inject code into the
> kernel.  So attempting to fully close that attack vector is
> questionable.

I suspect we'd need to revoke old binaries after a grace period.  I
guess the Microsoft approach is to revoke only what's actually used
for attacks, but that leads to a lot of unpredictability for our
users.

It's also annoying if we figure out after release that we have to
disable additional kernel functionality because it can be used to
compromise the boot path.  Users will not like that, especially if
they do not use Windows at all.

Personally, I think the only way out of this mess is to teach users
how to disable Secure Boot.
