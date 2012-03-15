Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030446Ab2COOyO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 10:54:14 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:43951 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964859Ab2COOyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 10:54:08 -0400
Date: Thu, 15 Mar 2012 14:54:03 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, matt.fleming@intel.com
Subject: Re: [PATCH] EFI: Only set regions uncacheable if they support it
Message-ID: <20120315145403.GA5321@srcf.ucam.org>
References: <1331819798-1955-1-git-send-email-mjg@redhat.com>
 <4F61F5E6.8060509@zytor.com>
 <20120315140708.GA3395@srcf.ucam.org>
 <4F61FA14.6020203@zytor.com>
 <20120315142445.GA4357@srcf.ucam.org>
 <4F61FC8E.8070109@zytor.com>
 <20120315143308.GA4382@srcf.ucam.org>
 <4F61FE7E.9060600@zytor.com>
 <20120315144236.GB4650@srcf.ucam.org>
 <4F62011D.4000708@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F62011D.4000708@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 07:47:57AM -0700, H. Peter Anvin wrote:

> WTF?!  That should be UC at all times... it isn't even WC-capable.
> Furthermore, we may need this region (assuming there is actually a video
> card there.)

I don't think we'll ever use this region on UEFI. What I have from Intel 
is:

"It looks like this is happening when the kernel iterates over the 
various regions in the EFI memory map. It hits a region starting at 
0xA0000 and attempts to do a CLFLUSH instruction on that address. This 
is explicitly forbidden by the SAD in (codename), thus the Machine 
Check."

> What do the fixed MTRRs look like?

Unsure. I'll try to find out.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
