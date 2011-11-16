Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932705Ab1KPAOI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 19:14:08 -0500
Received: from fieldses.org ([174.143.236.118]:57554 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757629Ab1KPAOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 19:14:06 -0500
Date: Tue, 15 Nov 2011 19:14:04 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the nfsd tree
Message-ID: <20111116001404.GD12453@fieldses.org>
References: <20111116102952.d653d19f69ca5a7fad8a0291@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111116102952.d653d19f69ca5a7fad8a0291@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 16, 2011 at 10:29:52AM +1100, Stephen Rothwell wrote:
> Hi Bruce,
> 
> After merging the nfsd tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> fs/nfsd/nfs4state.c:4446:5: error: expected ';', ',' or ')' before 'void'
> fs/nfsd/nfs4state.c: In function 'nfsd_forget_locks':
> fs/nfsd/nfs4state.c:4468:2: error: implicit declaration of function 'nfsd_release_n_owners' [-Werror=implicit-function-declaration]
> 
> Caused by commit 16bfdaafa2c6 ("nfsd4: share open and lock owner hash
> tables").  Please build test *before* releasing code ...  :-(

I do--so what happened?

Aie, sorry, I see: we added a CONFIG_NFSD_FAULT_INJECTION recently, but
I didn't add that to my configs....

OK, I've fixed up my test scripts, and I'll push out a fix soon.

--b.

> 
> I have used the nfsd tree from next-20111115 for today.
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/

