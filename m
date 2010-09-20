Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab0ITPvH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 11:51:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50699 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756363Ab0ITPvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 11:51:05 -0400
Date: Mon, 20 Sep 2010 17:50:15 +0200
From: Jan Kara <jack@suse.cz>
To: "Alexander E. Patrakov" <patrakov@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] BKL: Remove BKL from isofs
Message-ID: <20100920155014.GH3390@quack.suse.cz>
References: <201009161632.59210.arnd@arndb.de>
 <201009172100.06598.arnd@arndb.de>
 <20100920105811.GC3390@quack.suse.cz>
 <201009201313.11526.arnd@arndb.de>
 <20100920151834.GF3390@quack.suse.cz>
 <4C978087.7060802@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C978087.7060802@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 20-09-10 21:40:55, Alexander E. Patrakov wrote:
> [I know nothing about linux filesystem code, please disregard this
> mail if it is stupid]
> 
> 20.09.2010 21:18, Jan Kara wrote:
> 
> >BKL isn't needed for isofs at all so we can just remove it. Generally, since
> >isofs is always mounted read-only, filesystem structure cannot change under us.
> 
> Does your statement also cover the case of read errors on scratched
> CD-ROMs (i.e., the driver has successfully read a sector with a
> directory once after a lot of strugging, and failed the next time),
> or ejects of mounted media?
  Well, BKL definitely won't help in protecting races triggered by such
problems. Also if we fail to read some data, we just bail out with
error so data appearing later do not bother us. Similarly once we get hold
of some buffer with data, it cannot disappear under us while we hold a
reference to it so again we are safe... I don't think these case pose any
problem.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
