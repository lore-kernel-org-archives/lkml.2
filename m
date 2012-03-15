Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761156Ab2COOdP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 10:33:15 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:45191 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760869Ab2COOdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 10:33:10 -0400
Date: Thu, 15 Mar 2012 14:33:08 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, matt.fleming@intel.com
Subject: Re: [PATCH] EFI: Only set regions uncacheable if they support it
Message-ID: <20120315143308.GA4382@srcf.ucam.org>
References: <1331819798-1955-1-git-send-email-mjg@redhat.com>
 <4F61F5E6.8060509@zytor.com>
 <20120315140708.GA3395@srcf.ucam.org>
 <4F61FA14.6020203@zytor.com>
 <20120315142445.GA4357@srcf.ucam.org>
 <4F61FC8E.8070109@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F61FC8E.8070109@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 07:28:30AM -0700, H. Peter Anvin wrote:
> On 03/15/2012 07:24 AM, Matthew Garrett wrote:
> > On Thu, Mar 15, 2012 at 07:17:56AM -0700, H. Peter Anvin wrote:
> >> In other words, "don't map me"... not something we really support at the
> >> moment, but perhaps we should; at least until we find systems in the
> >> field that break with that constraint :(
> > 
> > Mapping should be harmless as long as we then don't touch it? I can't 
> > think of any circumstances where we would.
> > 
> 
> If we map it WB software can do speculative loads from that region which
> would bring it into the cache.  If we map it UC we might have to CLFLUSH...

We've already mapped it at this point - we then go back and flag it UC 
if it's not writeback. The latter seems to be causing problems, I'm not 
sure we've seen any indication that the former is. And these regions are 
marked as runtime accessible, so per spec they do need to be mapped into 
address space...

-- 
Matthew Garrett | mjg59@srcf.ucam.org
