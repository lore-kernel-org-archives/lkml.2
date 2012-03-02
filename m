Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741Ab2CBNN4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 08:13:56 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56628 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757510Ab2CBNNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 08:13:54 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of eric.dumazet@gmail.com designates 10.68.232.42 as permitted sender) smtp.mail=eric.dumazet@gmail.com; dkim=pass header.i=eric.dumazet@gmail.com
Message-ID: <1330694031.2469.15.camel@edumazet-laptop>
Subject: Re: [PATCH 0/10] af_unix: add multicast and filtering features to
 AF_UNIX
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: David Miller <davem@davemloft.net>, shemminger@vyatta.com,
        ying.xue@windriver.com, luiz.dentz@gmail.com,
        rodrigo.moya@collabora.co.uk, javier@collabora.co.uk,
        lennart@poettering.net, kay.sievers@vrfy.org,
        alban.crequy@collabora.co.uk, bart.cerneels@collabora.co.uk,
        sjoerd.simons@collabora.co.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 02 Mar 2012 05:13:51 -0800
In-Reply-To: <4F509274.9060302@collabora.co.uk>
References: <CABBYNZJ-xxQXAx+ecrkVLqmWFaUVqLcQLj0Jxa3McSLnkLJSJw@mail.gmail.com>
	 <20120301.170848.432407217191581288.davem@davemloft.net>
	 <CABBYNZLwHKd5srzYYzWNL-iaeuH1K31824pY_bjRSbSLkv0QtA@mail.gmail.com>
	 <20120302.035509.1994457175982020283.davem@davemloft.net>
	 <4F509274.9060302@collabora.co.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 02 mars 2012 à 10:27 +0100, Javier Martinez Canillas a
écrit :

> We are the most interested in using a facility already found in the
> kernel, we will try ZeroMQ as Stephen suggested and TIPC but really
> didn't find an IPC mechanism that fits our needs. The most important
> issue right now is the fd passing for D-bus application doing
> out-of-band communication.

Why on earth the needed D-Bus IPC should use a single kernel mechanism ?

I mean, of course AF_INET cannot pass fd around and never will.
Of course AF_UNIX cannot use multicast and never will.
Of course shared memory wont pass fds around and never will.
... Add other impossible combinations as you want.

There are reasons fd passing is hard to implement. I find stuffing this
functionality in AF_UNIX was a bad design choice from the very
beginning.

Instead of pushing extra complexity to a single kernel component, why
not trying to use a combination of existing, well designed and supported
ones ?



