Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758908Ab2JKQnW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 12:43:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18482 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758614Ab2JKQnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 12:43:21 -0400
Date: Thu, 11 Oct 2012 09:43:12 -0700
From: Zach Brown <zab@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tytso@mit.edu
Subject: Re: [PATCH 5/5] aio: Refactor aio_read_evt, use cmxchg(), fix bug
Message-ID: <20121011164312.GD8768@lenny.home.zabbo.net>
References: <20121009183753.GP26187@lenny.home.zabbo.net>
 <20121009212724.GD29494@google.com>
 <20121009224703.GT26187@lenny.home.zabbo.net>
 <20121009225509.GA26835@google.com>
 <20121009231059.GV26187@lenny.home.zabbo.net>
 <20121010000600.GB26835@google.com>
 <20121010002634.GX26187@lenny.home.zabbo.net>
 <20121010004746.GF26835@google.com>
 <20121010214315.GE6371@lenny.home.zabbo.net>
 <20121011025102.GE24174@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121011025102.GE24174@moria.home.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yeah, but that means the completion has to be delivered from process
> context. That's not what aio does today, and it'd be a real performance
> regression.

It'd only have to to complete from process context if it faults. The
cheapest possible delivery mechanism is simple cpu stores.  In the vast
majority of cases the ring will be resident and it'll be done.  In rare
cases it could fall back to a deferred completion.  If apps can't
stomach that latency and want to pay the overhead of pinning to remove
that risk, they're welcome to do so.

That's my hope, anyway.

- z
