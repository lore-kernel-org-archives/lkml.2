Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab2CSEgv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 00:36:51 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:48440 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945Ab2CSEgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 00:36:49 -0400
MIME-Version: 1.0
In-Reply-To: <b157e2d1a746733d1814b9726f326d52d36da2fc.1332116921.git.joe@perches.com>
References: <cover.1332116921.git.joe@perches.com>
	<b157e2d1a746733d1814b9726f326d52d36da2fc.1332116921.git.joe@perches.com>
Date: Sun, 18 Mar 2012 21:36:49 -0700
X-Google-Sender-Auth: 4-HOnSQ0LBYXwXsI77Izxeji1_o
Message-ID: <CAJ-Vmo=ceSV38vQGfs8cKJScWjYF4kbQdK3+JJvQLCmnURaEwA@mail.gmail.com>
Subject: Re: [PATCH wireless-next 2/3] ath5k: Introduce _ath5k_printk to
 reduce code/text
From: Adrian Chadd <adrian@freebsd.org>
To: Joe Perches <joe@perches.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Nick Kossifidis <mickflemm@gmail.com>,
        "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
        Bob Copeland <me@bobcopeland.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

So the reason this is a macro in the FreeBSD HAL is so that the args
aren't evaluated unless the level (or debug bitmap in my case) fires
off.

Otherwise compiling in debugging will cause a _lot_ of spurious
register reads to occur that are then tossed. This was one of the big
reasons for instability and slow performance when AH_DEBUG was
enabled.



Adrian
