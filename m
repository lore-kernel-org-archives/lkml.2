Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793Ab1BAWmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 17:42:38 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38462 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab1BAWmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 17:42:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=W69yw2WiJTHJClTv4qztBH0I92YzAGBjAfYuVDSsnI7bcgBkkJP+FphquiAY4OCcMg
         y3xxHtzySHdUB3DYZfE+GsNfAjNFEabqTY719AuvqahMOnUOFC+ZRNZ9O6JadcLZlVpg
         iXMf9EKdMFSkZ+nL9BIrRckggvX78scJhQjLw=
Message-ID: <4D488C5A.7020107@gmail.com>
Date: Tue, 01 Feb 2011 16:42:34 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: devicetree-discuss@lists.ozlabs.org, jeremy.kerr@canonical.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        nicolas.pitre@linaro.org
Subject: Re: [RFC PATCH 3/5] of: add clock providers
References: <20110126043338.16410.75019.stgit@localhost6.localdomain6> <20110126044416.16410.68942.stgit@localhost6.localdomain6>
In-Reply-To: <20110126044416.16410.68942.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant,

On 01/25/2011 10:44 PM, Grant Likely wrote:
> +struct clk *of_clk_get(struct device *dev, const char *id)

It would help if this took a struct device_node rather than struct 
device. This would allow using of_clk_get directly for cases where you 
don't have a struct device. This is fairly common in core platform core 
which are not full drivers. The case I have run into is the timer init 
code. To make clk_get work, I would have to create a dummy struct device.

Alternatively, an of_clk_get_sys function is needed.

 > +{
> +	struct device_node *provnode;
> +	u32 provhandle;
> +	int sz;
> +	struct clk *clk;
> +	char prop_name[32]; /* 32 is max size of property name */
> +	const void *prop;
> +
> +	dev_dbg(dev, "Looking up %s-clock from device tree\n", id);
> +
> +	snprintf(prop_name, 32, "%s-clock", id ? id : "bus");

Many times a module just has 1 clock and id will be NULL. Is "bus-clock" 
really the best choice of name? A bus clock may exist, but be 
transparent to s/w. How about allowing "clock" or "%s-clock"?

If bus-clock is the default, then you should add this to the clock 
binding wiki page.

Rob
