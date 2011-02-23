Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174Ab1BWJ3w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 04:29:52 -0500
Received: from cernmx30.cern.ch ([137.138.144.177]:11899 "EHLO
	CERNMX30.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932142Ab1BWJ3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 04:29:51 -0500
X-Greylist: delayed 324 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Feb 2011 04:29:51 EST
Date: Wed, 23 Feb 2011 10:24:24 +0100
From: Manohar Vanga <manohar.vanga@cern.ch>
To: <martyn.welch@ge.com>
CC: <cota@braap.org>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] Staging: vme: fix potential infinite loop
Message-ID: <20110223092424.GA5195@athena>
References: <1298403376-28352-1-git-send-email-manohar.vanga@cern.ch>
 <1298403376-28352-3-git-send-email-manohar.vanga@cern.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1298403376-28352-3-git-send-email-manohar.vanga@cern.ch>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Originating-IP: [128.141.230.45]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 08:36:16PM +0100, Manohar Vanga wrote:
> Fix a bug in vme_register_bridge that resulted in an infinite loop if
> device_register failed.
> 
> Signed-off-by: Manohar Vanga <manohar.vanga@cern.ch>
> ---
>  drivers/staging/vme/vme.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/vme/vme.c b/drivers/staging/vme/vme.c
> index 88bf455..7eb4568 100644
> --- a/drivers/staging/vme/vme.c
> +++ b/drivers/staging/vme/vme.c
> @@ -1364,9 +1364,14 @@ int vme_register_bridge(struct vme_bridge *bridge)
>  	return retval;
>  
>  err_reg:
> +	/*
> +	 * Ignore the failed driver and unregister the rest
> +	 */
> +	i--

Ugh. Missing semicolon here. I'll resend the corrected patch.

Thanks,
Manohar Vanga
