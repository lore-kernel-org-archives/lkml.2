Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780Ab0IWCes (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 22:34:48 -0400
Received: from fieldses.org ([174.143.236.118]:56417 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015Ab0IWCer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 22:34:47 -0400
Date: Wed, 22 Sep 2010 22:33:15 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        NeilBrown <neilb@suse.de>
Subject: Re: linux-next: build failure after merge of the nfsd tree
Message-ID: <20100923023315.GA10764@fieldses.org>
References: <20100923113429.88f865d2.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100923113429.88f865d2.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 11:34:29AM +1000, Stephen Rothwell wrote:
> Hi Bruce,
> 
> After merging the nfsd tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> ERROR: ".get_task_comm" [fs/nfsd/nfsd.ko] undefined!
> 
> Caused by commit c67874f942e30039442d925b03793e0a46ddcddd ("nfsd:
> formally deprecate legacy nfsd syscall interface").
> 
> get_task_comm is not exported to modules.
> 
> I have used the version of the nfsd tree from next-20100921 for today.

Oops, thanks.

It looks like a lot of places just do a

	printk("%s using deprecated interface ...", current->comm);

so maybe we can get away with just that?

--b.
