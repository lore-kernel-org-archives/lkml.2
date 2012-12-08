Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933695Ab2LHPwo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 10:52:44 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:37249 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933088Ab2LHPwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 10:52:43 -0500
X-IronPort-AV: E=Sophos;i="4.84,243,1355094000"; 
   d="scan'208";a="185237021"
Date: Sat, 8 Dec 2012 16:52:42 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: plagnioj@jcrosoft.com, linus.walleij@linaro.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: question about drivers/pinctrl/pinctrl-at91.c
Message-ID: <alpine.DEB.2.02.1212081643590.1984@hadrien>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function at91_dt_node_to_map in drivers/pinctrl/pinctrl-at91.c 
contains the following code:

        new_map = devm_kzalloc(pctldev->dev, sizeof(*new_map) * map_num, GFP_KERNEL);
         if (!new_map)
                 return -ENOMEM;

         *map = new_map;
         *num_maps = map_num;

         /* create mux map */
         parent = of_get_parent(np);
         if (!parent) {
                 kfree(new_map);
                 return -EINVAL;
         }

This is clearly not correct, because the combination of devm_kzalloc and 
kfree risks creating a double free.  But I am not sure how best to fix it. 
Is the data structure intended to normally exist until the driver's remove 
function is called?  If so, perhaps the devm_kzalloc is OK.  If I just 
remove the kfree, then the structure will persist until the remove 
function is called, even though there was an error, which is perhaps not 
good.  So I could change the kfree to devm_kfree?

thanks,
julia
