Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab1DVJJo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 05:09:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33585 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897Ab1DVJJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 05:09:42 -0400
Date: Fri, 22 Apr 2011 05:09:04 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Daniel Stodden <daniel.stodden@citrix.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad@kernel.org" <konrad@kernel.org>
Subject: Re: [Xen-devel] Re: [PATCH] xen block backend driver.
Message-ID: <20110422090904.GA29246@infradead.org>
References: <1303333543-5915-1-git-send-email-konrad.wilk@oracle.com>
 <1303333543-5915-2-git-send-email-konrad.wilk@oracle.com>
 <20110421034016.GB11501@infradead.org>
 <1303412592.9571.126.camel@agari.van.xensource.com>
 <20110421190606.GA10793@infradead.org>
 <1303413277.9571.133.camel@agari.van.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303413277.9571.133.camel@agari.van.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 12:14:37PM -0700, Daniel Stodden wrote:
> > There is a huge userbase of guests out there that does rely on it.
> 
> Which ones? Old blkfront would have make a difference back then when
> barriers used to be an option, but it never actually declared it, right?

Pre-Linux 2.6.37 guests using reiserfs actually relied on the queue
flushing.  This includes a lot of SLES installation which are still
in common use.  There's only two options to make sure they work:

 (1) keep the original barrier semantics and flush the queue
 (2) do not advertize "barrier" support at all, and make sure to submit
   every I/O we get with the FUA bit.

In practice (2) is going to be faster for most real-life workloads.  So
maybe you should just drop the old "barrier" support and just send
requests with the FUA bit set for now, until you have proper flush
and fua support in the protocol.

> Weeeeeelll, I certainly hope it can deal with backends which never got
> to see those headers. :o)

They probably try to handle it, no idea how correct the handling is
in the end.

