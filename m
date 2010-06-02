Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819Ab0FBB4y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 21:56:54 -0400
Received: from tundra.namei.org ([65.99.196.166]:33444 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754789Ab0FBB4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 21:56:52 -0400
Date: Wed, 2 Jun 2010 11:56:36 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Dan Carpenter <error27@gmail.com>
cc: Casey Schaufler <casey@schaufler-ca.com>,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>,
       David Howells <dhowells@redhat.com>, Serge Hallyn <serue@us.ibm.com>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [patch] smack: opt_dentry is never null in in
 smack_d_instantiate()
In-Reply-To: <20100601071404.GH5483@bicker>
Message-ID: <alpine.LRH.2.00.1006021156230.12305@tundra.namei.org>
References: <20100601071404.GH5483@bicker>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jun 2010, Dan Carpenter wrote:

> This patch removes some unneeded code for if opt_dentry is null because
> that can never happen.
> 
> The function dereferences "opt_dentry" earlier when it checks 
> "if (opt_dentry->d_parent == opt_dentry) {".  That code was added in
> 2008.
> 
> This function called from security_d_instantiate().  I checked all the 
> places which call security_d_instantiate() and dentry is always non-null.
> I also checked the selinux version of this hook and there is a comment
> which says that dentry should be non-null if called from 
> d_instantiate().
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>


Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

-- 
James Morris
<jmorris@namei.org>
