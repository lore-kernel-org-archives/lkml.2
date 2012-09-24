Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347Ab2IXPH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 11:07:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754110Ab2IXPGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 11:06:12 -0400
From: Matthew Garrett <mjg@redhat.com>
To: yakui.zhao@intel.com
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        cminyard@mvista.com
Subject: [RFC] ACPI IPMI changes 
Date: Mon, 24 Sep 2012 11:05:36 -0400
Message-Id: <1348499140-13550-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.206
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ACPI IPMI code doesn't seem to work on many real-world devices. Part of
that is because many shipping systems have a _CID of PNP0C01 or PNP0C02 and
the PNP core never lets the IPMI driver bind, but it's also a problem if
it's being used for AC adapter state (since they're typically built in)
and on some systems that have IPMI opregions declared outside the IPMI
device's scope (spec violation, but what else is new). These patches don't
do anything for the first problem (that's going to have to be handled in
the PNP core) but handle the latter two by ensuring that IPMI can be
initialised before any built-in ACPI drivers, and by providing support for
a fallback IPMI handler that just uses the first IPMI device in the system.

-- 
Matthew Garrett | mjg59@srcf.ucam.org

