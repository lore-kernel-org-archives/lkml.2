Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104Ab2COOHT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 10:07:19 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:52279 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab2COOHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 10:07:16 -0400
Date: Thu, 15 Mar 2012 14:07:08 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, matt.fleming@intel.com
Subject: Re: [PATCH] EFI: Only set regions uncacheable if they support it
Message-ID: <20120315140708.GA3395@srcf.ucam.org>
References: <1331819798-1955-1-git-send-email-mjg@redhat.com>
 <4F61F5E6.8060509@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F61F5E6.8060509@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 07:00:06AM -0700, H. Peter Anvin wrote:
> On 03/15/2012 06:56 AM, Matthew Garrett wrote:
> > The EFI memory region attributes field indicates whether the region can
> > be mapped with various cache attributes. Our current implementation always
> > marks regions uncacheable if they don't have the writeback support flag.
> > This causes us to mark some regions uncacheable even if they don't
> > indicate support for being uncacheable, triggering a clflush that may cause
> > an MCE. Ensure we only do this for regions which support it.
> > 
> > Signed-off-by: Matthew Garrett <mjg@redhat.com>
> 
> Could you be specific as to what you're seeing in the field?  In
> particular, what *do* these memory regions claim to support?

I have a report of a system that fails to boot with an MCE during EFI 
setup. The memory range is marked reserved and claims not to support any 
caching type, which I think probably translates as "Don't do anything to 
this region ever".

-- 
Matthew Garrett | mjg59@srcf.ucam.org
