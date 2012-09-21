Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab2IUQRk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 12:17:40 -0400
Received: from smtp.citrix.com ([66.165.176.89]:51786 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541Ab2IUQRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 12:17:39 -0400
X-IronPort-AV: E=Sophos;i="4.80,463,1344211200"; 
   d="scan'208";a="38746322"
Message-ID: <505C9320.8030905@citrix.com>
Date: Fri, 21 Sep 2012 17:17:36 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: David Vrabel <david.vrabel@citrix.com>,
        Oliver Chick <oliver.chick@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@suse.com>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: Re: [Xen-devel] [PATCH] Persistent grant maps for xen blk drivers
References: <1348051887-21885-1-git-send-email-oliver.chick@citrix.com>	<505AF126.2050806@citrix.com>	<1348140637.24539.32.camel@oliverchick-Precision-WorkStation-T3400>	<505B1EB9020000780009CA6E@nat28.tlf.novell.com>	<505C5C54.4060100@citrix.com> <20120921142733.GB3389@phenom.dumpdata.com>
In-Reply-To: <20120921142733.GB3389@phenom.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/09/12 15:27, Konrad Rzeszutek Wilk wrote:
> On Fri, Sep 21, 2012 at 01:23:48PM +0100, David Vrabel wrote:
>>
>> It's not just virtual space.  blkback in pvops kernels allocates its
>> pages from the balloon and if there aren't enough ballooned out pages it
>> has to allocate real pages (releasing the MFN back to Xen).
>>
>> Classic kernels didn't need to do this as there was an API for allocate
>> new "empty" struct page's that get mapped into kernel space.
> 
> Can we ressurect/implement that in the new pvops? We could use the memory
> hotplug mechanism to allocate "non-existent" memory. 

I don't see why not.  Provided the limitations are documented I wouldn't
make merging the persistent grant stuff dependent on it.

David
