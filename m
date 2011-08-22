Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab1HVVvG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 17:51:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37906 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753963Ab1HVVvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 17:51:02 -0400
Date: Mon, 22 Aug 2011 14:50:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Joern Engel <joern@logfs.org>, logfs@logfs.org,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-arch@vger.kernel.org
Subject: Re: [PATCH 3/4] string: introduce memchr_inv
Message-Id: <20110822145050.e3471fa0.akpm@linux-foundation.org>
In-Reply-To: <20110822135218.f2d9f462.akpm@linux-foundation.org>
References: <1314030548-21082-1-git-send-email-akinobu.mita@gmail.com>
	<1314030548-21082-4-git-send-email-akinobu.mita@gmail.com>
	<20110822135218.f2d9f462.akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Aug 2011 13:52:18 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> > +	value64 = value | value << 8 | value << 16 | value << 24;
> > +	value64 = (value64 & 0xffffffff) | value64 << 32;
> > +	prefix = 8 - ((unsigned long)start) % 8;
> > +
> > +	if (prefix) {
> > +		u8 *r = check_bytes8(start, value, prefix);
> > +		if (r)
> > +			return r;
> > +		start += prefix;
> > +		bytes -= prefix;
> > +	}
> > +
> > +	words = bytes / 8;
> > +
> > +	while (words) {
> > +		if (*(u64 *)start != value64)
> 
> OK, problem.  This will explode if passed a misaligned address on
> certain (non-x86) architectures.

pls ignore.  As Marcin points out, I can't read.
