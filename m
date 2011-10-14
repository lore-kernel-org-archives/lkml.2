Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405Ab1JNE2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 00:28:09 -0400
Received: from smtp-out.google.com ([74.125.121.67]:49969 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932356Ab1JNE2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 00:28:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=d0V/u6aZZpEGNtn9XGw7wTeau+InxtzkKxuXO/mlii0hJxlUltOjq3Qyc68I1OVac
	O0FCVJsq6GwpBH1GYnsdg==
Subject: [PATCH v2 10/29] microblaze/PCI: fix pci_bus_for_each_resource() usage
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-arch@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
        linux-kernel@vger.kernel.org
Date: Thu, 13 Oct 2011 22:27:58 -0600
Message-ID: <20111014042758.23504.52748.stgit@bhelgaas.mtv.corp.google.com>
In-Reply-To: <20111014042142.23504.70417.stgit@bhelgaas.mtv.corp.google.com>
References: <20111014042142.23504.70417.stgit@bhelgaas.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pci_bus_for_each_resource() iterator sets "res" itself, so there's
no need to look it up in the bus->resource[] table.

Logically part of 89a74ecccd and 8a66da71fa.

CC: Michal Simek <monstr@monstr.eu>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/microblaze/pci/pci-common.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/microblaze/pci/pci-common.c b/arch/microblaze/pci/pci-common.c
index 4cfae20..9df5e5b 100644
--- a/arch/microblaze/pci/pci-common.c
+++ b/arch/microblaze/pci/pci-common.c
@@ -1018,7 +1018,6 @@ static void __devinit pcibios_fixup_bridge(struct pci_bus *bus)
 	struct pci_dev *dev = bus->self;
 
 	pci_bus_for_each_resource(bus, res, i) {
-		res = bus->resource[i];
 		if (!res)
 			continue;
 		if (!res->flags)
@@ -1218,7 +1217,6 @@ void pcibios_allocate_bus_resources(struct pci_bus *bus)
 		 pci_domain_nr(bus), bus->number);
 
 	pci_bus_for_each_resource(bus, res, i) {
-		res = bus->resource[i];
 		if (!res || !res->flags
 		    || res->start > res->end || res->parent)
 			continue;

