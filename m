Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272Ab2FNQ47 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 12:56:59 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:24702 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932205Ab2FNQ45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 12:56:57 -0400
Date: Thu, 14 Jun 2012 12:49:26 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86/xen: avoid updating TLS descriptors if they haven't
 changed
Message-ID: <20120614164926.GC333@phenom.dumpdata.com>
References: <1339088494-23528-1-git-send-email-david.vrabel@citrix.com>
 <4FD9FAA3.6090303@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FD9FAA3.6090303@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 03:52:19PM +0100, David Vrabel wrote:
> On 07/06/12 18:01, David Vrabel wrote:
> > From: David Vrabel <david.vrabel@citrix.com>
> > 
> > When switching tasks in a Xen PV guest, avoid updating the TLS
> > descriptors if they haven't changed.  This improves the speed of
> > context switches by almost 10% as much of the time the descriptors are
> > the same or only one is different.
> > 
> > The descriptors written into the GDT by Xen are modified from the
> > values passed in the update_descriptor hypercall so we keep shadow
> > copies of the three TLS descriptors to compare against.
> > 
> > lmbench3 test     Before  After  Improvement
> > --------------------------------------------
> > lat_ctx -s 32 24   7.19    6.52  9%
> > lat_pipe          12.56   11.66  7%
> > 
> > Signed-off-by: David Vrabel <david.vrabel@citrix.com>
> > ---
> > I note that the comment in asm/desc_defs.h says the 'a' and 'b' fields
> > in desc_struct as deprecated but there seems to be no suitable
> > alternatives.
> 
> ping?  Any opinion on this patch from the x86 side?  If it's okay can we
> get an ack so Konrad can take the patch via his tree.

It breaks my all my bootup tests - so NACK until at least that is fixed.
I think I sent you the whole serial log - is there something else that would help
narrow it down?
