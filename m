Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030732Ab2B2KMF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 05:12:05 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:38119 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965547Ab2B2KMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 05:12:03 -0500
Date: Wed, 29 Feb 2012 11:11:46 +0100
From: Borislav Petkov <bp@amd64.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 2/3] x86, RAS: Add a decoded msg buffer
Message-ID: <20120229101146.GB21224@aftab>
References: <1330445487-15020-1-git-send-email-bp@amd64.org>
 <1330445487-15020-3-git-send-email-bp@amd64.org>
 <3908561D78D1C84285E8C5FCA982C28F03FD68@ORSMSX104.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F03FD68@ORSMSX104.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 10:43:52PM +0000, Luck, Tony wrote:
> +	if (left <= 50) {
> +		/* enlarge arbitrarily by 50 chars */
> +		err_str_sz += 50;
> +		left += 50;
> +
> +		err_str = krealloc(err_str, err_str_sz, GFP_KERNEL);
> +		if (!err_str) {
> +			pr_err("Error enlarging decode buffer.\n");
> +			return;
> +		}
> +	}
> 
> This looks worrying to me.  Some bad stuff has happened, we are perhaps
> in machine check context, and you want to start allocating memory!

Yes, absolutely. See my other mail to Seto-san.

> Is there some upper bound for how long this string can get? Why not
> just allocate a generous amount at boot time?

Yep, this sounds like the easiest thing to do, let me play with MCE
injection a bit.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
