Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab1DUAIY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 20:08:24 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53127 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab1DUAIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 20:08:22 -0400
Date: Thu, 21 Apr 2011 02:08:18 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Andi Kleen <ak@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
        jmorris@namei.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SMACK: Add missing rcu_read_lock/unlock for process capability walk.
Message-ID: <20110421000818.GT16484@one.firstfloor.org>
References: <1303336844-31074-1-git-send-email-andi@firstfloor.org> <4DAF637D.90606@schaufler-ca.com> <20110420231859.GB32402@tassilo.jf.intel.com> <4DAF6FA5.7080801@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DAF6FA5.7080801@schaufler-ca.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The global list, yes. The task specific list, no. Modifying the local
> list is like any other modification of the cred structure and requires
> the cred be copied.

But you still need to free it eventually right? And that freeing will
need RCU on the reader.

> 
> Moving the lock into smk_access_entry() would introduce a potential
> deadlock in smack_mmap_file. There is a bit of convolution in the
> mmap hook that requires looking at the list in a way that does not
> allow the locking to be embedded where it used to be.

rcu_read_lock() is just a per task counter and nests fine and never deadlocks.

-Andi
