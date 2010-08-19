Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427Ab0HSPsx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 11:48:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61140 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab0HSPsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 11:48:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
Subject: Re: [PATCH 1/5] ptp: Added a brand new class driver for ptp clocks.
Date: Thu, 19 Aug 2010 17:48:51 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-8-generic; KDE/4.3.2; x86_64; ; )
Cc: Richard Cochran <richardcochran@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>,
        john stultz <johnstul@us.ibm.com>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        Krzysztof Halasa <khc@pm.waw.pl>
References: <cover.1281956490.git.richard.cochran@omicron.at> <201008191429.50008.arnd@arndb.de> <20100819152301.GB25193@ovro.caltech.edu>
In-Reply-To: <20100819152301.GB25193@ovro.caltech.edu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008191748.51819.arnd@arndb.de>
X-Provags-ID: V02:K0:Kv+9S71V51OLauV2FvmLrd75Lp8qPym24BPqGjX4qql
 /9GIGKAehgBUD0IH5HrABBWSfblpJigRQZ5Q5r1kCOg2gaKBh0
 jnCcw3qnYjsrnvE8M2xrz2bEufAEeIqAJfP99Qqc7hsZ7zLn7g
 /ti8gIj1DISzSmwAFKBPp3DA4i3luKfF4pEUP3ZWEuEw92UmEP
 tAALl3lcVrggGqDzlvieA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 August 2010, Ira W. Snyder wrote:
> Perhaps you were thinking of the vhost example (taken from
> drivers/vhost/Kconfig):
> 
> config VHOST_NET
>         tristate "Host kernel accelerator for virtio net (EXPERIMENTAL)"
>         depends on NET && EVENTFD && (TUN || !TUN) && (MACVTAP || !MACVTAP) && EXPERIMENTAL
> 
> They have a similar construct with both TUN and MACVTAP there. Perhaps
> the parens are a necessary part of the "X || !X" syntax? Just a random
> guess.

Yes, that's the one I was thinking of.

My mistake was that the effect is slightly different here. VHOST and TUN are
both tristate. What we guarantee here is that if TUN is "m", VHOST cannot be "y",
because its dependency cannot be fulfilled for y.

	Arnd
