Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266Ab2DVTXe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 15:23:34 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:49911 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab2DVTXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 15:23:33 -0400
Date: Sun, 22 Apr 2012 15:22:10 -0400 (EDT)
Message-Id: <20120422.152210.1520263792125579554.davem@davemloft.net>
To: sam@ravnborg.org
Cc: yinghai@kernel.org, tj@kernel.org, mhocko@suse.cz, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: Weirdness in __alloc_bootmem_node_high
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120420194309.GA3689@merkur.ravnborg.org>
References: <20120420191418.GA3569@merkur.ravnborg.org>
	<CAE9FiQU-M0yW_rwysq56zrZzift=PxgwioMmx8bMcJ5o20m2TQ@mail.gmail.com>
	<20120420194309.GA3689@merkur.ravnborg.org>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 22 Apr 2012 12:22:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>
Date: Fri, 20 Apr 2012 21:43:09 +0200

> I have it almost finished - except that it does not work :-(
> We have limitations in what area we can allocate very early,
> and here I had to use the alloc_bootmem_low() variant.
> I had preferred a variant that allowed me to allocate
> bottom-up in this case.

I think you're going to have to bear down and map all of linear kernel
mappings before you start using the bootmem code rather than
afterwards.
