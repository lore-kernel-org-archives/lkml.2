Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545Ab2IDPMd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 11:12:33 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:45638 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932382Ab2IDPMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 11:12:31 -0400
X-IronPort-AV: E=Sophos;i="4.80,367,1344211200"; 
   d="scan'208";a="14339329"
Message-ID: <50461A59.2050504@citrix.com>
Date: Tue, 4 Sep 2012 16:12:25 +0100
From: Stefano Panella <stefano.panella@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] [PATCH 1/1] XEN: Use correct masking in xen_swiotlb_alloc_coherent.
References: <1346407072-6405-1-git-send-email-stefano.panella@citrix.com> <5040B249.4000306@citrix.com> <20120831164010.GA18929@localhost.localdomain> <50460B2E.3020200@citrix.com> <20120904143731.GC23361@phenom.dumpdata.com> <50461654.5040901@citrix.com>
In-Reply-To: <50461654.5040901@citrix.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2012 03:55 PM, David Vrabel wrote:
> On 04/09/12 15:37, Konrad Rzeszutek Wilk wrote:
>> On Tue, Sep 04, 2012 at 03:07:42PM +0100, Stefano Panella wrote:
>>> So if hwdev->coherent_dma_mask is set to 0xffffffffffffffff our dma_mask will
>>> be u64 set to 0xffffffffffffffff even if we set it to DMA_BIT_MASK(32) previously.
>> That is what I was missing. Let me include that in the git commit and also
>> put this patch on the stable tree.
> Note that this appears to be a work around for a bug in the sound system
> or Intel HDA device driver which is incorrectly truncating a dma_addr_t
> to a u32.  So by ensuring a DMA_BIT_MASK(32) when the dma_addr_t is
> truncated it still works.
>
> David
Sorry David, I am not completely sure I understand your argument in 
favour of a bug in the
sound system or Intel HDA device driver. Could you please elaborate more 
in detail about this?

Thanks,

Stefano
