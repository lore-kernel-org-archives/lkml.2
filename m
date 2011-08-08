Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079Ab1HHI2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 04:28:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48757 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab1HHI2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 04:28:18 -0400
Date: Mon, 8 Aug 2011 09:28:10 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: fix rcu annotations noise in cred.h
Message-ID: <20110808082810.GC2203@ZenIV.linux.org.uk>
References: <20110807175511.GZ2203@ZenIV.linux.org.uk>
 <13248.1312791509@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13248.1312791509@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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

So let's bring const back, not a problem...
