Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036Ab2AERK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 12:10:26 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:45336 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755188Ab2AERKY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 12:10:24 -0500
MIME-Version: 1.0
In-Reply-To: <a2507aff2913b402cfb2d3e2a0bb887a.squirrel@webmail.sf-mail.de>
References: <1325721002-6094-1-git-send-email-yinghai@kernel.org> <a2507aff2913b402cfb2d3e2a0bb887a.squirrel@webmail.sf-mail.de>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 5 Jan 2012 10:10:01 -0700
Message-ID: <CAErSpo7JJBx9QQ13HKm9dX3H8YdrztW7baHfeF-_Joyv1gt7CQ@mail.gmail.com>
Subject: Re: [PATCH] PCI: Increase resource array mask bit size in pcim_iomap_regions()
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 5, 2012 at 1:43 AM, Rolf Eike Beer <eike-kernel@sf-tec.de> wrote:
>> DEVICE_COUNT_RESOURCE will be bigger than 16 when SRIOV supported is
>> enabled.
>>
>> Let them pass with int just like pci_enable_resources().
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>> ---
>>  include/linux/pci.h |    6 +++---
>>  lib/devres.c        |    6 +++---
>>  2 files changed, 6 insertions(+), 6 deletions(-)
>>
>> Index: linux-2.6/include/linux/pci.h
>> ===================================================================
>> --- linux-2.6.orig/include/linux/pci.h
>> +++ linux-2.6/include/linux/pci.h
>> @@ -1433,10 +1433,10 @@ static inline void pci_fixup_device(enum
>>  void __iomem *pcim_iomap(struct pci_dev *pdev, int bar, unsigned long
>> maxlen);
>>  void pcim_iounmap(struct pci_dev *pdev, void __iomem *addr);
>>  void __iomem * const *pcim_iomap_table(struct pci_dev *pdev);
>> -int pcim_iomap_regions(struct pci_dev *pdev, u16 mask, const char *name);
>> -int pcim_iomap_regions_request_all(struct pci_dev *pdev, u16 mask,
>> +int pcim_iomap_regions(struct pci_dev *pdev, int mask, const char *name);
>> +int pcim_iomap_regions_request_all(struct pci_dev *pdev, int mask,
>>                                  const char *name);
> [...]
>
> You are switching from unsigned to signed here, is this intentional? In my
> feeling such masks should end up in an unsigned int, no?

I agree masks should generally be unsigned, but I think it makes sense
to first follow pci_enable_resources() (which uses "int") , and maybe
in the future, convert both to being unsigned.

Bjorn
