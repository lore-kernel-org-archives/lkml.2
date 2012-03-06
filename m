Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030483Ab2CFMN6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 07:13:58 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:42895 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759177Ab2CFMN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 07:13:56 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of eric.dumazet@gmail.com designates 10.60.3.34 as permitted sender) smtp.mail=eric.dumazet@gmail.com; dkim=pass header.i=eric.dumazet@gmail.com
Message-ID: <1331036030.2474.40.camel@edumazet-laptop>
Subject: Re: [PATCH v4] lpc32xx: Added ethernet driver
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Roland Stigge <stigge@antcom.de>
Cc: Ben Hutchings <bhutchings@solarflare.com>, davem@davemloft.net,
        jeffrey.t.kirsher@intel.com, alexander.h.duyck@intel.com,
        eilong@broadcom.com, ian.campbell@citrix.com, netdev@vger.kernel.org,
        w.sang@pengutronix.de, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, linux-arm-kernel@lists.infradead.org,
        arnd@arndb.de, baruch@tkos.co.il, joe@perches.com
Date: Tue, 06 Mar 2012 04:13:50 -0800
In-Reply-To: <4F55D099.5070006@antcom.de>
References: <1330983641-32622-1-git-send-email-stigge@antcom.de>
	 <1330987524.2538.61.camel@bwh-desktop> <4F55D099.5070006@antcom.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 06 mars 2012 à 09:53 +0100, Roland Stigge a écrit :

> Sounds reasonable, and will do it.
> 
> However, I implemented it from the example of
> drivers/net/ethernet/via/via-velocity.c:velocity_poll() - is there a
> good reason for doing it that way in the velocity driver or is it done
> incorrectly there, also?
> 

Its done in a non efficient way.

It works as is, but its not the right thing to do.
The NAPI port was very minimal on via-velocity it seems.

A better way is to hold no locks in the RX handler, allowing calls to
netif_receive_skb() [ and potential calls to xmit while handling this
incoming skbs ]

Problem of saying "we dont expect to be SMP anyway", is that this let
reference material for future drivers that will copy/paste the code,
then experience performance problems.



