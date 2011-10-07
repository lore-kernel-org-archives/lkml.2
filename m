Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab1JGX7y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 19:59:54 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:27653 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963Ab1JGX7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 19:59:52 -0400
Date: Sat, 8 Oct 2011 02:56:45 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mark Einon <mark.einon@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linville@tuxdriver.com,
        davem@davemloft.net
Subject: Re: et131x: Moving the et131x driver out of staging? (a.k.a. filling
 up the TODO list again)
Message-ID: <20111007235644.GK18470@longonot.mountain>
References: <CANK3SE398D+DiXLWDystz_jSpD4WJaLqt9gCmVstr+8TginDRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANK3SE398D+DiXLWDystz_jSpD4WJaLqt9gCmVstr+8TginDRw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4E8F9267.000D:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are some trivial static checker things that could be cleaned
up.

drivers/staging/et131x/et131x_initpci.c +489 et131x_adjust_link(45) error: we previously assumed 'phydev' could be null (see line 475)
drivers/staging/et131x/et131x_initpci.c +505 et131x_adjust_link(61) warn: variable dereferenced before check 'phydev' (see line 498)

(probably the null check should be removed?)

drivers/staging/et131x/et1310_mac.c:376:44: warning: incorrect type in initializer (different address spaces)
drivers/staging/et131x/et1310_mac.c:376:44:    expected struct txmac_regs *txmac
drivers/staging/et131x/et1310_mac.c:376:44:    got struct txmac_regs [noderef] <asn:2>*<noident>
drivers/staging/et131x/et1310_mac.c:383:28: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/et131x/et1310_mac.c:383:28:    expected void volatile [noderef] <asn:2>*addr
drivers/staging/et131x/et1310_mac.c:383:28:    got unsigned int *<noident>
drivers/staging/et131x/et1310_mac.c:385:31: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/et131x/et1310_mac.c:385:31:    expected void volatile [noderef] <asn:2>*addr
drivers/staging/et131x/et1310_mac.c:385:31:    got unsigned int *<noident>

(it just needs an __iomem anotation).

drivers/staging/et131x/et131x_initpci.c:556:5: warning: symbol 'et131x_mii_probe' was not declared. Should it be static?
drivers/staging/et131x/et131x_netdev.c:246:5: warning: symbol 'et131x_ioctl' was not declared. Should it be static?
drivers/staging/et131x/et131x_netdev.c:264:5: warning: symbol 'et131x_set_packet_filter' was not declared. Should it be static?
drivers/staging/et131x/et131x_netdev.c:326:6: warning: symbol 'et131x_multicast' was not declared. Should it be static?
drivers/staging/et131x/et131x_netdev.c:399:5: warning: symbol 'et131x_tx' was not declared. Should it be static?
drivers/staging/et131x/et131x_netdev.c:432:6: warning: symbol 'et131x_tx_timeout' was not declared. Should it be static?
drivers/staging/et131x/et131x_netdev.c:490:5: warning: symbol 'et131x_change_mtu' was not declared. Should it be static?
drivers/staging/et131x/et131x_netdev.c:543:5: warning: symbol 'et131x_set_mac_addr' was not declared. Should it be static?

regards,
dan carpenter
