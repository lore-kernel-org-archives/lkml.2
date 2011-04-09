Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab1DIRMU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 13:12:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:56885 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab1DIRMS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 13:12:18 -0400
Subject: Re: Q. locking order of dcache_lru_lock
From: Peter Zijlstra <peterz@infradead.org>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
        Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
In-Reply-To: <9769.1302268831@jrobl>
References: <9769.1302268831@jrobl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 09 Apr 2011 19:12:13 +0200
Message-ID: <1302369133.2388.1.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-08 at 22:20 +0900, J. R. Okajima wrote:
> 
> When spin_trylock(&dentry->d_lock) successfully acquired d_lock, does
> the violation of locking order happen (or a deadlock, in worse case)? 

No, since a trylock never actually blocks a deadlock cannot occur.
