Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703Ab2E2KnQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 06:43:16 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35702 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506Ab2E2KnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 06:43:15 -0400
Date: Tue, 29 May 2012 11:45:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Avik Sil <avik.sil@linaro.org>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Perf: Use /usr/bin/pager if available for perf pager
Message-ID: <20120529114506.7c8d6157@pyramind.ukuu.org.uk>
In-Reply-To: <1338287725-26382-1-git-send-email-avik.sil@linaro.org>
References: <1338287725-26382-1-git-send-email-avik.sil@linaro.org>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2012 16:05:25 +0530
Avik Sil <avik.sil@linaro.org> wrote:

> Some Distributions may lack "less" package being included by default, e.g., Linaro nano rootfs. In those cases use the portable "pager" command instead of "less".
> 
> Signed-off-by: Avik Sil <avik.sil@linaro.org>
> ---
>  tools/perf/util/pager.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/tools/perf/util/pager.c b/tools/perf/util/pager.c
> index 1915de2..3322b84 100644
> --- a/tools/perf/util/pager.c
> +++ b/tools/perf/util/pager.c
> @@ -57,6 +57,10 @@ void setup_pager(void)
>  	}
>  	if (!pager)
>  		pager = getenv("PAGER");
> +	if (!pager) {
> +		if (!access("/usr/bin/pager", X_OK))
> +			pager = "/usr/bin/pager";
> +	}

What is "portable" about /usr/bin/pager ? and what is wrong with just
doing

export PAGER=/usr/bin/pager

Alan
