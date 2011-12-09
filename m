Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab1LIWvM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 17:51:12 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4827 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab1LIWvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 17:51:10 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 09 Dec 2011 14:50:56 -0800
Date: Fri, 9 Dec 2011 14:50:56 -0800
From: Robert Morell <rmorell@nvidia.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sumit Semwal <sumit.semwal@ti.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "jesse.barker@linaro.org" <jesse.barker@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "daniel@ffwll.ch" <daniel@ffwll.ch>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [Linaro-mm-sig] [RFC v2 1/2] dma-buf: Introduce dma buffer
 sharing mechanism
Message-ID: <20111209225056.GL7969@morell.nvidia.com>
References: <1322816252-19955-1-git-send-email-sumit.semwal@ti.com>
 <1322816252-19955-2-git-send-email-sumit.semwal@ti.com>
 <201112051718.48324.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112051718.48324.arnd@arndb.de>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 09:18:48AM -0800, Arnd Bergmann wrote:
> On Friday 02 December 2011, Sumit Semwal wrote:
> > This is the first step in defining a dma buffer sharing mechanism.
> 
[...]
> 
> > +	return dmabuf;
> > +}
> > +EXPORT_SYMBOL(dma_buf_export);
> 
> I agree with Konrad, this should definitely be EXPORT_SYMBOL_GPL,
> because it's really a low-level function that I would expect
> to get used by in-kernel subsystems providing the feature to
> users and having back-end drivers, but it's not the kind of thing
> we want out-of-tree drivers to mess with.

Is this really necessary?  If this is intended to be a
lowest-common-denominator between many drivers to allow buffer sharing,
it seems like it needs to be able to be usable by all drivers.

If the interface is not accessible then I fear many drivers will be
forced to continue to roll their own buffer sharing mechanisms (which is
exactly what we're trying to avoid here, needless to say).

- Robert
