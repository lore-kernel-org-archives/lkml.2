Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758337Ab1EBTRF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 15:17:05 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:53474 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624Ab1EBTQu (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 2 May 2011 15:16:50 -0400
Date: Mon, 2 May 2011 15:08:43 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Daniel Stodden <daniel.stodden@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad@kernel.org" <konrad@kernel.org>
Subject: Re: [Xen-devel] Re: [PATCH] xen block backend driver. - proper
 flush/barrier/fua support missing.
Message-ID: <20110502190843.GA29913@dumpdata.com>
References: <1303333543-5915-1-git-send-email-konrad.wilk@oracle.com>
 <1303333543-5915-2-git-send-email-konrad.wilk@oracle.com>
 <20110421034016.GB11501@infradead.org>
 <1303412592.9571.126.camel@agari.van.xensource.com>
 <20110421190606.GA10793@infradead.org>
 <1303413277.9571.133.camel@agari.van.xensource.com>
 <20110422090904.GA29246@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110422090904.GA29246@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4DBF02FD.01B4:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 22, 2011 at 05:09:04AM -0400, Christoph Hellwig wrote:
> On Thu, Apr 21, 2011 at 12:14:37PM -0700, Daniel Stodden wrote:
> > > There is a huge userbase of guests out there that does rely on it.
> > 
> > Which ones? Old blkfront would have make a difference back then when
> > barriers used to be an option, but it never actually declared it, right?
> 
> Pre-Linux 2.6.37 guests using reiserfs actually relied on the queue
> flushing.  This includes a lot of SLES installation which are still
> in common use.  There's only two options to make sure they work:
> 
>  (1) keep the original barrier semantics and flush the queue
>  (2) do not advertize "barrier" support at all, and make sure to submit
>    every I/O we get with the FUA bit.
> 
> In practice (2) is going to be faster for most real-life workloads.  So
> maybe you should just drop the old "barrier" support and just send
> requests with the FUA bit set for now, until you have proper flush
> and fua support in the protocol.

Let me play with both options and see how they pan out.

Christoph,

Is there a good tool to unmask barrier bugs? I found this one:
http://lwn.net/Articles/283169/

but not sure if that still applies to this case? Or does
running bonnie++ expose the potential issues?
