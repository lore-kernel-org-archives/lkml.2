Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659Ab0HSIjD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 04:39:03 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36322 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab0HSIjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 04:39:00 -0400
Date: Thu, 19 Aug 2010 04:38:39 -0400
From: Christoph Hellwig <hch@infradead.org>
To: device-mapper development <dm-devel@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Vladislav Bolkhovitin <vst@vlnb.net>,
        linux-kernel@vger.kernel.org, Bryan Mesich <bryan.mesich@ndsu.edu>,
        Jens Axboe <jens.axboe@kernel.dk>, linux-raid@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>, scst-devel@lists.sourceforge.net,
        stable@kernel.org
Subject: Re: [dm-devel] [PATCH RESEND 1/2 block#for-linus] bio, fs: update
 READA and SWRITE to match the corresponding BIO_RW_* bits
Message-ID: <20100819083839.GA32336@infradead.org>
References: <4C3EF3AD.5070509@vlnb.net>
 <20100723191844.GB31152@atlantis.cc.ndsu.nodak.edu>
 <4C4D7DF5.9060909@vlnb.net>
 <20100727220110.GF31152@atlantis.cc.ndsu.nodak.edu>
 <4C5073F3.1060406@vlnb.net>
 <4C52A98A.7060507@kernel.org>
 <20100802104227.79340b49@notabene>
 <4C56D30A.3000403@kernel.org>
 <x49y6ckc302.fsf@segfault.boston.devel.redhat.com>
 <4C5B89DB.5050106@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C5B89DB.5050106@oracle.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 06, 2010 at 12:04:43PM +0800, Tao Ma wrote:
> >>Stable: The offending commit a82afdf was released with v2.6.32, so
> >>this patch should be applied to all kernels since then but it must
> >>_NOT_ be applied to kernels earlier than that.
> If only this patch goes into stable, do we need to change RWA_MASK
> in this patch also(I have seen you change it the 2/2)?
> 
> -#define RWA_MASK        2
> +#define RWA_MASK        16

I think RW_MASK and RWA_MASK should simply go away, they don't server
any use over just masking the correct REQ_* flags.

