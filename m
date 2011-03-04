Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759980Ab1CDSb0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 13:31:26 -0500
Received: from xenotime.net ([184.105.210.51]:38962 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758463Ab1CDSbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 13:31:25 -0500
Date: Fri, 4 Mar 2011 10:31:21 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: j223yang@asset.uwaterloo.ca
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch] ariadne: fix possible null dereference
Message-Id: <20110304103121.81a2364b.rdunlap@xenotime.net>
In-Reply-To: <20110304174625.GA31042@asset.uwaterloo.ca>
References: <20110304174625.GA31042@asset.uwaterloo.ca>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Mar 2011 12:46:26 -0500 j223yang@asset.uwaterloo.ca wrote:

> This patch fixes bugzilla #13853:
> https://bugzilla.kernel.org/show_bug.cgi?id=13853
> 
> The patch removes dereference of 'dev' after testing for NULL.
> The source code ariadne.c uses spaces instead of tabs, so the patch
> uses spaces too.

Sorry for the confusion here, but (while I agree with the fix in this
patch), this patch still does not apply cleanly.

If a line in the source code file uses spaces, then use spaces.
If a line in the source code file uses tabs, then use tabs.

You cannot exchange one for the other in your generated patch.
Using 'diff' creates the patch correctly, so I guess that your patch
generation tool still needs some work.

Please take your patch and test applying it:

> cd linux-2.6.38-rc7
> patch -p1 --dry-run < ~/tmp/ariadne.patch
patching file drivers/net/ariadne.c
Hunk #2 FAILED at 430.
1 out of 2 hunks FAILED -- saving rejects to file drivers/net/ariadne.c.rej


> Signed-off-by: Jinqiu Yang<crindy646@gmail.com>
> ---
>  drivers/net/ariadne.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ariadne.c b/drivers/net/ariadne.c
> --- a/drivers/net/ariadne.c
> +++ b/drivers/net/ariadne.c
> @@ -420,7 +420,7 @@ static inline void ariadne_reset(struct
>  static irqreturn_t ariadne_interrupt(int irq, void *data)
>  {
>      struct net_device *dev = (struct net_device *)data;
> -    volatile struct Am79C960 *lance = (struct Am79C960*)dev->base_addr;
> +    volatile struct Am79C960 *lance;
>      struct ariadne_private *priv;
>      int csr0, boguscnt;
>      int handled = 0;
> @@ -430,6 +430,7 @@ static irqreturn_t ariadne_interrupt(int
>         return IRQ_NONE;
>      }
> 
> +    lance = (struct Am79C960 *)dev->base_addr;
>      lance->RAP = CSR0;                 /* PCnet-ISA Controller Status */
> 
>      if (!(lance->RDP & INTR))          /* Check if any interrupt has been */
> 
> --

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
