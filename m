Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933330Ab2KBRsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 13:48:10 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:8659 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932442Ab2KBRsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 13:48:05 -0400
Date: Fri, 2 Nov 2012 17:48:04 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Shan Wei <shanwei88@gmail.com>
cc: lindner_marek@yahoo.de, siwu@hrz.tu-chemnitz.de, ordex@autistici.org,
        b.a.t.m.a.n@lists.open-mesh.org, David Miller <davem@davemloft.net>,
        NetDev <netdev@vger.kernel.org>,
        Kernel-Maillist <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 9/9] net: batman-adv: use per_cpu_add helper
In-Reply-To: <5093EE7E.6040400@gmail.com>
Message-ID: <0000013ac23ca1c8-740e6cfa-8166-4369-80d6-88bdfa8117d6-000000@email.amazonses.com>
References: <5093EE7E.6040400@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Nov 2012, Shan Wei wrote:

> diff --git a/net/batman-adv/main.h b/net/batman-adv/main.h
> index 897ba6a..3aef5b2 100644
> --- a/net/batman-adv/main.h
> +++ b/net/batman-adv/main.h
> @@ -263,9 +263,7 @@ static inline bool batadv_has_timed_out(unsigned long timestamp,
>  static inline void batadv_add_counter(struct batadv_priv *bat_priv, size_t idx,
>  				      size_t count)
>  {
> -	int cpu = get_cpu();
> -	per_cpu_ptr(bat_priv->bat_counters, cpu)[idx] += count;
> -	put_cpu();
> +	this_cpu_add(bat_priv->bat_counters[idx], count);
>  }

Reviewed-by: Christoph Lameter <cl@linux.com>

