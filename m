Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935604Ab2KBTKx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 15:10:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16203 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935357Ab2KBTKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 15:10:52 -0400
Subject: Re: [PATCH RFT RESEND linux-next] c6x: dma-mapping: support
 debug_dma_mapping_error
From: Mark Salter <msalter@redhat.com>
To: shuah.khan@hp.com
Cc: Andrew Morton <akpm@linux-foundation.org>, a-jacquiot@ti.com,
        linux-c6x-dev@linux-c6x.org, LKML <linux-kernel@vger.kernel.org>,
        shuahkhan@gmail.com
Date: Fri, 02 Nov 2012 15:10:44 -0400
In-Reply-To: <1351874655.2721.16.camel@lorien2>
References: <1351206082.6851.6.camel@lorien2>
	 <1351266055.4013.1.camel@lorien2> <1351874655.2721.16.camel@lorien2>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1351883445.15973.24.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-02 at 10:44 -0600, Shuah Khan wrote:
> On Fri, 2012-10-26 at 09:40 -0600, Shuah Khan wrote:
> > Add support for debug_dma_mapping_error() call to avoid warning from
> > debug_dma_unmap() interface when it checks for mapping error checked
> > status. Without this patch, device driver failed to check map error
> > warning is generated.
> > 
> > Signed-off-by: Shuah Khan <shuah.khan@hp.com>
> > ---
> >  arch/c6x/include/asm/dma-mapping.h |    1 +
> >  1 file changed, 1 insertion(+)

> Would you like to this patch go through c6x arch tree or linux-next?
> Please let me know your preference.

I tried to test this but I get a build error with CONFIG_DMA_API_DEBUG:

/linux-next/lib/dma-debug.c: In function 'has_mapping_error':
/linux-next/lib/dma-debug.c:863:15: error: implicit declaration of function 'get_dma_ops' [-Werror=implicit-function-declaration]
/linux-next/lib/dma-debug.c:863:34: warning: initialization makes pointer from integer without a cast [enabled by default]

C6X (along with some other architectures) doesn't have a get_dma_ops()
function defined.


