Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280Ab2JRObH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 10:31:07 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:37780 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810Ab2JRObE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 10:31:04 -0400
Message-ID: <1350570659.2680.5.camel@lorien2>
Subject: Re: [PATCH] Documentation DMA-API-HOWTO.txt Add dma mapping error
 check usage examples
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: mtk.manpages@gmail.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>, konrad.wilk@oracle.com,
        rob@landley.net, joerg.roedel@amd.com, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        shuahkhan@gmail.com
Date: Thu, 18 Oct 2012 08:30:59 -0600
In-Reply-To: <CAKgNAkhx2trGUMCbpYbKbMYYjq9oTeAnqG436_MP2t6noA3K-g@mail.gmail.com>
References: <1350230064.4069.1.camel@lorien2> <20121018094715.GC5685@mwanda>
	 <CAKgNAkhx2trGUMCbpYbKbMYYjq9oTeAnqG436_MP2t6noA3K-g@mail.gmail.com>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-18 at 12:13 +0200, Michael Kerrisk (man-pages) wrote:
> On Thu, Oct 18, 2012 at 11:47 AM, Dan Carpenter
> <dan.carpenter@oracle.com> wrote:
> > On Sun, Oct 14, 2012 at 09:54:24AM -0600, Shuah Khan wrote:
> >> diff --git a/Documentation/DMA-API-HOWTO.txt b/Documentation/DMA-API-HOWTO.txt
> >> index a0b6250..cf1adb4 100644
> >> --- a/Documentation/DMA-API-HOWTO.txt
> >> +++ b/Documentation/DMA-API-HOWTO.txt
> >> @@ -468,11 +468,46 @@ To map a single region, you do:
> >>       size_t size = buffer->len;
> >>
> >>       dma_handle = dma_map_single(dev, addr, size, direction);
> >> +     if (unlikely(dma_mapping_error(dma_handle))) {
> >
> > Don't encourage people to put unlikely() and likely() into their
> > driver code.  It should only be used after benchmarking both with
> > and without.  I can't imagine how it would make a measurable
> > difference here.
> 
> (Hi Dan)
> 
> Quite. See http://blog.man7.org/2012/10/how-much-do-builtinexpect-likely-and.html
> 
> I wonder how many blind uses of likely() and unlikely() in the kernel
> are actually degrading performance.
> 
> Cheers,
> 
> Michael


Dan, Michael,

Thanks. I see unlikely() and likely() used widely and didn't realize the
negatives of it. Will fix the examples without the use of unlikely() and
send v2 patch.

Thanks,
-- Shuah


