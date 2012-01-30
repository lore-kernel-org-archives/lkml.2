Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014Ab2A3XJh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 18:09:37 -0500
Received: from mail.solarflare.com ([216.237.3.220]:62996 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752443Ab2A3XJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 18:09:36 -0500
Message-ID: <1327964972.2595.31.camel@bwh-desktop>
Subject: Re: [PATCH 01/16] eicon: fix -Warray-bounds warning
From: Ben Hutchings <bhutchings@solarflare.com>
To: Danny Kukawka <danny.kukawka@bisect.de>
CC: Armin Schindler <mac@melware.de>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, Karsten Keil <isdn@linux-pingi.de>
Date: Mon, 30 Jan 2012 23:09:32 +0000
In-Reply-To: <1327960820-11867-2-git-send-email-danny.kukawka@bisect.de>
References: <1327960820-11867-1-git-send-email-danny.kukawka@bisect.de>
	 <1327960820-11867-2-git-send-email-danny.kukawka@bisect.de>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-6.800.1017-18676.004
X-TM-AS-Result: No--17.309800-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-30 at 23:00 +0100, Danny Kukawka wrote:
> Fix for a -Warray-bounds warning. mixer_notify_update() tries to
> write to ((CAPI_MSG *) msg)->info.facility_req.structs[3] while
> structs is defined as byte structs[1], define structs[1] as
> structs[4].

I suspect that all the 'byte structs[1];' fields defined in that header
are actually variable-length arrays.  In that case, there may be no
reasonable bound you can specify.

Ben.

> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
> ---
>  drivers/isdn/hardware/eicon/capi20.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/isdn/hardware/eicon/capi20.h b/drivers/isdn/hardware/eicon/capi20.h
> index 7ebcccd..f9170ad 100644
> --- a/drivers/isdn/hardware/eicon/capi20.h
> +++ b/drivers/isdn/hardware/eicon/capi20.h
> @@ -226,7 +226,7 @@ typedef struct {
>          /* FACILITY-REQUEST */
>  typedef struct {
>    word Selector;
> -  byte structs[1];      /* Facility parameters */
> +  byte structs[4];      /* Facility parameters */
>  } _FAC_REQP;
>          /* FACILITY-CONFIRM STRUCT FOR SUPPLEMENT. SERVICES */
>  typedef struct {

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

