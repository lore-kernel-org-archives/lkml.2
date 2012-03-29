Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778Ab2C2IW3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 04:22:29 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42205 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab2C2IWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 04:22:21 -0400
MIME-Version: 1.0
In-Reply-To: <1332965525.2325.13.camel@edumazet-glaptop>
References: <1332882712-10756-1-git-send-email-alex.mihai.c@gmail.com>
	<20120328105212.1cb8dfe5@asterix.rh>
	<1332946113.2325.9.camel@edumazet-glaptop>
	<CAEnQRZD+0AQFfFCzWZCR5JR0BUxxNEsincD+_O9F0ne2Zryp_w@mail.gmail.com>
	<1332965525.2325.13.camel@edumazet-glaptop>
Date: Thu, 29 Mar 2012 11:22:21 +0300
Message-ID: <CAHG7+CDeve6WoQB4+q4LwaJVy_gLHbfsDpAt+8rqhw0VUeBA8w@mail.gmail.com>
Subject: Re: [PATCH] tcp: bind() use stronger condition for bind_conflict
From: Alexandru Copot <alex.mihai.c@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Daniel Baluta <dbaluta@ixiacom.com>, Flavio Leitner <fbl@redhat.com>,
        davem@davemloft.net, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 11:12 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:

> Some performance data would be welcomed, in the case many sockets are
> already bound...


I've done some tests running a program that creates and binds(0) 90000 sockets.
The total running time, on average, is:
*  without this patch: 0.352 s
*  with the patch:       0.355 s

Also, recording this program with perf shows a small increase of 0.6%
for inet_csk_get_port
relative to inet_bind, after applying the patch.

So the performance is almost the same, even for such a large number of sockets.

Alex Copot
