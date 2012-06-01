Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964973Ab2FAPt1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 11:49:27 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45091 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604Ab2FAPt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 11:49:26 -0400
Subject: Re: seq_file: Use larger buffer to reduce time traversing lists
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
        Al Viro <viro@zeniv.linux.org.uk>, nstraz@redhat.com
In-Reply-To: <1338564500.2708.73.camel@menhir>
References: <1338547193.2708.16.camel@menhir>
	 <1338552626.2760.1510.camel@edumazet-glaptop>
	 <1338553486.2708.25.camel@menhir>
	 <1338554890.2760.1517.camel@edumazet-glaptop>
	 <1338556468.2708.41.camel@menhir>
	 <1338557229.2760.1520.camel@edumazet-glaptop>
	 <1338560283.2708.59.camel@menhir>
	 <1338562627.2760.1526.camel@edumazet-glaptop>
	 <1338564500.2708.73.camel@menhir>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Jun 2012 17:47:45 +0200
Message-ID: <1338565665.2760.1537.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-01 at 16:28 +0100, Steven Whitehouse wrote:

> I'll certainly have a look at the hash table based approach too.

This is the reasonable approach, because most seq_file users do :

cat /path | ...

FILE *F = fopen("/path", "r");

ie they use small read size (<= 32 KB)

NOWARN can still slow down the whole machine.

You apparently don't have machines with fragmented memory...

hint : __GFP_NORETRY & PAGE_ALLOC_COSTLY_ORDER







