Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab1DUDkT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 23:40:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53038 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700Ab1DUDkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 23:40:17 -0400
Date: Wed, 20 Apr 2011 23:40:16 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: jaxboe@fusionio.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad@kernel.org
Subject: Re: [PATCH] xen block backend driver.
Message-ID: <20110421034016.GB11501@infradead.org>
References: <1303333543-5915-1-git-send-email-konrad.wilk@oracle.com>
 <1303333543-5915-2-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303333543-5915-2-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +#define WRITE_BARRIER	(REQ_WRITE | REQ_FLUSH | REQ_FUA)

Any in case you want to keep usingthis POS out of tree you really need
to fix this.  REQ_FLUSH | REQ_FUA is not equivalent to the old barrier
semantics that the Xen disk protocol exported to the guest.  You need
to drain the whole queue of outstanding I/Os as some old guest (at least
those using reiserfs, e.g. old SLES) rely on it.

