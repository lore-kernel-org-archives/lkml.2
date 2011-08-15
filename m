Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab1HONzd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 09:55:33 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:36261 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753592Ab1HONzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 09:55:31 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 3Atd.XkVM1nreeOM3Z_pXVDoqWO18GjPTKDf7ezkfDKMdAW
 gxUsCpTZo3ZOkA57ZiWHfBtBbu7IXttmSWKiB8.h5MyB2UJgiqni_wV7aXrl
 8pjYgB.2kPA1DmneZHGZ9vwNyhHcP.p8un3bDvsxQGZiZbKCLRra_BBLkS9W
 uUzmFI3Hd.rT0xLNHu4S1mSm.EkWTSXbvSOyu9KCb5FxopmX2NwrXVWUCaSR
 ygrUrwNVEsVZN62Nub6CP3RwQ7JWmzkKDmq0OIJ7AH.gI944o1OpCV8mMcYC
 7br.Pw8VgDaInFfISOoaT8yeBlFt5mwWYwelwrRXEq5__qNg.9SfVLYWzb0B
 G012YpTdNkgvYF5qY_KBEWTUzTT4LBfOGHq0cPgTO1gkeWA--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 15 Aug 2011 08:55:28 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Iliyan Malchev <malchev@google.com>
cc: Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] slub: extend slub_debug to handle multiple slabs
In-Reply-To: <1312839019-17987-1-git-send-email-malchev@google.com>
Message-ID: <alpine.DEB.2.00.1108150853170.22335@router.home>
References: <1312839019-17987-1-git-send-email-malchev@google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Aug 2011, Iliyan Malchev wrote:

> Extend the slub_debug syntax to "slub_debug=<flags>[,<slub>]*", where <slub>
> may contain an asterisk at the end.  For example, the following would poison
> all kmalloc slabs:
>
> 	slub_debug=P,kmalloc*

The use of the star suggests that general regexps will be working. But
this is only allowing a star at the end. It is explained later. So maybe
that ok.

> +	n = slub_debug_slabs;
> +	while (*n) {
> +		int cmplen;
> +
> +		end = strchr(n, ',');
> +		if (!end)
> +			end = n + strlen(n);
> +
> +		glob = strnchr(n, end - n, '*');
> +		if (glob)
> +			cmplen = glob - n;
> +		else
> +			cmplen = max(len, end - n);
> +
> +		if (!strncmp(name, n, cmplen)) {
> +			flags |= slub_debug;
> +			break;
> +		}
> +
> +		n = *end ? end + 1 : end;

Ugg.. Confusing

How about

		if (!*end)
			break;
		n = end + 1;

or make the while loop into a for loop?
