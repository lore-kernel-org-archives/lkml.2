Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab3AHOx4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 09:53:56 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:47341 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756455Ab3AHOxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 09:53:53 -0500
From: Federico Vaga <federico.vaga@gmail.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Pawel Osciak <pawel@osciak.com>, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v4 1/3] videobuf2-dma-contig: user can specify GFP flags
Date: Tue, 08 Jan 2013 15:58:37 +0100
Message-ID: <5204825.yR0kSsoYV4@harkonnen>
User-Agent: KMail/4.9.4 (Linux/3.6.10-2.fc17.x86_64; KDE/4.9.4; x86_64; ; )
In-Reply-To: <50EBF7A9.6070802@samsung.com>
References: <1357493343-13090-1-git-send-email-federico.vaga@gmail.com> <1609748.zs7bdcvuG8@harkonnen> <50EBF7A9.6070802@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ok, then I would simply pass the flags from the driver without any
> alternation
> in the allocator itself, so drivers can pass 'GFP_KERNEL' or
> 'GFP_KERNEL | GFP_DMA' depending on their preference. Please also update
> all
> the existing clients of vb2_dma_dc allocator.

I taked a look at drivers that use dma-contig. They use the structure 
vb2_alloc_ctx which is just a name, there is not a real vb2_alloc_ctx 
structure implementation. "Now" driver must gain access to vb2_dc_conf to set 
the correct flags.

I have the following ideas:

  1.  replace all the names and expose vb2_dc_conf to all drivers (like dma-
sg, it export vb2_dma_sg_desc to all its users)

  2.  create an helper which configure flags. This maintain the vb2_dc_conf 
private
      vb2_set_mem_flags(struct vb2_alloc_ctx *alloc_ctx, gfp_t flags)

  3.  rename vb2_dc_conf to vb2_alloc_ctx because it is an implementation 
vb2_alloc_ctx and (at the moment) it is used only by dma-contig

-- 
Federico Vaga
