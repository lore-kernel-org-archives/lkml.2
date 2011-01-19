Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab1ASJ7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 04:59:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43058 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753644Ab1ASJ7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 04:59:44 -0500
Date: Wed, 19 Jan 2011 10:59:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        James Bottomley <James.Bottomley@suse.de>,
        Randy Dunlap <randy.dunlap@oracle.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: netconsole build breakage (Re: [GIT] Networking)
Message-ID: <20110119095920.GA10543@elte.hu>
References: <20110114.130323.201674039.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110114.130323.201674039.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


FYI, there's a .38-rc1 build failure that triggers rather often:

 drivers/built-in.o: In function `drop_netconsole_target':
 netconsole.c:(.text+0x130146): undefined reference to `config_item_put'
 drivers/built-in.o: In function `write_msg':
 netconsole.c:(.text+0x1301aa): undefined reference to `config_item_get'
 netconsole.c:(.text+0x130217): undefined reference to `config_item_put'
 drivers/built-in.o: In function `netconsole_netdev_event':
 netconsole.c:(.text+0x1302ab): undefined reference to `config_item_get'
 ...

Triggered by this configuration:

 CONFIG_CONFIGFS_FS=m
 CONFIG_NETCONSOLE=y

Probably caused by:

 d9f9ab51e55e: net: Make NETCONSOLE_DYNAMIC depend on CONFIGFS_FS

The commit appears to have gone upstream via the iscsi tree. The commit is going in 
the wrong direction as well, beyond being buggy.

The original problem was caused by this iscsi commit:

 e205117285d6: configfs: change depends -> select SYSFS

and the dependency problems snowballed from there, and one side-effect was patched 
up - but others remain.

Thanks,

	Ingo
