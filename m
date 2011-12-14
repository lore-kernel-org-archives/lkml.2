Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189Ab1LNVMf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 16:12:35 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:46622 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552Ab1LNVMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 16:12:34 -0500
Date: Wed, 14 Dec 2011 21:12:28 +0000
From: Matthew Garrett <mjg@redhat.com>
To: minyard@acm.org
Cc: openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        gcase@redhat.com
Subject: Re: [PATCH] ipmi: Increase KCS timeouts
Message-ID: <20111214211228.GA28019@srcf.ucam.org>
References: <1322680347-25743-1-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322680347-25743-1-git-send-email-mjg@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping?

On Wed, Nov 30, 2011 at 02:12:27PM -0500, Matthew Garrett wrote:
> We currently time out and retry KCS transactions after 1 second of waiting
> for IBF or OBF. This appears to be too short for some hardware. The IPMI
> spec says "All system software wait loops should include error timeouts. For
> simplicity, such timeouts are not shown explicitly in the flow diagrams. A
> five-second timeout or greater is recommended". Change the timeout to five
> seconds to satisfy the slow hardware.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> ---
>  drivers/char/ipmi/ipmi_kcs_sm.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/char/ipmi/ipmi_kcs_sm.c b/drivers/char/ipmi/ipmi_kcs_sm.c
> index cf82fed..e53fc24 100644
> --- a/drivers/char/ipmi/ipmi_kcs_sm.c
> +++ b/drivers/char/ipmi/ipmi_kcs_sm.c
> @@ -118,8 +118,8 @@ enum kcs_states {
>  #define MAX_KCS_WRITE_SIZE IPMI_MAX_MSG_LENGTH
>  
>  /* Timeouts in microseconds. */
> -#define IBF_RETRY_TIMEOUT 1000000
> -#define OBF_RETRY_TIMEOUT 1000000
> +#define IBF_RETRY_TIMEOUT 5000000
> +#define OBF_RETRY_TIMEOUT 5000000
>  #define MAX_ERROR_RETRIES 10
>  #define ERROR0_OBF_WAIT_JIFFIES (2*HZ)
>  
> -- 
> 1.7.7.1
> 
> 
-- 
Matthew Garrett | mjg59@srcf.ucam.org
