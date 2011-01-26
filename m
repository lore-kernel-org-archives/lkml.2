Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab1AZP74 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 10:59:56 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40077 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab1AZP7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 10:59:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=G2RXW1KvktxOXOlxjZ94JDQl9MNKXvvxPlaV92xxXHBAKVyX1824/3Hns8i34Ypa1g
         FgyQC6chWqXewO3GPUxkwvSHkVpPlIdKkogW5d+/ghni3mokagPlb+t2TXMu9/zjB+wa
         2npnbvZWVWC1S3jR7JNOMeT3lQ5Ve2TlT8m2I=
Subject: Re: sys_epoll_wait high CPU load in 2.6.37
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Simon Kirby <sim@hostway.ca>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shawn Bohrer <shawn.bohrer@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1101260747320.1889@localhost6.localdomain6>
References: <20110126000932.GA23089@hostway.ca>
	 <1296026298.2633.19.camel@edumazet-laptop>
	 <1296040578.2899.59.camel@edumazet-laptop>
	 <alpine.DEB.2.00.1101260714280.1889@localhost6.localdomain6>
	 <1296056600.2899.66.camel@edumazet-laptop>
	 <alpine.DEB.2.00.1101260747320.1889@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Jan 2011 16:59:50 +0100
Message-ID: <1296057590.2899.73.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 26 janvier 2011 à 07:52 -0800, Davide Libenzi a écrit :

> For "above", I meant the current epoll expire time calculation, which was 
> described above in the message ;)

Well, problem was not an overflow, but doing a loop 2.000.000 times ;)

> The hint for a timespec_add_ms() was because we must be doing something 
> similar in poll, don't we (/me got no code in front ATM)?

Apparently its done differently in poll(), using
poll_select_set_timeout() helper.


Give me some minutes I'll try to cook an alternate patch


