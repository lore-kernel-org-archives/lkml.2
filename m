Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656Ab0KYApY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 19:45:24 -0500
Received: from smtp-out.google.com ([216.239.44.51]:4728 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486Ab0KYApX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 19:45:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=DlqFBeWXNrzVJ7nePIvsL+2v1C4lUkYJt1n7sNHXiRMsyuJ2X1g87Q/3UIexX+cwAQ
         /Mli9xLOAXuQDhoqyuDQ==
MIME-Version: 1.0
In-Reply-To: <31169.1290641617@death>
References: <AANLkTinpO=FmoecfV8epubXU4OrhFsXJ7-Kc68yNhMEs@mail.gmail.com> <31169.1290641617@death>
From: Laurent Chavey <chavey@google.com>
Date: Wed, 24 Nov 2010 16:44:40 -0800
Message-ID: <AANLkTinoWQg_a9pd44+dOm=e1sWhSy=mivNJkEJk1N8y@mail.gmail.com>
Subject: Re: [PATCH] bonding: check for assigned mac before adopting the
 slaves mac address
To: Jay Vosburgh <fubar@us.ibm.com>
Cc: David Strand <dpstrand@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

based on the new code, the behavior of ifenslave works the same.


>-       if (bond->slave_cnt == 0)
>+       if (is_zero_ether_addr(bond->dev->dev_addr))
>-              memcpy(bond->dev->dev_addr, slave_dev->dev_addr,
>-                            slave_dev->addr_len);
> +            bond_sethwaddr(bond, slave_dev);


On Wed, Nov 24, 2010 at 3:33 PM, Jay Vosburgh <fubar@us.ibm.com> wrote:
> David Strand <dpstrand@gmail.com> wrote:
>
>>Restore the check for a missing mac address before adopting the first
>>slaves as it's own. This regression was introduced in:
>>http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.36.y.git;a=commit;h=c20811a79e671a6a1fe86a8c1afe04aca8a7f085
>
>        How exactly is this a regression?  The above referenced patch
> changes the method used to decide if the bonding master needs to have
> it's MAC address set.  The original way was "bonding master's MAC is
> zero," after the above, it's "adding first slave."
>
>        Do you have some use case that manually sets the master's MAC
> address prior to adding any slaves?
>
>        -J
>
>>Signed-off-by: David Strand dpstrand@gmail.com
>>---
>>diff -uprN a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>>--- a/drivers/net/bonding/bond_main.c  2010-11-24 11:36:58.125640000 -0800
>>+++ b/drivers/net/bonding/bond_main.c  2010-11-24 11:40:58.175640000 -0800
>>@@ -1577,8 +1577,9 @@ int bond_enslave(struct net_device *bond
>>       /* If this is the first slave, then we need to set the master's hardware
>>        * address to be the same as the slave's. */
>>       if (bond->slave_cnt == 0)
>>-              memcpy(bond->dev->dev_addr, slave_dev->dev_addr,
>>-                     slave_dev->addr_len);
>>+              if (is_zero_ether_addr(bond->dev->dev_addr))
>>+                      memcpy(bond->dev->dev_addr, slave_dev->dev_addr,
>>+                             slave_dev->addr_len);
>>
>>
>>       new_slave = kzalloc(sizeof(struct slave), GFP_KERNEL);
>
> ---
>        -Jay Vosburgh, IBM Linux Technology Center, fubar@us.ibm.com
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
--------------------------------------------------------------------------------
