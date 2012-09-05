Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759029Ab2IERPZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 13:15:25 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:58273 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754581Ab2IERPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 13:15:23 -0400
Message-ID: <1346865322.1906.7.camel@joe2Laptop>
Subject: Re: [PATCH 2/3] x86/mce: Pack boolean MCE flags into a structure
From: Joe Perches <joe@perches.com>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: tony.luck@intel.com, andi@firstfloor.org, bp@amd64.org,
        gong.chen@linux.intel.com, ananth@in.ibm.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        tglx@linutronix.de, gregkh@suse.de, linux-edac@vger.kernel.org
Date: Wed, 05 Sep 2012 10:15:22 -0700
In-Reply-To: <20120905102201.9423.46671.stgit@localhost.localdomain>
References: <20120905102049.9423.6413.stgit@localhost.localdomain>
	 <20120905102201.9423.46671.stgit@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-05 at 15:52 +0530, Naveen N. Rao wrote:
> Many MCE flags are boolean in nature, but are declared as integers
> currently. We can pack these into a bitfield to save some space.
[]
> diff --git a/arch/x86/kernel/cpu/mcheck/mce-internal.h b/arch/x86/kernel/cpu/mcheck/mce-internal.h
[]
> @@ -11,6 +11,15 @@ enum severity_level {
>  	MCE_PANIC_SEVERITY,
>  };
>  
> +struct mce_config {
> +	__u32	cmci_disabled		: 1,
> +		ignore_ce		: 1,
> +		dont_log_ce		: 1,
> +		__pad			: 29;

You don't need to declare __pad
Perhaps bool:1 instead.

