Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab1HHMer (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 08:34:47 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:51362 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525Ab1HHMeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 08:34:46 -0400
Date: Mon, 8 Aug 2011 05:34:42 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: fix rcu annotations noise in cred.h
Message-ID: <20110808123442.GF2385@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110807175511.GZ2203@ZenIV.linux.org.uk>
 <13248.1312791509@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13248.1312791509@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 08, 2011 at 09:18:29AM +0100, David Howells wrote:
> 
> Al Viro <viro@ZenIV.linux.org.uk> wrote:
> 
> >  #define current_cred() \
> > -	(current->cred)
> > +	(*(__force struct cred **)&current->cred)
> 
> No.  You've cast away the const.  Please don't do that.
> 
> Paul: isn't there some better way of doing this using an RCU wrapper macro?
> 
> 	#define current_cred() \
> 		rcu_dereference_protected(current->cred, 1) 
> 
> Perhaps?

This is indeed what rcu_dereference_protected() is intended for.

							Thanx, Paul
