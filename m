Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264Ab2BCRTU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 12:19:20 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55745 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050Ab2BCRTQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 12:19:16 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo44bef-Vj4LPB0QJ8HRjWxqRFK_=kpMq8hYEe=4t58zGQ@mail.gmail.com>
References: <1328136242-17725-1-git-send-email-yinghai@kernel.org>
	<1328136242-17725-3-git-send-email-yinghai@kernel.org>
	<CAErSpo44bef-Vj4LPB0QJ8HRjWxqRFK_=kpMq8hYEe=4t58zGQ@mail.gmail.com>
Date: Fri, 3 Feb 2012 09:19:16 -0800
X-Google-Sender-Auth: g4aV8jnK46Utxq9R9nmlKQ0NChQ
Message-ID: <CAE9FiQX0+t_Ta76=TWS_xdUwrHrrr5ZPBTaeqFeH9WopYEnS+Q@mail.gmail.com>
Subject: Re: [PATCH 02/15] PCI: Add iobusn_resource
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 3, 2012 at 8:36 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Wed, Feb 1, 2012 at 2:43 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> also add busn_res into struct pci_bus.
>>
>> will use them to have bus number resource tree.
>
> Will you make this tree visible in /proc?  Seems like that would be
> useful for debugging and for symmetry with /proc/iomem and
> /proc/ioports.

will give it try.

>
...
>> @@ -419,6 +419,7 @@ struct pci_bus {
>>        struct list_head slots;         /* list of slots on this bus */
>>        struct resource *resource[PCI_BRIDGE_RESOURCE_NUM];
>>        struct list_head resources;     /* address space routed to this bus */
>> +       struct resource busn_res;       /* track registered bus num range */
>
> Is this different from bus.secondary and bus.subordinate?  Do we need
> both busn_res and secondary/subordinate?  If we need both, in what
> circumstance with they contain different information?

yes,  sometime it

for non-peer root bus just after scan. and at that time will set
busn_res.end correctly according to subordinate.

for peer root bus, busn_res.end could be bigger than bus subordinate

Yinghai
