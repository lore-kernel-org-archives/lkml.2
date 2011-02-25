Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315Ab1BYSqq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 13:46:46 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45846
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756184Ab1BYSqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 13:46:44 -0500
Date: Fri, 25 Feb 2011 10:47:20 -0800 (PST)
Message-Id: <20110225.104720.71110261.davem@davemloft.net>
To: segoon@openwall.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru,
        pekkas@netcore.fi, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, eric.dumazet@gmail.com, therbert@google.com,
        xiaosuo@gmail.com, jesse@nicira.com
Subject: Re: [PATCH] don't allow CAP_NET_ADMIN to load non-netdev kernel
 modules
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110225151414.GA5211@albatros>
References: <1298565265.2613.16.camel@bwh-desktop>
	<20110225123023.GA8776@albatros>
	<20110225151414.GA5211@albatros>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasiliy Kulikov <segoon@openwall.com>
Date: Fri, 25 Feb 2011 18:14:14 +0300

> Since a8f80e8ff94ecba629542d9b4b5f5a8ee3eb565c any process with
> CAP_NET_ADMIN may load any module from /lib/modules/.  This doesn't mean
> that CAP_NET_ADMIN is a superset of CAP_SYS_MODULE as modules are limited
> to /lib/modules/**.  However, CAP_NET_ADMIN capability shouldn't allow
> anybody load any module not related to networking.

Why go through this naming change, which does break things, instead of
simply adding a capability mask tag or similar to modules somehow.  You
could stick it into a special elf section or similar.

Doesn't that make tons more sense than this?
