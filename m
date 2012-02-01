Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947Ab2BAFys (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 00:54:48 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:52742 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab2BAFyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 00:54:47 -0500
Message-ID: <1328075682.2617.48.camel@edumazet-laptop>
Subject: Re: [PATCH] speed up /proc/pid/stat, statm
From: Eric Dumazet <eric.dumazet@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 01 Feb 2012 06:54:42 +0100
In-Reply-To: <20120201085546.ecbf628d.kamezawa.hiroyu@jp.fujitsu.com>
References: <20120131171443.567b53ad.kamezawa.hiroyu@jp.fujitsu.com>
	 <20120131123612.6b60bdfc.akpm@linux-foundation.org>
	 <20120201085546.ecbf628d.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 01 février 2012 à 08:55 +0900, KAMEZAWA Hiroyuki a écrit :

> seq_xxxx functions set m->count == m->size when it finds possible buffer overflow.
> If m->count == m->size after ->show(), buffer will be freed and twice size buffer
> will be re-allocated, and retry.
> 
> If we don't set m->count == m->size here, following seq_putc() will succeed and
> we'll see corrupted outputs.

I suppose we could define a self documented helper

void seq_overflow(struct seq_file *seq)
{
	seq->count = seq->size;
}

Or if we were counting the approximate number of missing bytes, we could
avoid some iterations of the "double size buffer".

(letting seq->count going above seq->size, but not allowing buffer
overflow of course !)



