Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760046Ab2FAO5R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 10:57:17 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41240 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759104Ab2FAO5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 10:57:13 -0400
Subject: Re: seq_file: Use larger buffer to reduce time traversing lists
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
        Al Viro <viro@zeniv.linux.org.uk>, nstraz@redhat.com
In-Reply-To: <1338560283.2708.59.camel@menhir>
References: <1338547193.2708.16.camel@menhir>
	 <1338552626.2760.1510.camel@edumazet-glaptop>
	 <1338553486.2708.25.camel@menhir>
	 <1338554890.2760.1517.camel@edumazet-glaptop>
	 <1338556468.2708.41.camel@menhir>
	 <1338557229.2760.1520.camel@edumazet-glaptop>
	 <1338560283.2708.59.camel@menhir>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Jun 2012 16:57:07 +0200
Message-ID: <1338562627.2760.1526.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-01 at 15:18 +0100, Steven Whitehouse wrote:
> 	0m0.374s
> 
> So even with the current tcp scheme this appears to speed things up by
> nearly 3x. Also that was with only 28000 entries in the file,

Initial speedup was 100x, not 3x.

Of course using a 32KB buffer instead of 4KB will help.

And If someones need 100.000 active unix sockets and fast /proc/net/udp
file as well, patch is welcome. If I have time I can do it eventually.

Really, kmalloc(2 MB) is not going to happen, even using __GFP_NOWARN



