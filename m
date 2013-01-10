Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab3AJLOH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 06:14:07 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:50703 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753223Ab3AJLOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 06:14:05 -0500
Date: Thu, 10 Jan 2013 11:14:03 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Dave Chinner <david@fromorbit.com>, Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [v2] fadvise: perform WILLNEED readahead asynchronously
Message-ID: <20130110111403.GA730@dcvr.yhbt.net>
References: <20121225022251.GA25992@dcvr.yhbt.net>
 <50EE8B6B.1050204@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50EE8B6B.1050204@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com> wrote:
> Hello,
> 
> Il 25/12/2012 03:22, Eric Wong ha scritto:
> > Any other (Free Software) applications that might benefit from
> > lower FADV_WILLNEED latency?
> 
> Not with fadvise but with madvise. Libreoffice / Openoffice.org have
> this comment:
> 
> // On Linux, madvise(..., MADV_WILLNEED) appears to have the undesirable
> // effect of not returning until the data has actually been paged in, so
> // that its net effect would typically be to slow down the process
> // (which could start processing at the beginning of the data while the
> // OS simultaneously pages in the rest); on other platforms, it remains
> // to be evaluated whether madvise or equivalent is available and
> // actually useful:
> 
> See:
> http://cgit.freedesktop.org/libreoffice/core/tree/sal/osl/unx/file.cxx#n1213
> 
> May the same approach be extended to madvise MADV_WILLNEED?

Definitely yes, it should be easy.  This project low-priority for me at
the moment, if you or anybody else wants to take a stab at it,
please do :)
