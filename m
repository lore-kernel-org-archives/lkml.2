Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab2LJKEi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 05:04:38 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:47519 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab2LJKEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 05:04:36 -0500
MIME-Version: 1.0
In-Reply-To: <1354925658-24115-2-git-send-email-joseph.gasparakis@intel.com>
References: <1354925658-24115-1-git-send-email-joseph.gasparakis@intel.com> <1354925658-24115-2-git-send-email-joseph.gasparakis@intel.com>
From: saeed bishara <saeed.bishara@gmail.com>
Date: Mon, 10 Dec 2012 12:04:15 +0200
Message-ID: <CAMAG_ee6xW4EnzPFt=_5+NL2+LuyUjxd52Xc242inYm2+Yhg7g@mail.gmail.com>
Subject: Re: [PATCH v4 1/5] net: Add support for hardware-offloaded encapsulation
To: Joseph Gasparakis <joseph.gasparakis@intel.com>
Cc: davem@davemloft.net, shemminger@vyatta.com, chrisw@sous-sol.org,
        gospo@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry@broadcom.com, bhutchings@solarflare.com,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static inline struct iphdr *inner_ip_hdr(const struct sk_buff *skb)
> +{
> +       return (struct iphdr *)skb_inner_network_header(skb);
> +}

Hi,
I'm a little bit bothered because of those inner_ functions, what
about the following approach:
1. the skb will have a new state, that state can be outer (normal
mode) and inner.
2. when you change the state to inner, all the helper functions such
as ip_hdr will return the innter header.

that's ofcourse the API side. the implementation may still use the
fields you added to the skb.

what you think?
saeed
