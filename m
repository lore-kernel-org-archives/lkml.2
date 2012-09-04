Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545Ab2IDQii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 12:38:38 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:59510 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757135Ab2IDQif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 12:38:35 -0400
Date: Tue, 04 Sep 2012 12:38:33 -0400 (EDT)
Message-Id: <20120904.123833.1657238734473790349.davem@davemloft.net>
To: danborkmann@iogearbox.net
Cc: iulius.curt@gmail.com, edumazet@google.com, xemul@parallels.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dbaluta@ixiacom.com, icurt@ixiacom.com, sdumitru@ixiacom.com
Subject: Re: [RFC] packet: change call of synchronize_net to call_rcu
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAD6jFUSa7gD45m7WdtDymJq-WkGq+kbofkws5n3dGMtuDE6d3A@mail.gmail.com>
References: <1346768215-5194-1-git-send-email-icurt@ixiacom.com>
	<CAD6jFUSa7gD45m7WdtDymJq-WkGq+kbofkws5n3dGMtuDE6d3A@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Borkmann <danborkmann@iogearbox.net>
Date: Tue, 4 Sep 2012 16:53:06 +0200

> On Tue, Sep 4, 2012 at 4:16 PM, Iulius Curt <iulius.curt@gmail.com> wrote:
>> synchronize_net is called every time we close a PF_PACKET socket which is
>> causing performance loss when doing this on many sockets.
> 
> Do you have any particular use case in mind?

I'm curious about this too, it seems rediculous to optimize for this
and that only seriously mis-designed userspace would do something like
this.

