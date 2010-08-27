Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab0H0ABu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 20:01:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38616 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754832Ab0H0ABp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 20:01:45 -0400
Date: Fri, 27 Aug 2010 01:18:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Matthew Garrett <mjg@redhat.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel_ips: quieten "power or thermal limit exceeded"
 messages
Message-ID: <20100827011853.3faef5e7@lxorguk.ukuu.org.uk>
In-Reply-To: <1282865341-17607-1-git-send-email-cesarb@cesarb.net>
References: <4C74686D.8090707@cesarb.net>
	<1282865341-17607-1-git-send-email-cesarb@cesarb.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Aug 2010 20:29:01 -0300
Cesar Eduardo Barros <cesarb@cesarb.net> wrote:

> On my Dell Inspiron N4010, one of these messages is printed every five
> seconds. Change both to dev_dbg to quieten them even more.

It's not the kind of thing you want to quieten since in most cases it is
stuff you want to know about.

> 
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
> ---
>  drivers/platform/x86/intel_ips.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/platform/x86/intel_ips.c b/drivers/platform/x86/intel_ips.c
> index 9024480..7833adc 100644
> --- a/drivers/platform/x86/intel_ips.c
> +++ b/drivers/platform/x86/intel_ips.c
> @@ -607,7 +607,7 @@ static bool mcp_exceeded(struct ips_driver *ips)
>  	spin_unlock_irqrestore(&ips->turbo_status_lock, flags);
>  
>  	if (ret)
> -		dev_info(&ips->dev->dev,
> +		dev_dbg(&ips->dev->dev,
>  			 "MCP power or thermal limit exceeded\n");

Probably better to ratelimit it. Being told it occurs is important, being
told every five seconds is indeed excessive.

Alan
