Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965481Ab1JGQYw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 12:24:52 -0400
Received: from mail.vyatta.com ([76.74.103.46]:46612 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760121Ab1JGQYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 12:24:49 -0400
Date: Fri, 7 Oct 2011 09:24:45 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Mihai Maruseac <mihai.maruseac@gmail.com>
Cc: davem@davemloft.net, eric.dumazet@gmail.com, mirq-linux@rere.qmqm.pl,
        therbert@google.com, jpirko@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dbaluta@ixiacom.com,
        Mihai Maruseac <mmaruseac@ixiacom.com>
Subject: Re: [PATCH] dev: use name hash for dev_seq_ops.
Message-ID: <20111007092445.4f097ed9@nehalam.linuxnetplumber.net>
In-Reply-To: <1318000849-2531-1-git-send-email-mmaruseac@ixiacom.com>
References: <1318000849-2531-1-git-send-email-mmaruseac@ixiacom.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  7 Oct 2011 18:20:49 +0300
Mihai Maruseac <mihai.maruseac@gmail.com> wrote:

> Instead of using the dev->next chain and trying to resync at each call to
> dev_seq_start, use this hash and store bucket number and bucket offset in
> seq->private field.
> 
> Tests revealed the following results for ifconfig > /dev/null
> 	* 1000 interfaces:
> 		* 0.114s without patch
> 		* 0.020s with patch
> 	* 3000 interfaces:
> 		* 0.489s without patch
> 		* 0.048s with patch
> 	* 5000 interfaces:
> 		* 1.363s without patch
> 		* 0.131s with patch
> 
> As one can notice the improvement is of 1 order of magnitude.

Good idea,
This will change the ordering of entries in /proc which may upset
some program, not a critical flaw but worth noting.

Rather than recording the bucket and offset of last entry, another
alternative would be to just record the ifindex.

Also ifconfig is considered deprecated and replaced by ip commands
for general use.
