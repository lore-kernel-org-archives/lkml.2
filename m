Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112Ab2E2Hve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 03:51:34 -0400
Received: from goliath.siemens.de ([192.35.17.28]:20262 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab2E2Hvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 03:51:32 -0400
Message-ID: <4FC47FED.1060000@siemens.com>
Date: Tue, 29 May 2012 09:51:09 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Alexander Graf <agraf@suse.de>, kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH] PCI: Mark INTx masking support of Chelsio T310 10GbE
 NIC as broken
References: <4FBF90E5.8030800@siemens.com> <20120528123934.GB21778@redhat.com> <4FC374CD.5000509@web.de> <20120528132109.GB22623@redhat.com> <4FC37DD6.7090000@web.de> <20120528133946.GA23024@redhat.com>
In-Reply-To: <20120528133946.GA23024@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-05-28 15:39, Michael S. Tsirkin wrote:
> On Mon, May 28, 2012 at 03:29:58PM +0200, Jan Kiszka wrote:
>> On 2012-05-28 15:21, Michael S. Tsirkin wrote:
>>> On Mon, May 28, 2012 at 02:51:25PM +0200, Jan Kiszka wrote:
>>>> On 2012-05-28 14:39, Michael S. Tsirkin wrote:
>>>>> On Fri, May 25, 2012 at 11:02:13AM -0300, Jan Kiszka wrote:
>>>>>> According to Alexey, the T310 does not properly support INTx masking as
>>>>>> it fails to keep the PCI_STATUS_INTERRUPT bit updated once the interrupt
>>>>>> is masked. Mark this adapter as broken so that pci_intx_mask_supported
>>>>>> won't report it as compatible.
>>>>>>
>>>>>> Reported-by: Alexey Kardashevskiy <aik@ozlabs.ru>
>>>>>> Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
>>>>>
>>>>>
>>>>> Just a thought: would be nice to have a way to discover
>>>>> the quirk was activated. Add an attribute so that
>>>>> userspace can detect and report this properly to users?
>>>>> Or just log a warning message ...
>>>>
>>>> pr_notice_once?
>>>
>>> OK IMO.
>>>
>>>> A flag for userspace would be significantly more
>>>> complicated (and not PCI layer hands).
>>>
>>> Why not? I meant e.g. an attribute in pci-sysfs.
>>
>> Possible. But what is the preferred way of doing this? Are there any
>> precedences?
>>
>> Jan
>>
> 
> E.g. a reset attribute is there only if device reset is supported.
> I don't insist on this - merely asking how does userspace report
> an attempt to share IRQs and whether the reason is
> discoverable in some way.

Well, so far there is no attribute associated with INTx masking that we
could hide to express this.

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
