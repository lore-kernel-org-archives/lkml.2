Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758592Ab2BNARz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 19:17:55 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:40200 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815Ab2BNARw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 19:17:52 -0500
Date: Tue, 14 Feb 2012 00:17:44 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Len Brown <lenb@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 4/5] ACPI: Do cpufreq clamping for throttling per
 package v2
Message-ID: <20120214001744.GA11137@srcf.ucam.org>
References: <1328545032-21373-1-git-send-email-andi@firstfloor.org>
 <1328545032-21373-5-git-send-email-andi@firstfloor.org>
 <20120206163106.GB32061@srcf.ucam.org>
 <4F399D19.9090904@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F399D19.9090904@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 06:30:33PM -0500, Len Brown wrote:
> On 02/06/2012 11:31 AM, Matthew Garrett wrote:
> 
> > On Mon, Feb 06, 2012 at 08:17:11AM -0800, Andi Kleen wrote:
> >> +#define reduction_pctg(cpu) \
> >> +	per_cpu(cpufreq_thermal_reduction_pctg, phys_package_first_cpu(cpu))
> > 
> > I don't like using percentages here - we end up with the potential for 
> > several percentages to end up mapping to the same P state.
> 
> 
> Does it matter?

If you step through multiple percentages that map to the same P state, 
yes. On the other hand, re-reading the specification, it seems that this 
is the behaviour envisaged in the polling equation. I guess we'll stick 
with that.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
