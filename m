Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab1DUP6j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 11:58:39 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41961 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab1DUP6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 11:58:36 -0400
Date: Thu, 21 Apr 2011 17:58:32 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>,
        jmorris@namei.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SMACK: Add missing rcu_read_lock/unlock for process capability walk.
Message-ID: <20110421155832.GU16484@one.firstfloor.org>
References: <1303336844-31074-1-git-send-email-andi@firstfloor.org> <4DAF637D.90606@schaufler-ca.com> <20110420231859.GB32402@tassilo.jf.intel.com> <4DAF6FA5.7080801@schaufler-ca.com> <20110421000818.GT16484@one.firstfloor.org> <4DAF7EAC.8010504@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DAF7EAC.8010504@schaufler-ca.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 20, 2011 at 05:47:40PM -0700, Casey Schaufler wrote:
> On 4/20/2011 5:08 PM, Andi Kleen wrote:
> >> The global list, yes. The task specific list, no. Modifying the local
> >> list is like any other modification of the cred structure and requires
> >> the cred be copied.
> > But you still need to free it eventually right? And that freeing will
> > need RCU on the reader.
> 
> Entries are never freed from the global list. Someone is working
> on a patch to do that, but is running into - wait for it - locking
> issues.

Then why do you use rcu_read_lock() at all? 

You can drop all the rcu_read_lock()s and probably the other *_rcu 
list accesses then. And my patch is indeed not needed. 

> Entries on the local lists are only freed when the task exits.

You mean the last user of the cred?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
