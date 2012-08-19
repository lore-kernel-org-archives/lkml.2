Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761Ab2HSKHv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 06:07:51 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:65216 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab2HSKHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 06:07:47 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1208191149400.2031@localhost6.localdomain6>
References: <1345325159-7365-1-git-send-email-Julia.Lawall@lip6.fr>
	<CA++WF2MmTe6WP6MQRV-v1VwkpcUrw4hU6yh79NdG-K4snzQkbg@mail.gmail.com>
	<alpine.DEB.2.02.1208191149400.2031@localhost6.localdomain6>
Date: Sun, 19 Aug 2012 14:07:46 +0400
Message-ID: <CA++WF2Np75wKXV-2C-FR2vhzcPvMu+z5MixcPy4ajOdHM0K88Q@mail.gmail.com>
Subject: Re: [PATCH 1/5] drivers/net/wireless/ipw2x00/ipw2100.c: introduce
 missing initialization
From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 August 2012 13:49, Julia Lawall <julia.lawall@lip6.fr> wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>
> The result of one call to a function is tested, and then at the second call
> to the same function, the previous result, and not the current result, is
> tested again.
>
> Also changed &bssid to bssid, at the suggestion of Stanislav Yakovlev.
>
> The semantic match that finds the first problem is as follows:
>
> (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @@
> expression ret;
> identifier f;
> statement S1,S2;
> @@
>
> *ret = f(...);
> if (\(ret != 0\|ret < 0\|ret == NULL\)) S1
> ... when any
> *f(...);
> if (\(ret != 0\|ret < 0\|ret == NULL\)) S2
> // </smpl>
>
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>
> ---
> v2: changed &bssid to bssid
>

Thank you, Julia.

Stanislav.
