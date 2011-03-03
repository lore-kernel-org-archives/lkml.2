Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033Ab1CCCUX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 21:20:23 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45268 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757438Ab1CCCUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 21:20:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=fzpUsQsx/YoqBMyRC3IUPJ8H+hnAlWEZboaXssrPCkYnF2QhmppNX0CF5+SxK/3Avl
         hlBYCaQTupfckGOjWCK/exs7p5uD6QhCUvjDbd6Foc8UQiryrfngbtqCn5FE1BdxjN7p
         7ipTfsniTb4E4QlZnN+Kb+hoHYIj5ggmswVDY=
Message-ID: <4D6EFAE5.4000400@gmail.com>
Date: Wed, 02 Mar 2011 21:20:21 -0500
From: Jinqiu <crindy646@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; zh-CN; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [patch] Fix bug #13853: dereference pointer 'dev' before null check
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes bug #13853 .This still exists in latest version.
'dev' is dereferenced before testing for NULL.

Signed-off-by: Jinqiu Yang<crindy646@gmail.com>
--- a/drivers/net/ariadne.c
+++ b/drivers/net/ariadne.c
@@ -420,7 +420,7 @@ static inline void ariadne_reset(struct
static irqreturn_t ariadne_interrupt(int irq, void *data)
{
	struct net_device *dev = (struct net_device *) data;
- 	volatile struct Am79C960 *lance = (struct Am79C960*)dev->base_addr;
+ 	volatile struct Am79C960 *lance;
	struct ariadne_private *priv;
	int csr0, boguscnt;
	int handled = 0;
@@ -429,6 +429, 7 @@ static irqreturn_t ariadne_interrupt(int
		printk(KERN_WARNING  "ariadne_interrupt(): irq for unknown device.\n");
		return IRQ_NONE;
	}
+ 	lance = (struct Am79C960 *)dev->base_addr;

	lance->RAP = CSR0; 					/* PCnet-ISA Controller Status */




