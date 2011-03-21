Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932373Ab1CUXTw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:19:52 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:59537 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932130Ab1CUXTt convert rfc822-to-8bit (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 21 Mar 2011 19:19:49 -0400
Date: Mon, 21 Mar 2011 19:18:35 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
Cc: dri-devel@lists.freedesktop.org, thomas@shipmail.org, airlied@linux.ie,
        linux-kernel@vger.kernel.org, konrad@darnok.org
Subject: Re: [RFC PATCH v2] Utilize the PCI API in the TTM framework.
Message-ID: <20110321231835.GA20159@dumpdata.com>
References: <1294420304-24811-1-git-send-email-konrad.wilk@oracle.com>
 <1300713067.8042.13.camel@thor.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1300713067.8042.13.camel@thor.local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4D87DCD2.00BD,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 02:11:07PM +0100, Michel Dänzer wrote:
> On Fre, 2011-01-07 at 12:11 -0500, Konrad Rzeszutek Wilk wrote: 
> > 
> > 1) The 'NULL' when doing dma_alloc_coherent is unsightly. I was toying
> > with modifying the TTM API to pass in 'struct device' or 'struct pci_device'
> > but figured it would make first sense to get your guys input before heading that route.
> 
> It's worse than unsightly: It breaks TTM on PPC. See
> arch/powerpc/include/asm/dma-mapping.h: get_dma_ops() returns NULL if
> NULL is passed in for the device, and most of its callers BUG in that
> case. The exception being dma_supported(), so a possible solution might
> be to use that for checking if dma_alloc_coherent can be used.
> 
> Dave, please prevent this change from entering mainline before there's a
> solution for this.

We do have a fix for it: 

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git devel/ttm.pci-api.v5

Can you tell me if that works for you?
