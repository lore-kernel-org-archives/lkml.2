Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526Ab1I2Tfu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 15:35:50 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:43145 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812Ab1I2Tfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 15:35:48 -0400
Date: Thu, 29 Sep 2011 15:32:59 -0400 (EDT)
Message-Id: <20110929.153259.169108824599752228.davem@davemloft.net>
To: muralira@google.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net-proc: expose the tos values in /proc/net/[tcp|udp]
From: David Miller <davem@davemloft.net>
In-Reply-To: <1317324162-21621-1-git-send-email-muralira@google.com>
References: <1317324162-21621-1-git-send-email-muralira@google.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 29 Sep 2011 12:33:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Muraliraja Muniraju <muralira@google.com>
Date: Thu, 29 Sep 2011 12:22:42 -0700

> From: Murali Raja <muralira@google.com>
> 
> This patch exports the tos values from the inet_sock struct
> for tcp and udp into the /proc/net/tcp or /proc/net/udp respectively.
> This will not pickup per packet tos changes but it will address most
> of the cases. This is mainly useful as it would decrease reliance on
> tcpdump and also people without root access will be able to read
> the values.
> 
> Signed-off-by: Murali Raja <muralira@google.com>

You cannot change the layout of these files, they are parsed by userland
problems and therefore have a fixed API.

Netlink based socket dumping provides a proper, backwards compatible,
way to extend what is reported, so please consider adding your changes
there.
