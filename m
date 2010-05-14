Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab0ENOSr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 10:18:47 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53414 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277Ab0ENOSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 10:18:45 -0400
From: Sebastien Jan <s-jan@ti.com>
Organization: Texas Instruments
To: Carlos Chinea <carlos.chinea@nokia.com>
Subject: Re: [RFC PATCHv2 1/7] HSI: Introducing HSI framework
Date: Fri, 14 May 2010 16:22:12 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-20-generic; KDE/4.3.2; i686; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
References: <1273245517-30712-1-git-send-email-carlos.chinea@nokia.com> <1273245517-30712-2-git-send-email-carlos.chinea@nokia.com>
In-Reply-To: <1273245517-30712-2-git-send-email-carlos.chinea@nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005141622.12281.s-jan@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Carlos,

After review, I do not have many comments on the interface, as we already 
aligned on most of it.

Please see my comments inlined below.

On Friday 07 May 2010 17:18:31 Carlos Chinea wrote:
[strip]
> diff --git a/include/linux/hsi/hsi.h b/include/linux/hsi/hsi.h
[strip]
> +/**
> + * hsi_start_tx - Signal the port that the client wants to start a TX
> + * @cl: Pointer to the HSI client
> + *
> + * Return -errno on failure, 0 on success
> + */
> +static inline int hsi_start_tx(struct hsi_client *cl)
> +{
> +       if (!hsi_port_claimed(cl))
> +               return -EACCES;
> +       return hsi_get_port(cl)->start_tx(cl);
> +}
> +
> +/**
> + * hsi_stop_tx - Signal the port that the client no longer wants to
>  transmit + * @cl: Pointer to the HSI client
> + *
> + * Return -errno on failure, 0 on success
> + */
> +static inline int hsi_stop_tx(struct hsi_client *cl)
> +{
> +       if (!hsi_port_claimed(cl))
> +               return -EACCES;
> +       return hsi_get_port(cl)->stop_tx(cl);
> +}

As I can see, these two I/F functions are the way an HSI protocol layer can 
play with Tx_wake lines if it has to, right? 
I suppose it allows more flexibility with regards to 3/4 wires HSI flavors 
management and avoids additional callbacks to Tx_wake related events?

