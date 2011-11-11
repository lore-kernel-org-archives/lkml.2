Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146Ab1KKQFe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 11:05:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753694Ab1KKQFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 11:05:33 -0500
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: Disable ASPM on various devices 
Date: Fri, 11 Nov 2011 11:05:05 -0500
Message-Id: <1321027511-31229-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.41.104
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the firmware has given us control of PCIe capabilities then it's valid
for an operating system to configure ASPM more aggressively than the
firmware did. A small number of devices object to this and exhibit various
failure modes. Windows provides a mechanism to disable ASPM in the driver,
indicated by the Needs=PciASPMOptOut statement in the .inf file. Trawling
through Windows drivers has indicated the following set of hardware that
disables ASPM in Windows but doesn't currently disable it in Linux. It makes
sense for us to mimic Windows in this situation.

