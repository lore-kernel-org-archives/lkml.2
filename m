Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab2CCWl6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 17:41:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55704 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057Ab2CCWl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 17:41:57 -0500
Date: Sat, 3 Mar 2012 23:41:51 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: Rajiv Andrade <srajiv@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        tpmdd-devel@lists.sourceforge.net
Subject: Re: [PATCH] tpm_tis: fix tis_lock with respect to RCU
In-Reply-To: <4F4E529B.2010905@linux.vnet.ibm.com>
Message-ID: <alpine.LNX.2.00.1203032340452.23367@pobox.suse.cz>
References: <alpine.LNX.2.00.1202291026520.31150@pobox.suse.cz> <4F4E529B.2010905@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Feb 2012, Stefan Berger wrote:

> > cleanup_tis() ->  tpm_remove_hardware() ->  syncrhonize_rcu() is being
> > called in an atomic context (tis_lock spinlock held), which is not
> > allowed. Convert tis_lock to mutex.
> > 
> > Signed-off-by: Jiri Kosina<jkosina@suse.cz>
> Tested-by: Stefan Berger <stefanb@linux.vnet.ibm.com>

Thanks. Doesn't seem to have been picked up for -next yet. Which tree is 
this going through?

As a last resort, I can take it through trivial, but I guess for example 
Andrew's tree would be better.

-- 
Jiri Kosina
SUSE Labs
