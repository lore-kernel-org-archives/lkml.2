Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933580Ab2ERAH4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 20:07:56 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:36338 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932585Ab2ERAHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 20:07:54 -0400
Date: Thu, 17 May 2012 20:05:09 -0400 (EDT)
Message-Id: <20120517.200509.2290282427866555176.davem@davemloft.net>
To: bpoirier@suse.de
Cc: netdev@vger.kernel.org, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, linux-kernel@vger.kernel.org,
        steffen.klassert@secunet.com
Subject: Re: [PATCH v3] xfrm: take iphdr size into account for esp payload
 size calculation
From: David Miller <davem@davemloft.net>
In-Reply-To: <1337196925-4919-1-git-send-email-bpoirier@suse.de>
References: <20120514.183952.1459413342269893446.davem@davemloft.net>
	<1337196925-4919-1-git-send-email-bpoirier@suse.de>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 17 May 2012 17:05:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Poirier <bpoirier@suse.de>
Date: Wed, 16 May 2012 15:35:25 -0400

> Corrects the function that determines the esp payload size.
> The calculations done in esp4_get_mtu lead to overlength frames in transport
> mode for certain mtu values and suboptimal frames for others.
> 
> According to what is done, mainly in esp_output(), net_header_len aka
> sizeof(struct iphdr) must be taken into account before doing the alignment
> calculation.
> 
> Signed-off-by: Benjamin Poirier <bpoirier@suse.de>

This looks great.

Could you please fix net/ipv6/esp6.c too, it seems to have the same
exact bug.

Once you respin this patch with both ipv4 and ipv6 fixed, I'll apply
it.

Thank you.
