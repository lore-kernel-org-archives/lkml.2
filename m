Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292Ab0EMTMJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 15:12:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40020 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759389Ab0EMTMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 15:12:07 -0400
Date: Thu, 13 May 2010 12:11:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: miaox@cn.fujitsu.com
Cc: David Rientjes <rientjes@google.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Paul Menage <menage@google.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH -mm] cpuset,mm: fix no node to alloc memory when
 changing cpuset's mems - fix2
Message-Id: <20100513121123.e105ac97.akpm@linux-foundation.org>
In-Reply-To: <4BEB9941.7040609@cn.fujitsu.com>
References: <4BEA56D3.6040705@cn.fujitsu.com>
	<20100512003246.9f0ee03c.akpm@linux-foundation.org>
	<4BEA6E3D.10503@cn.fujitsu.com>
	<20100512104817.beeee3b5.akpm@linux-foundation.org>
	<4BEB9941.7040609@cn.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 May 2010 14:16:33 +0800
Miao Xie <miaox@cn.fujitsu.com> wrote:

> > 
> > The code you have at present is fairly similar to sequence locks.  I
> > wonder if there's some way of (ab)using sequence locks for this. 
> > seqlocks don't have lockdep support either...
> > 
> 
> We can't use sequence locks here, because the read-side may read the data
> in changing, but it can't put off cleaning the old bits.

I don't understand that sentence.  Can you expand on it please?
