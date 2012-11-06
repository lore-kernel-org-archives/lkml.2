Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab2KFVwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 16:52:39 -0500
Received: from ka.mail.enyo.de ([87.106.162.201]:54478 "EHLO ka.mail.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210Ab2KFVwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 16:52:37 -0500
From: Florian Weimer <fw@deneb.enyo.de>
To: Chris Friesen <chris.friesen@genband.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Pavel Machek <pavel@ucw.cz>, Eric Paris <eparis@parisplace.org>,
        Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oneukum@suse.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Josh Boyer <jwboyer@gmail.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
References: <20121104135251.GA17894@srcf.ucam.org>
	<87d2zsmv8r.fsf@xmission.com> <509766DB.9090906@zytor.com>
	<87625kh5r2.fsf@xmission.com> <20121105123858.GB4374@srcf.ucam.org>
	<87sj8nc137.fsf@xmission.com> <20121105202557.GA16076@srcf.ucam.org>
	<87hap3zbw7.fsf@xmission.com> <20121106031219.GB24235@srcf.ucam.org>
	<87fw4nv1vj.fsf@xmission.com> <20121106035352.GA24698@srcf.ucam.org>
	<87hap3s3yl.fsf@xmission.com> <878vafqi5q.fsf@mid.deneb.enyo.de>
	<50992946.4060101@genband.com>
Date: Tue, 06 Nov 2012 22:51:59 +0100
In-Reply-To: <50992946.4060101@genband.com> (Chris Friesen's message of "Tue,
	06 Nov 2012 09:14:14 -0600")
Message-ID: <87625iwgao.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Chris Friesen:

> On 11/06/2012 01:56 AM, Florian Weimer wrote:
>
>> Personally, I think the only way out of this mess is to teach users
>> how to disable Secure Boot.
>
> If you're going to go that far, why not just get them to install a
> RedHat (or SuSE, or Ubuntu, or whoever) key and use that instead?

Behind that key, considerable infrastructure is needed, and the
challenges are not purely technical.  I don't expect many such keys as
a result.

> Secure boot does arguably solve a class of problems, so it seems a bit
> odd to recommend just throwing it out entirely.

I have never seen a Linux system with a compromised boot path.  Surely
they exist out there, but they are rare.  It's also relatively simple
to detect such a compromise on disk, from the outside.  Secure Boot
doesn't even allow you to safely boot from PXE because Fedora's shim
will automatically load an initrd which wipes all your disks.  (Safe
booting from network would be a compelling feature, but it's not in
the focus of Secure Boot; that's client-only technology at the
moment.)

Some side effects, such as the end of proprietary kernel modules, may
be desirable.  But others are not, like missing hibernate support (or
perhaps even X).
