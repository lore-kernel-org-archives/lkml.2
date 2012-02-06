Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab2BFQbK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 11:31:10 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:47147 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700Ab2BFQbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 11:31:08 -0500
Date: Mon, 6 Feb 2012 16:31:06 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 4/5] ACPI: Do cpufreq clamping for throttling per
 package v2
Message-ID: <20120206163106.GB32061@srcf.ucam.org>
References: <1328545032-21373-1-git-send-email-andi@firstfloor.org>
 <1328545032-21373-5-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328545032-21373-5-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 06, 2012 at 08:17:11AM -0800, Andi Kleen wrote:
> +#define reduction_pctg(cpu) \
> +	per_cpu(cpufreq_thermal_reduction_pctg, phys_package_first_cpu(cpu))

I don't like using percentages here - we end up with the potential for 
several percentages to end up mapping to the same P state. I've sent a 
patch that replaces the percentage code with just stepping through P 
states instead. But otherwise, yes, this seems sensible. An open 
question is whether we should be doing the same on _PPC notifications. 
There's some vague evidence that Windows does.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
