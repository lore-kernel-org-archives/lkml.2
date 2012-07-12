Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446Ab2GLIqQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 04:46:16 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:59309 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475Ab2GLIqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 04:46:12 -0400
Date: Thu, 12 Jul 2012 09:49:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Devendra Naga <devendra.aaru@gmail.com>
Cc: Mark Einon <mark.einon@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Francois Romieu <romieu@fr.zoreil.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging/et131x: remove memset for the TCB
Message-ID: <20120712094943.2aba6d33@pyramind.ukuu.org.uk>
In-Reply-To: <1342073368-11893-1-git-send-email-devendra.aaru@gmail.com>
References: <1342073368-11893-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2012 11:54:28 +0545
Devendra Naga <devendra.aaru@gmail.com> wrote:

> TCB has kcalloc' ed so no need to call memset again on it.
> 
> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
> ---
>  drivers/staging/et131x/et131x.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
> index 227fca9..5010894 100644
> --- a/drivers/staging/et131x/et131x.c
> +++ b/drivers/staging/et131x/et131x.c
> @@ -2131,8 +2131,6 @@ static void et131x_init_send(struct et131x_adapter *adapter)
>  
>  	tx_ring->tcb_qhead = tcb;
>  
> -	memset(tcb, 0, sizeof(struct tcb) * NUM_TCB);

Its such a rarely used path with several entry points that it's probably
safer kept as is.

Alan
