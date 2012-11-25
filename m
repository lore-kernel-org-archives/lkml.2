Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab2KYOyv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 09:54:51 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:36432 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753098Ab2KYOyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 09:54:24 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, "Svahn, Kai" <kai.svahn@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Huang Ying <ying.huang@intel.com>,
        "Lan, Tianyu" <tianyu.lan@intel.com>, "Zheng, Lv" <lv.zheng@intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 0/2] ACPI / platform: Put devices enumerated via ACPI into D0 before probing drivers
Date: Sun, 25 Nov 2012 15:54:14 +0100
Message-ID: <1672179.qgDUs0YdYu@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc6; KDE/4.9.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

The following two patches are meant to work around a problem where some
devices may be in the ACPI D3cold power state (power off) before their
drivers' .probe() routines are called, but those routines assume devices
to be operational.  They also allow ACPI PM to be used going forward with
the devices in question.

[1/2] - Allow ACPI PM attach/detach routines to change device power states.
[2/2] - Call the ACPI PM attach/detach routines in the platform probe and
        remove/shutdown callbacks (and change power states of devices as
        necessary).

The patches are on top of the current linux-next branch of the linux-pm.git
tree.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
