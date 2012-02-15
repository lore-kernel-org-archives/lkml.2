Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab2BOTKG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 14:10:06 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:38776 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650Ab2BOTKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 14:10:03 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 15 Feb 2012 20:09:19 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Chris Boot <bootc@bootc.net>
Cc: linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, agrover@redhat.com, clemens@ladisch.de,
        nab@linux-iscsi.org
Subject: Re: [PATCH v2 01/11] firewire: Add function to get speed from
 opaque struct fw_request
Message-ID: <20120215200919.10d9e2eb@stein>
In-Reply-To: <1329317248-94128-2-git-send-email-bootc@bootc.net>
References: <1328989452-20921-1-git-send-email-bootc@bootc.net>
	<1329317248-94128-1-git-send-email-bootc@bootc.net>
	<1329317248-94128-2-git-send-email-bootc@bootc.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 15 Chris Boot wrote:
> --- a/drivers/firewire/core-transaction.c
> +++ b/drivers/firewire/core-transaction.c
> @@ -820,6 +820,22 @@ void fw_send_response(struct fw_card *card,
>  }
>  EXPORT_SYMBOL(fw_send_response);
>  
> +/**
> + * fw_get_request_speed() - Discover bus speed used for this request
> + * @request:	The struct fw_request from which to obtain the speed.
> + *
> + * In certain circumstances it's important to be able to obtain the speed at
> + * which a request was made to an address handler, for example when
> + * implementing an SBP-2 or SBP-3 target. This function inspects the response
> + * object to obtain the speed, which is copied from the request packet in
> + * allocate_request().
> + */
> +int fw_get_request_speed(struct fw_request *request)
> +{
> +	return request->response.speed;
> +}
> +EXPORT_SYMBOL(fw_get_request_speed);

Uh oh, what have I done by asking for a comment? :-)

Can you tell what's wrong with this API documentation?
-- 
Stefan Richter
-=====-===-- --=- -====
http://arcgraph.de/sr/
