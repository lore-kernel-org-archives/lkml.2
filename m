Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab2CLJhL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 05:37:11 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:45411 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755054Ab2CLJhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 05:37:08 -0400
Date: Mon, 12 Mar 2012 02:36:59 -0700 (PDT)
Message-Id: <20120312.023659.22154618235290541.davem@davemloft.net>
To: santoshprasadnayak@gmail.com
Cc: sony.chacko@qlogic.com, rajesh.borundia@qlogic.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/3 v2] netxen: qlogic ethernet : Fix endian bug.
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAOD=uF4qUhKRpWerFkouqNgzTNRL7DRu3G0kxgTb2E31Ox-=aA@mail.gmail.com>
References: <20120311.234808.1919218898572322534.davem@davemloft.net>
	<CAOD=uF6=2b-s_ErZ8zB+Mmo=gzE8wJdQ+h=TPz7U-sc1ucyw=Q@mail.gmail.com>
	<CAOD=uF4qUhKRpWerFkouqNgzTNRL7DRu3G0kxgTb2E31Ox-=aA@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 12 Mar 2012 02:37:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: santosh prasad nayak <santoshprasadnayak@gmail.com>
Date: Mon, 12 Mar 2012 14:45:38 +0530

> Subject: [PATCH 3/3 v2] netxen: qlogic ethernet : Fix endian bug.
> 
> Change the datatype of "ip_addr" to __be32 as 'ip' should be in
> big endian format.
> 
> Adapter needs "ip address" in big endian format stored at lower 32bit
> of req.word[1]. netxen_config_ipaddr() now receives 'ip' in big endian
> format. To satisfy adapter's need, use memcpy() to copy byte by byte
> of 'ip' into lower 32bit of req.word[1].
> 
> Mac address and serial number of adapter need to be in little endian format.
> Change the data type of the related  variables to __le32 / __le64 or cast it
> explicitly to __le32 / __le64 depending upon the requirement.

This looks a lot better.
