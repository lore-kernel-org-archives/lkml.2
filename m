Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034Ab1HHISi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 04:18:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274Ab1HHISh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 04:18:37 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20110807175511.GZ2203@ZenIV.linux.org.uk>
References: <20110807175511.GZ2203@ZenIV.linux.org.uk>
To: Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: fix rcu annotations noise in cred.h
Date: Mon, 08 Aug 2011 09:18:29 +0100
Message-ID: <13248.1312791509@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Al Viro <viro@ZenIV.linux.org.uk> wrote:

>  #define current_cred() \
> -	(current->cred)
> +	(*(__force struct cred **)&current->cred)

No.  You've cast away the const.  Please don't do that.

Paul: isn't there some better way of doing this using an RCU wrapper macro?

	#define current_cred() \
		rcu_dereference_protected(current->cred, 1) 

Perhaps?

David
