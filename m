Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029Ab1C2Bzh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 21:55:37 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:41156 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114Ab1C2Bzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 21:55:36 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Shyam_Iyer@Dell.com, jbarnes@virtuousgeek.org, mjg59@srcf.ucam.org,
        Narendra_K@Dell.com, viro@zeniv.linux.org.uk, sfr@canb.auug.org.au,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Matt_Domsch@Dell.com, Charles_Rose@Dell.com, Jordan_Hargrave@Dell.com
Subject: Re: [PATCH] Fix build failure when CONFIG_NLS is set to 'm' by allmodconfig
References: <20110223131536.GA16707@fedora14-r610.blr.amer.dell.com>
	<20110223131734.GA6275@srcf.ucam.org>
	<20110304101509.7eef7475@jbarnes-desktop>
	<20110328080220.1390d28e.randy.dunlap@oracle.com>
	<DBFB1B45AF80394ABD1C807E9F28D15702659CFB3D@BLRX7MCDC203.AMER.DELL.COM>
	<4D90EDE8.9070306@oracle.com>
Date: Tue, 29 Mar 2011 10:55:27 +0900
In-Reply-To: <4D90EDE8.9070306@oracle.com> (Randy Dunlap's message of "Mon, 28
	Mar 2011 13:22:00 -0700")
Message-ID: <87oc4u4rn4.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap <randy.dunlap@oracle.com> writes:

>> I don't get this.. you should not be getting CONFIG_NLS=m unless you
>> have stripped you config files really.. :-) Is it possible to get
>> your .config to hit this issue.
>
> I haven't stripped any config files -- but they are randconfig files.
> Two (2) config files that cause build failures are attached.

config PCI_IOAPIC
	bool
	depends on PCI
	depends on ACPI
	depends on HOTPLUG
	default y

select NLS if (DMI || ACPI)

I guess this is simply wrong. It will be parsed as

config PCI_IOAPIC
	bool
	depends on PCI
	depends on ACPI
	depends on HOTPLUG
	default y
	select NLS if (DMI || ACPI)

How about something like the following?

config PCI_LABEL
	bool
        select NLS
        depends on (DMI || ACPI)
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
