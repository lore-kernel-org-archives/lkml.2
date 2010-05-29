Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703Ab0E2MQj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 08:16:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756447Ab0E2MQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 08:16:37 -0400
Message-ID: <4C01058B.8020808@redhat.com>
Date: Sat, 29 May 2010 15:16:11 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Tom Lyon <pugs@cisco.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, chrisw@sous-sol.org, joro@8bytes.org,
       hjk@linutronix.de, mst@redhat.com, gregkh@suse.de, aafabbri@cisco.com,
       scofeldm@cisco.com
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
References: <4c004cba.Z/2Hpd7reetFaFC5%pugs@cisco.com> <201005291355.11727.arnd@arndb.de>
In-Reply-To: <201005291355.11727.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2010 02:55 PM, Arnd Bergmann wrote:
> On Saturday 29 May 2010, Tom Lyon wrote:
>    
>> +/*
>> + * Structure for DMA mapping of user buffers
>> + * vaddr, dmaaddr, and size must all be page aligned
>> + * buffer may only be larger than 1 page if (a) there is
>> + * an iommu in the system, or (b) buffer is part of a huge page
>> + */
>> +struct vfio_dma_map {
>> +       __u64   vaddr;          /* process virtual addr */
>> +       __u64   dmaaddr;        /* desired and/or returned dma address */
>> +       __u64   size;           /* size in bytes */
>> +       int     rdwr;           /* bool: 0 for r/o; 1 for r/w */
>> +};
>>      
> Please add a 32 bit padding word at the end of this, otherwise the
> size of the data structure is incompatible between 32 x86 applications
> and 64 bit kernels.
>    

Might as well call it 'flags' and reserve a bit more space (keeping 
64-bit aligned size) for future expansion.

rdwr can be folded into it.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

