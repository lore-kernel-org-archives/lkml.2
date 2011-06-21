Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475Ab1FUNXL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 09:23:11 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:39066 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937Ab1FUNXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 09:23:08 -0400
Date: Tue, 21 Jun 2011 14:22:56 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, Tony Luck <tony.luck@intel.com>,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 4/4] ACPI, APEI, Add APEI _OSC support
Message-ID: <20110621132256.GB4902@srcf.ucam.org>
References: <1308640587-24502-1-git-send-email-ying.huang@intel.com>
 <1308640587-24502-5-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308640587-24502-5-git-send-email-ying.huang@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 03:16:27PM +0800, Huang Ying wrote:

> +	rc = apei_osc_setup();
> +	if (rc)
> +		pr_info(GHES_PFX "Evaluate APEI _OSC failed!\n");

Hm. This is maybe a little strong. It'd be valid for a machine to return 
an error here but still have the GHES functionality enabled via the 
generic call, but this message would still show up and potentially 
confuse the user. Can we keep a flag to check whether the generic method 
gave us control, and only give the error if both fail to enable it?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
