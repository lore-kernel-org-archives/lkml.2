Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932426Ab1C3T3Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 15:29:16 -0400
Received: from relay3.sgi.com ([192.48.152.1]:37464 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754838Ab1C3T3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 15:29:15 -0400
Message-ID: <4D938488.7010607@sgi.com>
Date: Wed, 30 Mar 2011 12:29:12 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        iommu@lists.linux-foundation.org, Mike Habeck <habeck@sgi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] Intel iommu: Speed up processing of the identity_mapping
 function
References: <20110329233602.272459647@gulag1.americas.sgi.com> <20110329233602.585251738@gulag1.americas.sgi.com> <20110330191902.GT18712@sequoia.sous-sol.org>
In-Reply-To: <20110330191902.GT18712@sequoia.sous-sol.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Chris Wright wrote:
> * Mike Travis (travis@sgi.com) wrote:
>> @@ -2138,6 +2134,7 @@ static int domain_add_dev_info(struct dm
>>  	list_add(&info->global, &device_domain_list);
>>  	pdev->dev.archdata.iommu = info;
> 
> The si_domain is cached right here...can you not use this instead of
> adding an iommu impl. specific bit to pci_dev?
> 
>>  	spin_unlock_irqrestore(&device_domain_lock, flags);
>> +	pdev->is_identity_mapped = (domain == si_domain);

Yes, it looks like I came at the solution backwards... I added
the bit then figured out how to set it.  I'll update that patch.
