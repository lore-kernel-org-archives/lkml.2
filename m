Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945Ab2HPLZe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 07:25:34 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35039 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab2HPLZc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 07:25:32 -0400
From: Federico Vaga <federico.vaga@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Update VIP to videobuf2 and control framework
Date: Thu, 16 Aug 2012 13:29:11 +0200
Message-ID: <1501953.eRLcjlTouV@harkonnen>
User-Agent: KMail/4.8.5 (Linux/3.5.1-1.fc17.x86_64; KDE/4.8.5; x86_64; ; )
In-Reply-To: <20120801070418.51885637@lwn.net>
References: <1343765829-6006-1-git-send-email-federico.vaga@gmail.com> <201208010841.56941.hverkuil@xs4all.nl> <20120801070418.51885637@lwn.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In data mercoledì 1 agosto 2012 07:04:18, Jonathan Corbet ha scritto:
> On Wed, 1 Aug 2012 08:41:56 +0200
> 
> Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > > The second patch adds a new memory allocator for the videobuf2. I
> > > name it videobuf2-dma-streaming but I think "streaming" is not
> > > the best choice, so suggestions are welcome. My inspiration for
> > > this buffer come from videobuf-dma-contig (cached) version. After
> > > I made this buffer I found the videobuf2-dma-nc made by Jonathan
> > > Corbet and I improve the allocator with some suggestions
> > > (http://patchwork.linuxtv.org/patch/7441/). The VIP doesn't work
> > > with videobu2-dma-contig and I think this solution is easier the
> > > sg.> 
> > I leave this to the vb2 experts. It's not obvious to me why we would
> > need a fourth memory allocator.
> 
> I first wrote my version after observing that performance dropped by a
> factor of three on the OLPC XO 1.75 when using contiguous, coherent
> memory.  If the architecture needs to turn off caching, things really
> slow down, to the point that it's unusable.  There's no real reason
> why a V4L2 device shouldn't be able to use streaming mappings in this
> situation; it performs better and doesn't eat into the limited
> amounts of coherent DMA space available on some systems.
> 
> I never got my version into a mergeable state only because I finally
> figured out how to bludgeon the hardware into doing s/g DMA and didn't
> need it anymore.  But I think it's a worthwhile functionality to
> have, and, with CMA, it could be the preferred mode for a number of
> devices.
> 
> jon

I think that the memory allocator is the most questionable patch, but if 
there are not any other comments I will send my three patches for the 
inclusion. It is summer, time for vacation, so I'll wait for another 
week or two for critical comments and then I will send patches.


-- 
Federico Vaga
