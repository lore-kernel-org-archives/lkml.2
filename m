Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868Ab2EAAcV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 20:32:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50643 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757798Ab2EAAcT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 20:32:19 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo6Wbjh_pzDOkGRoog2WeJQET9UT0fiaanV0r15pq7hT6Q@mail.gmail.com>
References: <1332135781-13695-1-git-send-email-yinghai@kernel.org>
	<1332135781-13695-5-git-send-email-yinghai@kernel.org>
	<CAErSpo6Wbjh_pzDOkGRoog2WeJQET9UT0fiaanV0r15pq7hT6Q@mail.gmail.com>
Date: Mon, 30 Apr 2012 17:32:18 -0700
X-Google-Sender-Auth: HdkkKDWhL6z_5XZd-OaVWxvZVfg
Message-ID: <CAE9FiQV0XTd_1Ujz=tb6BSuwJvJ9nbT_GbE2PREtgMGv=yG0+g@mail.gmail.com>
Subject: Re: [PATCH -v11 04/30] PCI: Add busn_res into struct pci_bus.
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>, Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 4:25 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> --- a/include/linux/pci.h
>> +++ b/include/linux/pci.h
>> @@ -419,6 +419,7 @@ struct pci_bus {
>>        struct list_head slots;         /* list of slots on this bus */
>>        struct resource *resource[PCI_BRIDGE_RESOURCE_NUM];
>>        struct list_head resources;     /* address space routed to this bus */
>> +       struct resource busn_res;       /* track registered bus num range */
>>
>>        struct pci_ops  *ops;           /* configuration access functions */
>>        void            *sysdata;       /* hook for sys-specific extension */
>
> struct pci_bus already includes "secondary" and "subordinate".    This
> new "busn_res" looks like it will contain the same information.  Why
> do we need both?

In some case the could be different.
for root bus from _CRS, busn_res could bigger than subordinate,
because scan_childbus will update subordinate.

and also we have one resource to insert it into the resource tree, so
later could probe/allocate bus num range.

Yinghai
