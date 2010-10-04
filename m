Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab0JDSXD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 14:23:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39962 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755256Ab0JDSXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 14:23:01 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Runtime PM: Improve support for PCI devices 
Date: Mon,  4 Oct 2010 14:22:24 -0400
Message-Id: <1286216549-5438-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.202
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right now we only support runtime PCI PM on devices that provide GPE methods.
That's not strictly necessary - we can find GPE associations from the _PRW
data and then install our own handlers. This patchset provides support for
allowing ACPI handlers to be installed for PCI devices and enables runtime
PM on a wider range of machines (Thinkpads, for instance). It also adds
support for polling legacy PCI devices to see if their PME flag has gone
high, since some vendors appear to have decided that copper is a sufficiently
precious resource that attaching that to anything would be an unnecessary
extravagence.

