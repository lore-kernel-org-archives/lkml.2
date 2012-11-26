Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab2KZNZS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 08:25:18 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63247 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653Ab2KZNZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 08:25:16 -0500
MIME-Version: 1.0
In-Reply-To: <20121126234844.1952cdd84c3ba041cfe7a9af@canb.auug.org.au>
References: <20121126234844.1952cdd84c3ba041cfe7a9af@canb.auug.org.au>
Date: Mon, 26 Nov 2012 21:25:14 +0800
Message-ID: <CAJn8CcFVOS-pR6O7AGTLKE-47qWOUCDaMXA9Xa-BsdJ7ks2stw@mail.gmail.com>
Subject: Re: linux-next: manual merge of the akpm tree with Linus' tree
From: Xiaotian Feng <xtfeng@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2012 at 8:48 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Andrew,
>
> Today's linux-next merge of the akpm tree got a conflict in
> drivers/net/ethernet/jme.c between commit 71c6c837a0fe ("drivers/net: fix
> tasklet misuse issue") from Linus' tree and commit  "tasklet: ignore
> disabled tasklet in tasklet_action()" from the akpm tree.
>

You can simply remove the following part of the patch


@@ -1862,8 +1862,8 @@ jme_open(struct net_device *netdev)

         tasklet_enable(&jme->linkch_task);
         tasklet_enable(&jme->txclean_task);
-       tasklet_hi_enable(&jme->rxclean_task);
-       tasklet_hi_enable(&jme->rxempty_task);
+       tasklet_enable(&jme->rxclean_task);
+       tasklet_enable(&jme->rxempty_task);

         rc = jme_request_irq(jme);
         if (rc)

Do you want me to re-generate a patch for you?


> I am not sure what to do here, so I have dropped the akpm patch.
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
