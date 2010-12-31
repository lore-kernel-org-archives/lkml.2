Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab0LaKPJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 05:15:09 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56924 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab0LaKPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 05:15:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=co/PZZmZBZb3EhIf4Kh0ioBfcbo62FcrZvgNU9junJDbNcu1xhYluyIAvlf/rq/dsW
         u3ahS0IIZX/JdRLiMjgd9y82jbYveFF3w3sAbnb/JPzhMm/O314ahOo+SuoGm4gza5WK
         RS21yf5mnIhQD2qTyuaWD3At0amoqYm2GvxXA=
Subject: Re: [PATCH] UDPCP Communication Protocol
From: Eric Dumazet <eric.dumazet@gmail.com>
To: stefani@seibold.net
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        davem@davemloft.net, netdev@vger.kernel.org
In-Reply-To: <1293787785-3834-1-git-send-email-stefani@seibold.net>
References: <1293787785-3834-1-git-send-email-stefani@seibold.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 31 Dec 2010 11:15:01 +0100
Message-ID: <1293790501.2973.33.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 31 décembre 2010 à 10:29 +0100, stefani@seibold.net a
écrit :
> +				spin_lock_irqsave(&spinlock, flags);
> +				udpcp_stat.txMsgs++;
> +				spin_unlock_irqrestore(&spinlock, flags);

This is really ugly for different reasons :

1) Naming a lock, even static "spinlock" is ugly.
2) Using a lock for stats is not necessary, and
   disabling hard irqs is not necessary either (spinlock_bh() would be
more than enough)
  
   At a very minimum, you should use atomic_t so that no lock is needed

3) Network stack widely use MIB per_cpu counters.
 As you use UDP, you could take a look at UDP_INC_STATS_BH()/
UDP_INC_STATS_USER() implementation for an example.



