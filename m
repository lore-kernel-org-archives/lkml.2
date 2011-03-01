Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525Ab1CAO54 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 09:57:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40361 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754630Ab1CAO5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 09:57:55 -0500
Date: Tue, 1 Mar 2011 15:57:46 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: stuart h <stuart_hayes@yahoo.com>
Cc: linux-kernel@vger.kernel.org, douglas_warzecha@dell.com,
        shyam_iyer@dell.com
Subject: Re: [PATCH v2] dcdbas: force SMI to happen when expected
In-Reply-To: <518456.82543.qm@web38004.mail.mud.yahoo.com>
Message-ID: <alpine.LRH.2.00.1103011557130.25727@twin.jikos.cz>
References: <518456.82543.qm@web38004.mail.mud.yahoo.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Feb 2011, stuart h wrote:

> This is a reworked version of a very similar patch I sent about three 
> weeks ago... a flaw was pointed out with the original.  That patch 
> didn't make it into the kernel, though, so I'm just sending this one as 
> a new patch.
> 
> The dcdbas driver can do an I/O write to cause a SMI to occur.  The SMI 
> handler looks at certain registers and memory locations, so the SMI 
> needs to happen immediately.  On some systems I/O writes are posted, 
> though, causing the SMI to happen well after the "outb" occurred, which 
> causes random failures.  Following the "outb" with an "inb" forces the 
> write to go through even if it is posted.
> 
> This patch is against the 2.6.37.1 kernel.
> 
> Signed-off-by: Stuart Hayes <stuart_hayes@yahoo.com>

As this doesn't seem to be picked up ... Douglas, can I have your 
Acked-by: please, so that I could merge it (as Acked by maintainer?).

Thanks.

> --- linux-2.6.37/drivers/firmware/dcdbas.c	2011-01-18 10:44:44.869882461 -0500
> +++ linux-2.6.37_test/drivers/firmware/dcdbas.c	2011-02-24 13:23:58.663771596 -0500
> @@ -268,8 +268,10 @@ int dcdbas_smi_request(struct smi_cmd *s
>  	}
>  
>  	/* generate SMI */
> +	/* inb to force posted write through and make SMI happen now */
>  	asm volatile (
> -		"outb %b0,%w1"
> +		"outb %b0,%w1\n"
> +		"inb %w1"
>  		: /* no output args */
>  		: "a" (smi_cmd->command_code),
>  		  "d" (smi_cmd->command_address),
> 
> 
> 

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

