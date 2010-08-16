Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab0HPMVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 08:21:37 -0400
Received: from edu-smtp-01.edutel.nl ([88.159.1.175]:33198 "EHLO
	edu-smtp-01.edutel.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab0HPMVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 08:21:36 -0400
Message-ID: <4C692D4D.1030401@neli.hopto.org>
Date: Mon, 16 Aug 2010 14:21:33 +0200
From: Micha Nelissen <micha@neli.hopto.org>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Alexandre Bounine <alexandre.bounine@idt.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 5/9] RapidIO: Add default handler for error_stopped state
References: <1281712686-31308-1-git-send-email-alexandre.bounine@idt.com> <1281712686-31308-6-git-send-email-alexandre.bounine@idt.com>
In-Reply-To: <1281712686-31308-6-git-send-email-alexandre.bounine@idt.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexandre Bounine wrote:
> +
> +	if (err_status & RIO_PORT_N_ERR_STS_PW_OUT_ES) {
> +		pr_debug("RIO_EM: servicing Output Error-Stopped state\n");
> +		/*
> +		 * Send a Link-Request/Input-Status control symbol
> +		 */
> +
> +		/* Read from link maintenance response register
> +		 * to clear valid bit */
> +		rio_mport_read_config_32(mport, destid, hopcount,
> +			rdev->phys_efptr + RIO_PORT_N_MNT_RSP_CSR(pnum),
> +			&regval);
> +		udelay(50);

Perhaps this whole part of operating the MNT_RSP registers (sending 
link-request symbol is the only useful action IIRC?) can be put in a 
separate function for readability.

Micha
