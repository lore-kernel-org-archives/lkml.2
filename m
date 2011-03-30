Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630Ab1C3Jao (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 05:30:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49618 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125Ab1C3Jan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 05:30:43 -0400
Date: Wed, 30 Mar 2011 05:30:41 -0400
From: "'Christoph Hellwig'" <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Sean Noonan <Sean.Noonan@twosigma.com>,
        "'Christoph Hellwig'" <hch@infradead.org>,
        "'Michel Lespinasse'" <walken@google.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        Martin Bligh <Martin.Bligh@twosigma.com>,
        Trammell Hudson <Trammell.Hudson@twosigma.com>,
        Christos Zoulas <Christos.Zoulas@twosigma.com>,
        "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>,
        Stephen Degler <Stephen.Degler@twosigma.com>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>
Subject: Re: XFS memory allocation deadlock in 2.6.38
Message-ID: <20110330093041.GB21819@infradead.org>
References: <081DDE43F61F3D43929A181B477DCA95639B5327@MSXAOA6.twosigma.com>
 <20110324174311.GA31576@infradead.org>
 <AANLkTikwwRm6FHFtEdUg54NvmKdswQw-NPH5dtq1mXBK@mail.gmail.com>
 <081DDE43F61F3D43929A181B477DCA95639B5349@MSXAOA6.twosigma.com>
 <BANLkTin0jJevStg5P2hqsLbqMzo3o30sYg@mail.gmail.com>
 <081DDE43F61F3D43929A181B477DCA95639B534E@MSXAOA6.twosigma.com>
 <081DDE43F61F3D43929A181B477DCA95639B5359@MSXAOA6.twosigma.com>
 <20110329192434.GA10536@infradead.org>
 <081DDE43F61F3D43929A181B477DCA95639B535D@MSXAOA6.twosigma.com>
 <20110330000942.GI3008@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110330000942.GI3008@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 11:09:42AM +1100, Dave Chinner wrote:
> +	ext_buffer = kmem_alloc(XFS_IFORK_SIZE(ip, whichfork),
> +							KM_SLEEP | KM_NOFS);

The old code didn't use KM_NOFS, and I don't think it needed it either,
as we call the iop_format handlers inside the region covered by the
PF_FSTRANS flag.

Also I think the   routine needs to be under #ifndef XFS_NATIVE_HOST, as
we do not use it for big endian builds.
