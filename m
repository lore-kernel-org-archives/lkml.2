Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494Ab2IOFeZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 01:34:25 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:51410 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750988Ab2IOFeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 01:34:23 -0400
Message-ID: <1347687257.2072.4.camel@joe2Laptop>
Subject: Re: [PATCH] i2c/scx200_*: replace printks with pr_<level>s
From: Joe Perches <joe@perches.com>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 14 Sep 2012 22:34:17 -0700
In-Reply-To: <1347679318-6834-1-git-send-email-jim.cromie@gmail.com>
References: <1347679318-6834-1-git-send-email-jim.cromie@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-14 at 21:21 -0600, Jim Cromie wrote:
> Replace printks with pr_<level>s, add pr_fmt()s to replace NAMEs

Hi Jim.

When you do these, please maximally fill to 80 columns the printk
arguments and coalesce formats without regard to 80 columns.

> diff --git a/drivers/i2c/busses/scx200_acb.c b/drivers/i2c/busses/scx200_acb.c
> @@ -406,7 +408,7 @@ static __devinit int scx200_acb_probe(struct scx200_acb_iface *iface)
>  
>  	val = inb(ACBCTL1);
>  	if (val) {
> -		pr_debug(NAME ": disabled, but ACBCTL1=0x%02x\n",
> +		pr_debug("disabled, but ACBCTL1=0x%02x\n",
>  			val);

		pr_debug("disabled, but ACBCTL1=0x%02x\n", val);

> @@ -417,7 +419,7 @@ static __devinit int scx200_acb_probe(struct scx200_acb_iface *iface)
>  
>  	val = inb(ACBCTL1);
>  	if ((val & ACBCTL1_NMINTE) != ACBCTL1_NMINTE) {
> -		pr_debug(NAME ": enabled, but NMINTE won't be set, "
> +		pr_debug("enabled, but NMINTE won't be set, "
>  			 "ACBCTL1=0x%02x\n", val);

		pr_debug("enabled, but NMINTE won't be set, ACBCTL1=0x%02x\n",
			  val);
etc...


