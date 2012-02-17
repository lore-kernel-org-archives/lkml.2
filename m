Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab2BQVgo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 16:36:44 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:60222 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751809Ab2BQVgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 16:36:43 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2 07/10] cisco/enic: use eth_hw_addr_random() instead of random_ether_addr()
Date: Fri, 17 Feb 2012 22:35:42 +0100
User-Agent: KMail/1.9.10
Cc: benve@cisco.com, roprabhu@cisco.com, dwang2@cisco.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1329493411-25750-1-git-send-email-danny.kukawka@bisect.de> <1329493411-25750-8-git-send-email-danny.kukawka@bisect.de> <20120217.160147.1731660099441103969.davem@davemloft.net>
In-Reply-To: <20120217.160147.1731660099441103969.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201202172235.43337.danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329514602;83e2e5b5;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Freitag, 17. Februar 2012, David Miller wrote:
> From: Danny Kukawka <danny.kukawka@bisect.de>
> Date: Fri, 17 Feb 2012 16:43:28 +0100
>
> > Use dev_hw_addr_random() instead of calling random_ether_addr()
> > to set addr_assign_type correctly to NET_ADDR_RANDOM.
> >
> > Couldn't replace random_ether_addr() in enic_probe() since
> > enic_set_mac_addr() is used which would reset addr_assign_type.
> > Instead set addr_assign_type directly to NET_ADDR_RANDOM in
> > case of random mac after call enic_set_mac_addr().
> >
> > Reset the state to NET_ADDR_PERM as soon as the MAC get
> > changed via .ndo_set_mac_address.
> >
> > v2: use bitops, adapt to eth_hw_addr_random(), add a comment
> >
> > Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
>
> This patch doesn't apply at all to the current net-next tree,
> please always validate that your patches actually apply to the
> tree before submission.

Okay ... forgot that ... I'll check and send a new version.

Danny
