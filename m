Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab2JHIKT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 04:10:19 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:36171 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284Ab2JHIKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 04:10:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Huang Ying <ying.huang@intel.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Lan Tianyu <tianyu.lan@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        Jean Pihet <j-pihet@ti.com>, linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/7] PM / QoS: Support for PM QoS device flags
Date: Mon, 08 Oct 2012 10:02:39 +0200
Message-ID: <1413438.1MkXj8vjQK@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.6.0-2.10-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <201209282351.10663.rjw@sisk.pl>
References: <201209282351.10663.rjw@sisk.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

On Friday 28 of September 2012 23:51:10 Rafael J. Wysocki wrote:
> 
> The following patch series extends the existing device PM QoS core code to
> support PM QoS flags representing binary (on/off) requirements, such as
> whether or not power may be removed entirely from the device or whether
> or not remote wakeup (i.e. signalling of external events while suspended)
> should work for it.
> 
> [1/7] Prepare PM QoS device structure for adding more constraint types.
> [2/7] Introduce request and constraint data types for PM QoS flags.
> [3/7] Prepare struct dev_pm_qos_request for representing more request types. 
> [4/7] Introduce device PM QoS flags support.
> [5/7] Make it possible to expose PM QoS device flags to user space.
> [6/7] PM / Domains: Check device PM QoS flags in pm_genpd_poweroff().
> [7/7] PM / ACPI: Take device PM QoS flags into account.
> 
> The last two patches make the generic PM domains framework and ACPI / PCI,
> respectively, take the PM QoS device flags introduced by patch [5/7] into
> accont when making their decisions.
> 
> The changelogs describe the details, but if anything isn't clear, please let
> me know.

Time for a real submission, it seems. :-)

The changes since the previous iteration are addressed comments and a small
optimization in patch [5/7] (it won't resume the device if the setting is not
going to change in dev_pm_qos_update_flags()).

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
