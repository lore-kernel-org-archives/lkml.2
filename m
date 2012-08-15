Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab2HOLlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 07:41:13 -0400
Received: from canardo.mork.no ([148.122.252.1]:34145 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920Ab2HOLlL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 07:41:11 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: David Miller <davem@davemloft.net>, <shchepetkov@ispras.ru>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ldv-project@ispras.ru>
Subject: Re: [PATCH 0/5] Call netif_carrier_off() after register_netdev()
Organization: m
References: <1344940135-17079-1-git-send-email-shchepetkov@ispras.ru>
	<20120814.140019.1016184364798213214.davem@davemloft.net>
	<1344984477.2690.85.camel@bwh-desktop.uk.solarflarecom.com>
Date: Wed, 15 Aug 2012 13:40:52 +0200
In-Reply-To: <1344984477.2690.85.camel@bwh-desktop.uk.solarflarecom.com> (Ben
	Hutchings's message of "Tue, 14 Aug 2012 23:47:57 +0100")
Message-ID: <87boicz8l7.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Hutchings <bhutchings@solarflare.com> writes:

> But if you do it beforehand then it doesn't have the intended effect.
> (Supposed to be fixed by 22604c866889c4b2e12b73cbf1683bda1b72a313, which
> had to be reverted: c276e098d3ee33059b4a1c747354226cec58487c.)
>
> So you have to do it after, but without dropping the RTNL lock in
> between.

So you may want to add something like

int register_netdev_carrier_off(struct net_device *dev)
{
	int err;

	rtnl_lock();
	err = register_netdevice(dev);
        if (!err)
                set_bit(__LINK_STATE_NOCARRIER, &dev->state)
	rtnl_unlock();
	return err;
}


for these drivers?



Bjørn
