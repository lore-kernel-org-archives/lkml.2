Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030933Ab2LGVaX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 16:30:23 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55193 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030916Ab2LGVaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 16:30:20 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo6MEtx6hsYhY=h0+eXqQcnZuG2vq=z_8Oz8tnksKZd7DA@mail.gmail.com>
References: <20121207062454.11051.12739.stgit@amt.stowe>
	<20121207062500.11051.44198.stgit@amt.stowe>
	<CAErSpo6MEtx6hsYhY=h0+eXqQcnZuG2vq=z_8Oz8tnksKZd7DA@mail.gmail.com>
Date: Fri, 7 Dec 2012 13:30:18 -0800
X-Google-Sender-Auth: HdtRe2l7oKSrfoZ6zL0hEtDNDCg
Message-ID: <CAE9FiQV6L2ZUEVHM2CCdqZfB9Yij7OGYZ-xsEpzCdXU2hSHnsQ@mail.gmail.com>
Subject: Re: [PATCH 01/15] PCI, acpiphp: Separate out hot-add support of pci
 host bridge
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Myron Stowe <myron.stowe@redhat.com>, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 7, 2012 at 11:32 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Thu, Dec 6, 2012 at 11:25 PM, Myron Stowe <myron.stowe@redhat.com> wrote:
>> From: Yinghai Lu <yinghai@kernel.org>
>>
>>
> For example, as soon as you put this code in pci_root.c instead of
> pci_root_hp.c, it becomes obvious that we're keeping a list of host
> bridges in both places, and we probably don't need two lists.  And it
> seems dubious that acpi_pci_root_hp_init() is an initcall that walks
> the namespace looking for host bridges, when acpi_pci_root_add()
> already exists and is called for every host bridge.

removed the duplicated interface in following patch.

http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-yinghai.git;a=shortlog;h=refs/heads/for-pci-split-pci-root-hp-2

http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-yinghai.git;a=commitdiff;h=a1d1ef3f5e4932bc672d96dedd11c5d58f7f20f5

| [PATCH] PCI, ACPI: remove acpi_root_bridge in pci_root_hp
|
| Tang noticed that hotplug through container will not update acpi_root_bridge
| list.
|
| After closely checking, we don't need that for struct for tracking and
| could use acpi_pci_root directly.
