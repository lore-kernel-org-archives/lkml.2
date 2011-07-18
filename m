Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab1GRUd1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 16:33:27 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:49362 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab1GRUcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 16:32:55 -0400
Date: Mon, 18 Jul 2011 23:32:49 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: rweikusat@mobileactivedefense.com, kaber@trash.net,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: add per-namespace logging to nfnetlink_log.c
Message-ID: <20110718203249.GC2489@p183.telecom.by>
References: <87hb6je5nh.fsf@sapphire.mobileactivedefense.com>
 <20110718.124638.30010338187296272.davem@davemloft.net>
 <87d3h7e43n.fsf@sapphire.mobileactivedefense.com>
 <20110718.131943.1892150276130348431.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110718.131943.1892150276130348431.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 01:19:43PM -0700, David Miller wrote:
> From: Rainer Weikusat <rweikusat@mobileactivedefense.com>
> Date: Mon, 18 Jul 2011 21:17:00 +0100
> 
> > David Miller <davem@davemloft.net> writes:
> >> We're also specifically talking about namespace stuff, so you should have
> >> at least refined your match criteria just a little bit.
> > 
> > The person I was replying to wrote 'We did whole networking without
> > sprinkling ifdefs'.
> 
> He was talking specifically about namespace stuff.

Indeed.

Rainer, while your desire to keep CONFIG_NET_NS=n case equivalent
to current code is understandable and kernel people share it at large,
what you're fighting for is maybe one dereference on speed-uncritical
code paths and one pointer in small amount of data structures.
As such having common executable code matters more.

netns will be stubbed to &init_net at several places.
See how e. g. xt_hashlimit is done.
