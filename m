Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab2HWFYN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 01:24:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34530 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362Ab2HWFYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 01:24:10 -0400
MIME-Version: 1.0
Date: Thu, 23 Aug 2012 13:24:08 +0800
Message-ID: <CAFgQCTt82Mu2mhVxeZ01=1bJzuzDWZjBEV58X9xjeEPQY3R8ww@mail.gmail.com>
Subject: pci: question about the life cycle of pci_dev and its parent pci_bus
From: Liu ping fan <kernelfans@gmail.com>
To: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Scott Murray <scott@spiteful.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a question about the life cycle of pci_dev and its parent pci_bus.
In pci_destroy_dev(), we remove the pci_dev from the bus_list, so
pci_dev is isolated from its parent pci_bus, and their life cycle are
independent too. But it seems that in pci_dev, we can still access the
pci_bus from the pointer pci_dev->bus.  To resolve such issue, I think
during the pci_dev removal,  there should be process to 1.prevent the
reader incoming 2. ensure the current reader has exit.  But can not
find them.

Could anyone tell me?

Thanx, pingfan
