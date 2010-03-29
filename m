Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab0C2P4o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 11:56:44 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:55893 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab0C2P4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 11:56:39 -0400
Date: Mon, 29 Mar 2010 17:57:00 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Julia Lawall <julia@diku.dk>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux390@de.ibm.com,
       linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/12] arch/s390/kernel: Add missing unlock
Message-ID: <20100329155700.GA3066@osiris.boeblingen.de.ibm.com>
References: <Pine.LNX.4.64.1003291733350.21896@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1003291733350.21896@ask.diku.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 05:33:52PM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> In the default case the lock is not unlocked.  The return is
> converted to a goto, to share the unlock at the end of the function.
> 
> diff --git a/arch/s390/kernel/topology.c b/arch/s390/kernel/topology.c
> index 14ef6f0..247b4c2 100644
> --- a/arch/s390/kernel/topology.c
> +++ b/arch/s390/kernel/topology.c
> @@ -165,10 +165,11 @@ static void tl_to_cores(struct tl_info *info)
>  		default:
>  			clear_cores();
>  			machine_has_topology = 0;
> -			return;
> +			goto out;
>  		}
>  		tle = next_tle(tle);
>  	}
> +out:
>  	spin_unlock_irq(&topology_lock);

Applied. Thank you!
