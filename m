Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab2CHB24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 20:28:56 -0500
Received: from mail.us.es ([193.147.175.20]:57555 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848Ab2CHB2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 20:28:53 -0500
Date: Thu, 8 Mar 2012 02:28:49 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Richard Weinberger <richard@nod.at>
Cc: jengelh@medozas.de, eric.dumazet@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        rostedt@goodmis.org
Subject: Re: [PATCH v6] Netfilter ring buffer support
Message-ID: <20120308012849.GA9164@1984>
References: <1330989588-26833-1-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330989588-26833-1-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2012 at 12:19:42AM +0100, Richard Weinberger wrote:
> This patch set merges ipt_LOG and ip6t_LOG and adds ring buffer support
> to xt_LOG.
> 
> Using "--ring" an user can create LOG rules which log messages into
> one or more ring buffers.
> Each ring buffer is represented as pipe-like file in
> /proc/net/netfilter/nf_log_ring/.

I've spent part of the evening testing this and checking its
possibilities, the drawbacks that I see for this contribution are:

* it uses the /proc entry, we have rejected similar add-ons in the
  past that have used these interfaces.
* one single reader can be reading at a time.

Having said that, I still think that the feature that this provides
is useful, but I think that implementing this in user-space over
nfnetlink_log results in a much more flexible solution.

I have made proof-of-concept daemon (it's a quick hack of several
hours) that implements the similar feature over nfnetlink_log,
advantages are:

* You don't need to upgrade your kernel / iptables.
* You only need to install libnfnetlink, libnetfilter_log and the
  daemon.
* It can be extended to support multiple readers.

So my conclusion is that you can make this in userspace in a much more
flexible way.

You can find it here:

http://1984.lsi.us.es/git/rlogd/

The initial commit provides some description on how to use it:

http://1984.lsi.us.es/git/rlogd/commit/?id=ccb88a8dc8ad674b860f2d3edabf07fe4830baf3

I don't plan to develop / maintain that software. The last thing I
want in my todo list is yet another thing to maintain. If someone is
interested, please, feel free to grab it, make a nice website for it
and maintain it.

The repository also contains an unfinished patch to add LOG format
support to libnetfilter_log.
