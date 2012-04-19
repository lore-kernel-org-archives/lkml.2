Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab2DSIPN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 04:15:13 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51763 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab2DSIPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 04:15:06 -0400
Message-ID: <A9828EBC1D1743A1BE8627A2400348DD@local.st.by>
From: "Victor Miasnikov" <vvm@tut.by>
To: "KY Srinivasan" <kys@microsoft.com>, "Andy Whitcroft" <apw@canonical.com>,
        "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: "Jeff Garzik" <jgarzik@pobox.com>, <linux-ide@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        "Mike Sterling" <mike.sterling@microsoft.com>
References: <20120414170223.24f6ea31@pyramind.ukuu.org.uk><1334575229-7493-1-git-send-email-apw@canonical.com><20120416122634.7d1357e1@ultron>	<20120416182927.GB3346@shadowen.org><426367E2313C2449837CD2DE46E7EAF92CE0B5@CH1PRD0310MB381.namprd03.prod.outlook.com> <20120418211235.55b9befc@pyramind.ukuu.org.uk> <426367E2313C2449837CD2DE46E7EAF92CE8E2@CH1PRD0310MB381.namprd03.prod.outlook.com>
Subject: 1) boot flag to disable the Hyper-V IDE drivers: ata_piix.prefer_ms_hyperv=0 2) PIIX_IGNORE_ATA_ON_HYPERV Re: [PATCH 0/2] Hyper-V disk support V3 RE: use hv_storvsc instead of ata_piix to handle the IDE disks devices ( but not for the CD-ROM)
Date: Thu, 19 Apr 2012 11:15:01 +0300
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.3790.4548
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4862
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi!

 Shortly:

1) 
The flag to disable the Hyper-V IDE drivers is:
 ata_piix.prefer_ms_hyperv=02)

#ifdef CONFIG_X86 
#if defined(CONFIG_HYPERV_STORAGE) || defined(CONFIG_HYPERV_STORAGE_MODULE)
#define ATA_PIIX_IGNORE_ATA_DISKS_ON_HYPERV 1
#endif
#endif


---

>>Alan Cox:
>> So what ensures that by 
>> skipping it at the ATA device level we will always find it as a VHD ?

> KY Srinivasan:
> So, the check if we are running on Hyper-V is not enough
> to skip the device in the ata_piix driver; 
> we need to also make sure that the Hyper-V block driver is available to handle the skipped devices. 

>  I think the correct approach here is to have a kernel (or an ata_piix module parameter) 
> that can be set to override the skipping of the block device by the ata driver. 

 Already implemented, see:
module_param(prefer_ms_hyperv, int, 0);

 and work as need in real life:

http://www.mail-archive.com/ubuntu-bugs@lists.ubuntu.com/msg3482442.html
==
Tim Miller Dyck
Wed, 14 Mar 2012 07:15:52 -0700
 . . .
The boot flags can be viewed by pressing F5? F6? (one of those) on the
setup boot screen and then navigating to the boot line with cursor keys
and adding the boot parameter below before the double dash at the end of
the line.
The flag to disable the Hyper-V IDE drivers is:

 ata_piix.prefer_ms_hyperv=0  . . .
==
> Distros that are including the Hyper-V storage driver can set this parameter so 
> that when running on Hyper-V, ata can skip the block device.


 Best:
Distros that are not-including the Hyper-V storage driver don't worry about "ata can skip" etc.:

See re-incarnatin Olaf Hering idea:

#ifdef CONFIG_X86 
#if defined(CONFIG_HYPERV_STORAGE) || defined(CONFIG_HYPERV_STORAGE_MODULE)
#define ATA_PIIX_IGNORE_ATA_DISKS_ON_HYPERV 1
#endif
#endif

 and

#ifdef CONFIG_X86 

 replace to

#ifdef ATA_PIIX_IGNORE_ATA_DISKS_ON_HYPERV 


Best regards, Victor Miasnikov
Blog:  http://vvm.blog.tut.by/


