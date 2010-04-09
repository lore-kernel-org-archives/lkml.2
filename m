Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581Ab0DIWJR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 18:09:17 -0400
Received: from mail.gmx.net ([213.165.64.20]:42859 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751101Ab0DIWJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 18:09:10 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+FQPJRMx6FxDcOrjiIBmwg2A6vlJG2hUBCXNiHN5
	ILHuyJdNW1+pSM
Message-ID: <4BBFA582.2010701@gmx.de>
Date: Sat, 10 Apr 2010 00:09:06 +0200
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Deepak Saxena <dsaxena@laptop.org>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH 10/16] suppress verbose debug messages:  change printk()
 to DEBUG_MSG()
References: <1270746946-12467-1-git-send-email-corbet@lwn.net> <1270746946-12467-11-git-send-email-corbet@lwn.net>
In-Reply-To: <1270746946-12467-11-git-send-email-corbet@lwn.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.51000000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is fine.


Thanks,

Florian Tobias Schandinat

Jonathan Corbet schrieb:
> From: Paul Fox <pgf@laptop.org>
> 
> ---
>  drivers/video/via/via_i2c.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/video/via/via_i2c.c b/drivers/video/via/via_i2c.c
> index 18bbbdd..86e6e8d 100644
> --- a/drivers/video/via/via_i2c.c
> +++ b/drivers/video/via/via_i2c.c
> @@ -26,7 +26,7 @@ static void via_i2c_setscl(void *data, int state)
>  	u8 val;
>  	struct via_i2c_adap_cfg *adap_data = data;
>  
> -	printk(KERN_DEBUG "reading index 0x%02x from IO 0x%x\n",
> +	DEBUG_MSG(KERN_DEBUG "reading index 0x%02x from IO 0x%x\n",
>  		adap_data->ioport_index, adap_data->io_port);
>  	val = viafb_read_reg(adap_data->io_port,
>  			     adap_data->ioport_index) & 0xF0;
> @@ -140,7 +140,7 @@ static int create_i2c_bus(struct i2c_adapter *adapter,
>  			  struct via_i2c_adap_cfg *adap_cfg,
>  			  struct pci_dev *pdev)
>  {
> -	printk(KERN_DEBUG "viafb: creating bus adap=0x%p, algo_bit_data=0x%p, adap_cfg=0x%p\n", adapter, algo, adap_cfg);
> +	DEBUG_MSG(KERN_DEBUG "viafb: creating bus adap=0x%p, algo_bit_data=0x%p, adap_cfg=0x%p\n", adapter, algo, adap_cfg);
>  
>  	algo->setsda = via_i2c_setsda;
>  	algo->setscl = via_i2c_setscl;
> @@ -182,7 +182,7 @@ static struct via_i2c_adap_cfg adap_configs[] = {
>  int viafb_create_i2c_busses(struct viafb_par *viapar)
>  {
>  	int i, ret;
> -	printk(KERN_DEBUG "%s: entering\n", __FUNCTION__);
> +	DEBUG_MSG(KERN_DEBUG "%s: entering\n", __FUNCTION__);
>  
>  	for (i = 0; i < VIAFB_NUM_I2C; i++) {
>  		struct via_i2c_adap_cfg *adap_cfg = &adap_configs[i];

