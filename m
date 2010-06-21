Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906Ab0FUNIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 09:08:54 -0400
Received: from mail-in-13.arcor-online.net ([151.189.21.53]:59204 "EHLO
	mail-in-13.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757878Ab0FUNIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 09:08:52 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-08.arcor-online.net 7E02D205865
Message-ID: <24732538.1277125730475.JavaMail.ngmail@webmail17.arcor-online.net>
Date: Mon, 21 Jun 2010 15:08:50 +0200 (CEST)
From: screamingfist@arcor.de
To: jkosina@suse.cz, erazor_de@users.sourceforge.net
Subject: Aw: Re: [PATCH] HID: removing obsolete kone_abi_version sysfs attr
 for roccat kone
Cc: rdunlap@xenotime.net, sfr@canb.auug.org.au, tj@kernel.org,
       linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ngMessageSubType: MessageSubType_MAIL
X-WebmailclientIP: 138.246.7.174
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 ----- Original Nachricht ----
Von:     Jiri Kosina <jkosina@suse.cz>
An:      Stefan Achatz <erazor_de@users.sourceforge.net>
Datum:   21.06.2010 14:06
Betreff: Re: [PATCH] HID: removing obsolete kone_abi_version sysfs attr for
 roccat kone

> On Fri, 18 Jun 2010, Stefan Achatz wrote:
> 
> > The newest version of the accompanying userland tools cuts backward
> > compatibility and uses libudev to find its devices superseding the
> > quirky kone_abi_version sysfs attribute. Therefore it should be removed.
> 
> How backwards incompatible this change actually is?
> 
> What happens if you run old userspace tool (the one which looks for 
> kone_abi_version) on a kernel with this patch applied?

Now there is one legacy version of the tool which looks for kone_driver_version and which will not be developed further cause I'm at a dead end with scanning sysfs directly.

The renamed attribute kone_abi_version is unreleased and at current only in your roccat branch so there's no need for the tool to look for that.

For the next features i want to implement in the tool I need the path to the sysfs attributes, the roccat char device and the two hidraw devices (mouse and keyboard endpoints) corresponding to one device. I'm doing this with libudev and not with manually crawling through sysfs. This code only works with kone as hid-driver and with the relatively young libudev taken into account my old kone and roccat modules for kernels prior 2.6.28 won't work either.
To make a long story short:
People with kernel versions < 2.6.28 and without libudev have to use the legacy tools with limited functionality.
Users with kernel versions >= 2.6.28 (using the modules my distibuted package or the official from 2.6.35 on) and with libudev should use the newest version of my tools with increasing functionality.

Have a nice day,
Stefan
