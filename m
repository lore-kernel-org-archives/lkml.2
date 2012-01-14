Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab2ANRTA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 12:19:00 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:65327 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344Ab2ANRS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 12:18:58 -0500
Message-ID: <1326561533.5287.26.camel@edumazet-laptop>
Subject: Re: Hung task when calling clone() due to netfilter/slab
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Dave Jones <davej@redhat.com>, davem <davem@davemloft.net>,
        Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>, kaber@trash.net, pablo@netfilter.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, netfilter-devel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Date: Sat, 14 Jan 2012 18:18:53 +0100
In-Reply-To: <1326561043.5287.24.camel@edumazet-laptop>
References: <1326558605.19951.7.camel@lappy>
	 <1326561043.5287.24.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 14 janvier 2012 à 18:10 +0100, Eric Dumazet a écrit :

> Apparently SLUB calls sysfs_slab_add() from kmem_cache_create() while
> still holding slub_lock.
> 
> So if the task launched needs to "cat /proc/slabinfo" or anything
> needing slub_lock, its a deadlock.
> 
> 

Bug added in commit 2bce64858442149784f6c88
(slub: Allow removal of slab caches during boot)



