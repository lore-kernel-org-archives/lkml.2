Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab2HANEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 09:04:20 -0400
Received: from tex.lwn.net ([70.33.254.29]:49168 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121Ab2HANET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 09:04:19 -0400
Date: Wed, 1 Aug 2012 07:04:18 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Federico Vaga <federico.vaga@gmail.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Update VIP to videobuf2 and control framework
Message-ID: <20120801070418.51885637@lwn.net>
In-Reply-To: <201208010841.56941.hverkuil@xs4all.nl>
References: <1343765829-6006-1-git-send-email-federico.vaga@gmail.com>
	<201208010841.56941.hverkuil@xs4all.nl>
Organization: LWN.net
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Aug 2012 08:41:56 +0200
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> > The second patch adds a new memory allocator for the videobuf2. I name it
> > videobuf2-dma-streaming but I think "streaming" is not the best choice, so
> > suggestions are welcome. My inspiration for this buffer come from
> > videobuf-dma-contig (cached) version. After I made this buffer I found the
> > videobuf2-dma-nc made by Jonathan Corbet and I improve the allocator with
> > some suggestions (http://patchwork.linuxtv.org/patch/7441/). The VIP doesn't
> > work with videobu2-dma-contig and I think this solution is easier the sg.  
> 
> I leave this to the vb2 experts. It's not obvious to me why we would need
> a fourth memory allocator.

I first wrote my version after observing that performance dropped by a
factor of three on the OLPC XO 1.75 when using contiguous, coherent
memory.  If the architecture needs to turn off caching, things really slow
down, to the point that it's unusable.  There's no real reason why a V4L2
device shouldn't be able to use streaming mappings in this situation; it
performs better and doesn't eat into the limited amounts of coherent DMA
space available on some systems.

I never got my version into a mergeable state only because I finally
figured out how to bludgeon the hardware into doing s/g DMA and didn't
need it anymore.  But I think it's a worthwhile functionality to have,
and, with CMA, it could be the preferred mode for a number of devices.

jon
