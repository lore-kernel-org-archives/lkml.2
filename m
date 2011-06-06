Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261Ab1FFNSU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 09:18:20 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47537 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756155Ab1FFNSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 09:18:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=bcQ3BRPlRx89472Gisi3ft0dwKscScGtoMsOWAcw0T9Gm/C88bAHE5+ZQg6oEEcJWO
         2sfFlFZ9HK6jE7ZP9kIMDCpB4onGR9rADUpX0bmEIDCYwttiHULOUTDFdL52EJ4ln8aX
         uyHvaSvb+haeo2Prz8St9s+jHmGgzoTKIhBoM=
Subject: Re: bridge/netfilter: regression in 2.6.39.1
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Alexander Holler <holler@ahsoftware.de>, linux-kernel@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>, netdev@vger.kernel.org
In-Reply-To: <20110606131309.GB1000@hmsreliant.think-freely.org>
References: <4DE93422.3070000@ahsoftware.de>
	 <20110606111507.GA1000@hmsreliant.think-freely.org>
	 <4DECBEA3.6070408@ahsoftware.de> <1307362358.3098.6.camel@edumazet-laptop>
	 <4DECCCC0.70905@ahsoftware.de>
	 <20110606131309.GB1000@hmsreliant.think-freely.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Jun 2011 15:18:12 +0200
Message-ID: <1307366292.3098.17.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 06 juin 2011 à 09:13 -0400, Neil Horman a écrit :

> Ok, this makes sense to me now, thanks.  The change to the dst initalization to
> mark our fake routing table as read only means we need a cow_metrics method to
> copy the metrics before we we can compete the dst_metric_set in br_change_mtu.
> Thats fine, but given that its really a fake routing table with only one dst
> entry which (I think) is only written under the rtnl lock, why not just modify
> the dst_init_metrics call so that its not marked as read-only?

It _is_ read-only, its even a "const", so if you do that you'll trap if
kernel const pages are RO

Please check commit 0972ddb237 for a proper way to deal with this.



