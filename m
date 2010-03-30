Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045Ab0C3REl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 13:04:41 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:56307 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546Ab0C3REj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 13:04:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UBeKPNtwgewJz5hVZWhUK58slN2z+Nr8PfyNmReFfYkAQXdalX/EHRQQVQtoqS1NoB
         lsP9shBKUmkzdkApHP/LTRGFmagbpOVm/mqnkwnYgyRI4chyPq5CkstWA4imEw+GjwPy
         COmysAfrXfQ74bZp+gLWQnWZpCxc8GjhnDtV0=
Subject: Re: [PATCH] NFS: Fix RCU warnings in
 nfs_inode_return_delegation_noreclaim() [ver #2]
From: Eric Dumazet <eric.dumazet@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: David Howells <dhowells@redhat.com>, Trond.Myklebust@netapp.com,
       linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100330164912.GG2513@linux.vnet.ibm.com>
References: <20100329210520.GN2569@linux.vnet.ibm.com>
	 <20100329192159.GM2569@linux.vnet.ibm.com>
	 <20100319022527.GC2894@linux.vnet.ibm.com>
	 <20100318133302.29754.1584.stgit@warthog.procyon.org.uk>
	 <19192.1269889348@redhat.com> <23274.1269893706@redhat.com>
	 <25276.1269901350@redhat.com> <26760.1269903543@redhat.com>
	 <20100329232636.GT2569@linux.vnet.ibm.com> <2440.1269967151@redhat.com>
	 <20100330164912.GG2513@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Mar 2010 19:04:31 +0200
Message-ID: <1269968671.10116.17.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 30 mars 2010 à 09:49 -0700, Paul E. McKenney a écrit :
> On Tue, Mar 30, 2010 at 05:39:11PM +0100, David Howells wrote:
> > Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > > Scrap this one -- Arnd has it covered, under the much better name
> > > of rcu_dereference_const().
> > 
> > Not convinced of that name either.  That sounds like the RCU dereference of
> > constant (R/O) data.
> 
> Which it is, as long as the lock is held.
> 
> But what name would you suggest?
> 

Maybe use 'protected' word or something like that, or 'owned', ...

rcu_dereference_protected() or rcu_dereference_owned()



