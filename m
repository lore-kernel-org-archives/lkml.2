Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842Ab1EBSIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 14:08:16 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:29173 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344Ab1EBSIP (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 2 May 2011 14:08:15 -0400
Date: Mon, 2 May 2011 14:08:02 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: xen-devel@lists.xensource.com, yinghai@kernel.org,
        linux-kernel@vger.kernel.org, stefano.stabellini@eu.citrix.com
Subject: Re: [Xen-devel] Re: [PATCH] Two patches fixing regression
 introduced by 'x86-64, mm: Put early page table high'
Message-ID: <20110502180802.GA7498@dumpdata.com>
References: <1304356942-17656-1-git-send-email-konrad.wilk@oracle.com>
 <4DBEEA69.7010000@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DBEEA69.7010000@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4DBEF309.0089:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 10:31:21AM -0700, H. Peter Anvin wrote:
> On 05/02/2011 10:22 AM, Konrad Rzeszutek Wilk wrote:
> > 
> > But we haven't come up with an acceptable general solution yet, so this
> > patchset provides a workaround for the problem. Peter, Yinghai - what would be
> > the best forum/email/conference to hammer out a general solution for this?
> > 
> > Currently, there are couple of ways of fixing this:
> >  - use pvops hooks: http://marc.info/?i=1302607192-21355-2-git-send-email-stefano.stabellini@eu.citrix.com
> >  - have a workaround in Xen MMU's early bootup code (which is what these
> >    two patches to this email have).
> >  - or remove the patch introducing the regression altogether.
> > 
> > Foremost important is to fix the regression, and attached patches 
> > achieve that. I want to remove this workaround patch when we
> > hammer out more appropriate semantics for the page table creation - but
> > that will take some time and the runway to do that in 2.6.39 is gone.
> > 
> 
> My inclination would be to apply your workaround -- are there any
> adverse effects to doing that?

There is a bootup slowdown (not noticeable). That is because we call the
'memblock_find_range' function on every PTE table creation (only during
bootup of course). 

Testing wise, on the machines on which the regression occurred, with these two
patches the regression disappears - so that is a good sign. I am testing
it on some more today to assure myself I am not missing anything.

> 
> 	-hpa
> 
> [Sorry if I have missed any emails recently... apparently my email was
> significantly on the fritz over the last few days.]

Yikes - I hate when that happens. I was wondering why you went so silent
on some of the emails.
