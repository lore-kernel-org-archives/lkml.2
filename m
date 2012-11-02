Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033Ab2KBUPd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 16:15:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34832 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753451Ab2KBUPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 16:15:32 -0400
Subject: Re: [PATCH RFT RESEND linux-next] c6x: dma-mapping: support
 debug_dma_mapping_error
From: Mark Salter <msalter@redhat.com>
To: shuah.khan@hp.com
Cc: Andrew Morton <akpm@linux-foundation.org>, a-jacquiot@ti.com,
        linux-c6x-dev@linux-c6x.org, LKML <linux-kernel@vger.kernel.org>,
        shuahkhan@gmail.com
Date: Fri, 02 Nov 2012 16:15:25 -0400
In-Reply-To: <1351885999.3161.11.camel@lorien2>
References: <1351206082.6851.6.camel@lorien2>
	 <1351266055.4013.1.camel@lorien2> <1351874655.2721.16.camel@lorien2>
	 <1351883445.15973.24.camel@deneb.redhat.com>
	 <1351885999.3161.11.camel@lorien2>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1351887326.15973.35.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-02 at 13:53 -0600, Shuah Khan wrote:
> On Fri, 2012-11-02 at 15:10 -0400, Mark Salter wrote:
> > On Fri, 2012-11-02 at 10:44 -0600, Shuah Khan wrote:
> > > On Fri, 2012-10-26 at 09:40 -0600, Shuah Khan wrote:
> > > > Add support for debug_dma_mapping_error() call to avoid warning from
> > > > debug_dma_unmap() interface when it checks for mapping error checked
> > > > status. Without this patch, device driver failed to check map error
> > > > warning is generated.
> > > > 
> > > > Signed-off-by: Shuah Khan <shuah.khan@hp.com>
> > > > ---
> > > >  arch/c6x/include/asm/dma-mapping.h |    1 +
> > > >  1 file changed, 1 insertion(+)
> > 
> > > Would you like to this patch go through c6x arch tree or linux-next?
> > > Please let me know your preference.
> > 
> > I tried to test this but I get a build error with CONFIG_DMA_API_DEBUG:
> > 
> > /linux-next/lib/dma-debug.c: In function 'has_mapping_error':
> > /linux-next/lib/dma-debug.c:863:15: error: implicit declaration of function 'get_dma_ops' [-Werror=implicit-function-declaration]
> > /linux-next/lib/dma-debug.c:863:34: warning: initialization makes pointer from integer without a cast [enabled by default]
> > 
> > C6X (along with some other architectures) doesn't have a get_dma_ops()
> > function defined.
> 
> That is a problem I didn't think about. I did a check and looks like c6x
> and frv are the only ones that don't have get_dma_ops() defined. frv is

By my count, there are 14 architectures with get_dma_ops() and 14
without.

> in a different category as it doesn't use dma_debug interfaces. IN the
> case c6x, now with my change to add debug_dma_mapping_error(), we will
> start seeing warnings since dma_map_page() and dma_map_single() are
> debugged with a call to debug_dma_map_page() and the corresponding
> dma_mapping_error() interface doesn't call debug_dma_mapping_error()
> interface
> 
> - Does adding get_dma_ops() make sense? Doesn't look like c6x exports
> dma_ops?
> 
> Any other ideas?

I'm not sure. I don't know what get_dma_ops() does and it doesn't seem
to be documented anywhere.



