Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab0LASZX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 13:25:23 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38744 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755437Ab0LASZV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 13:25:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FsbKxTw7hQockKPin06ZCA8COzSHY5Q6MWNJH/SAzVAiwaJf/gzBatC0EH9NeoW0We
         Us8mGZIGoCY4pScIUrcu6mwpSTbDMlFEK6Ib61tEsNxXtrx1Ip+GVV6emchSDFvUYpZw
         wrW0o4lK/uerAZsavGRTBz4vjRfWMjGuD/IcE=
MIME-Version: 1.0
In-Reply-To: <8879.1290741991@death>
References: <AANLkTinpO=FmoecfV8epubXU4OrhFsXJ7-Kc68yNhMEs@mail.gmail.com>
	<31169.1290641617@death>
	<AANLkTi=-DzUmopboX13V_cd=mZnmD=mBNNCuhQYF0PQQ@mail.gmail.com>
	<8879.1290741991@death>
Date: Wed, 1 Dec 2010 10:25:19 -0800
Message-ID: <AANLkTi=+jMkrgNjVQvOOn_zURiJ4rXu5LL9eA4o0T9db@mail.gmail.com>
Subject: Re: [PATCH] bonding: check for assigned mac before adopting the
 slaves mac address
From: David Strand <dpstrand@gmail.com>
To: Jay Vosburgh <fubar@us.ibm.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 7:26 PM, Jay Vosburgh <fubar@us.ibm.com> wrote:
>
>        Ok, fair enough.  If we want to get back to the original
> behavior, however, your patch should only test for zero MAC address
> instead of testing for zero MAC address in addition to first slave.
>
>        -J
>
> ---
>        -Jay Vosburgh, IBM Linux Technology Center, fubar@us.ibm.com
>

Understood, that makes sense. The updated patch is below.

---
diff -uprN a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
--- a/drivers/net/bonding/bond_main.c	2010-11-24 11:36:58.125640000 -0800
+++ b/drivers/net/bonding/bond_main.c	2010-12-01 10:12:33.728640001 -0800
@@ -1576,7 +1576,7 @@ int bond_enslave(struct net_device *bond

 	/* If this is the first slave, then we need to set the master's hardware
 	 * address to be the same as the slave's. */
-	if (bond->slave_cnt == 0)
+	if (is_zero_ether_addr(bond->dev->dev_addr))
 		memcpy(bond->dev->dev_addr, slave_dev->dev_addr,
 		       slave_dev->addr_len);
