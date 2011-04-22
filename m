Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751013Ab1DVEet (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 00:34:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53024 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab1DVEes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 00:34:48 -0400
Date: Fri, 22 Apr 2011 00:34:44 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        npiggin@kernel.dk, shaohua.li@intel.com, sds@tycho.nsa.gov,
        jmorris@namei.org, linux-security-module@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/3] SECURITY: Move exec_permission RCU checks into
 security modules
Message-ID: <20110422043444.GA9038@infradead.org>
References: <1303431801-10540-1-git-send-email-andi@firstfloor.org>
 <1303431801-10540-2-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303431801-10540-2-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 05:23:19PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Right now all RCU walks fall back to reference walk when CONFIG_SECURITY
> is enabled, even though just the standard capability module is active.
> This is because security_inode_exec_permission unconditionally fails
> RCU walks.
> 
> Move this decision to the low level security module. This requires
> passing the RCU flags down the security hook. This way at least
> the capability module and a few easy cases in selinux/smack work
> with RCU walks with CONFIG_SECURITY=y
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  include/linux/security.h   |    2 +-
>  security/capability.c      |    2 +-
>  security/security.c        |    6 ++----
>  security/selinux/hooks.c   |    6 +++++-
>  security/smack/smack_lsm.c |    6 +++++-
>  5 files changed, 14 insertions(+), 8 deletions(-)

This seems to miss the hunk in fs/namei.c where the LSM hook is called.

