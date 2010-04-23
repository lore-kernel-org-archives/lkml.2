Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855Ab0DWJde (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 05:33:34 -0400
Received: from poutre.nerim.net ([62.4.16.124]:49425 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756812Ab0DWJdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 05:33:32 -0400
Date: Fri, 23 Apr 2010 11:33:26 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Farid Hammane <farid.hammane@gmail.com>
Cc: w.sang@pengutronix.de, ben-linux@fluff.org, Enrik.Berkhan@ge.com,
       linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] i2c-algo-pca: fix coding style issues in
 i2c-algo-pca.c
Message-ID: <20100423113326.3691bdd6@hyperion.delvare>
In-Reply-To: <1271973715-18331-1-git-send-email-farid.hammane@gmail.com>
References: <1271973715-18331-1-git-send-email-farid.hammane@gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Farid, Wolfram,

On Fri, 23 Apr 2010 00:01:55 +0200, Farid Hammane wrote:
> This patch fixes coding style issues found by checkpatch.pl.
> i2c-algo-pca.c has been built successfully after applying this patch.
> 
> Signed-off-by: Farid Hammane <farid.hammane@gmail.com>
> ---
>  drivers/i2c/algos/i2c-algo-pca.c |   36 ++++++++++++++++++------------------
>  1 files changed, 18 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/i2c/algos/i2c-algo-pca.c b/drivers/i2c/algos/i2c-algo-pca.c
> index dcdaf8e..ca817f8 100644
> --- a/drivers/i2c/algos/i2c-algo-pca.c
> +++ b/drivers/i2c/algos/i2c-algo-pca.c
> @@ -37,15 +37,15 @@
>  
>  static int i2c_debug;
>  
> -#define pca_outw(adap, reg, val) adap->write_byte(adap->data, reg, val)
> -#define pca_inw(adap, reg) adap->read_byte(adap->data, reg)
> +#define pca_outw(adap, reg, val) (adap->write_byte(adap->data, reg, val))
> +#define pca_inw(adap, reg) (adap->read_byte(adap->data, reg))

I'm confused by these changes. For one thing, macros which are
shortcuts for function calls normally don't need surrounding
parentheses. If checkpatch.pl complains about that, I would call it a
false positive, unless someone can prove me wrong with a real-world
case where these surrounding parentheses help.

For another, macro _parameters_ normally need parentheses for each
non-trivial use. I would thus expect the following to be correct:

#define pca_outw(adap, reg, val) (adap)->write_byte((adap)->data, reg, val)
#define pca_inw(adap, reg) (adap)->read_byte((adap)->data, reg)

Or is it just me?

>  
>  #define pca_status(adap) pca_inw(adap, I2C_PCA_STA)
> -#define pca_clock(adap) adap->i2c_clock
> +#define pca_clock(adap) (adap->i2c_clock)
>  #define pca_set_con(adap, val) pca_outw(adap, I2C_PCA_CON, val)
>  #define pca_get_con(adap) pca_inw(adap, I2C_PCA_CON)
> -#define pca_wait(adap) adap->wait_for_completion(adap->data)
> -#define pca_reset(adap) adap->reset_chip(adap->data)
> +#define pca_wait(adap) (adap->wait_for_completion(adap->data))
> +#define pca_reset(adap) (adap->reset_chip(adap->data))

Same here...

I'm fine with all other changes. But checkpatch.pl spouts 2 more errors
to me, which we've discussed before. I'm curious why you didn't fix
them? Just replace each block of 8 spaces with one tab.

ERROR: code indent should use tabs where possible
#181: FILE: i2c/algos/i2c-algo-pca.c:181:
+                    struct i2c_msg *msgs,$

ERROR: code indent should use tabs where possible
#182: FILE: i2c/algos/i2c-algo-pca.c:182:
+                    int num)$

-- 
Jean Delvare
