Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614Ab2KEBJX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 20:09:23 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29203 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752488Ab2KEBJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 20:09:17 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6886"; a="4128628"
Date: Sun, 4 Nov 2012 19:08:59 -0600
From: Richard Kuo <rkuo@codeaurora.org>
To: Shuah Khan <shuah.khan@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, arnd@arndb.de,
        kyungmin.park@samsung.com, m.szyprowski@samsung.com,
        linas@codeaurora.org, linux-hexagon@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, shuahkhan@gmail.com
Subject: Re: [PATCH RFT RESEND linux-next] hexagon: dma-mapping: support
 debug_dma_mapping_error
Message-ID: <20121105010859.GA20521@codeaurora.org>
References: <1351206731.6851.10.camel@lorien2>
 <1351266197.4013.3.camel@lorien2>
 <1351874901.2721.18.camel@lorien2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351874901.2721.18.camel@lorien2>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2012 at 10:48:21AM -0600, Shuah Khan wrote:
> On Fri, 2012-10-26 at 09:43 -0600, Shuah Khan wrote:
> > Add support for debug_dma_mapping_error() call to avoid warning from
> > debug_dma_unmap() interface when it checks for mapping error checked
> > status. Without this patch, device driver failed to check map error
> > warning is generated.
> > 
> > Signed-off-by: Shuah Khan <shuah.khan@hp.com>
> > ---
> >  arch/hexagon/include/asm/dma-mapping.h |    1 +
> >  1 file changed, 1 insertion(+)
> 
> Would you like se this patch go through arch tree or linux-next? Please
> let me know your preference.
> 
> -- Shuah
> > 
> > diff --git a/arch/hexagon/include/asm/dma-mapping.h b/arch/hexagon/include/asm/dma-mapping.h
> > index 85e9935..1957c4c 100644
> > --- a/arch/hexagon/include/asm/dma-mapping.h
> > +++ b/arch/hexagon/include/asm/dma-mapping.h
> > @@ -65,6 +65,7 @@ static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
> >  {
> >  	struct dma_map_ops *dma_ops = get_dma_ops(dev);
> >  
> > +	debug_dma_mapping_error(dev, dma_addr);
> >  	if (dma_ops->mapping_error)
> >  		return dma_ops->mapping_error(dev, dma_addr);
> >  
> 
> 

This looks fine; I'm OK with this going through linux-next.  Thanks!

Acked-by: Richard Kuo <rkuo@codeaurora.org>


-- 

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
