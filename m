Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab1ERVQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 17:16:13 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:50894 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634Ab1ERVQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 17:16:11 -0400
Date: Wed, 18 May 2011 17:16:03 -0400 (EDT)
Message-Id: <20110518.171603.2048423328863525352.davem@davemloft.net>
To: decot@google.com
Cc: joe@perches.com, szymon@janc.net.pl, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-net-upstream@google.com,
        snanda@google.com
Subject: Re: [PATCH 2/2] forcedeth: allow to silence tx_timeout debug
 messages
From: David Miller <davem@davemloft.net>
In-Reply-To: <1305753000-14933-2-git-send-email-decot@google.com>
References: <1305753000-14933-1-git-send-email-decot@google.com>
	<1305753000-14933-2-git-send-email-decot@google.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 18 May 2011 14:16:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Decotigny <decot@google.com>
Date: Wed, 18 May 2011 14:10:00 -0700

> From: Sameer Nanda <snanda@google.com>
> 
> This change allows to silence most debug messages in case of TX
> timeout. These messages don't provide a signare/noise ratio high
> enough for production systems and, with ~30kB logged each time, they
> tend to add to a cascade effect if the system is already under stress
> (memory pressure, disk, etc.).
> 
> By default, the debug messages are not displayed but this can be
> overriden by setting the debug_tx_timeout module parameter.
> 
> 
> Signed-off-by: David Decotigny <decot@google.com>

I would rather you make the messages less verbose, instead of
having it say absolutely nothing when this happens as it is
a serious problem.

You can add a knob which when enabled gives the old verbosity
back for diagnostic purposes.
