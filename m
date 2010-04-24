Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757717Ab0DXBYh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 21:24:37 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:38247 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757611Ab0DXBYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 21:24:33 -0400
Date: Fri, 23 Apr 2010 18:24:30 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: David Howells <dhowells@redhat.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Documentation/cred.txt: spinlock no longer implies
 rcu_read_lock
Message-ID: <20100424012430.GC2589@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100424004557.GA21297@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100424004557.GA21297@us.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 07:45:57PM -0500, Serge E. Hallyn wrote:
> So change the credentials documentation to make it clear that rcu
> read lock is required.

Very good!

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Serge Hallyn <serue@us.ibm.com>
> ---
>  Documentation/credentials.txt |    8 ++------
>  1 files changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/credentials.txt b/Documentation/credentials.txt
> index df03169..98a1e9e 100644
> --- a/Documentation/credentials.txt
> +++ b/Documentation/credentials.txt
> @@ -408,9 +408,6 @@ This should be used inside the RCU read lock, as in the following example:
>  		...
>  	}
> 
> -A function need not get RCU read lock to use __task_cred() if it is holding a
> -spinlock at the time as this implicitly holds the RCU read lock.
> -
>  Should it be necessary to hold another task's credentials for a long period of
>  time, and possibly to sleep whilst doing so, then the caller should get a
>  reference on them using:
> @@ -426,14 +423,13 @@ credentials, hiding the RCU magic from the caller:
>  	uid_t task_uid(task)		Task's real UID
>  	uid_t task_euid(task)		Task's effective UID
> 
> -If the caller is holding a spinlock or the RCU read lock at the time anyway,
> -then:
> +If the caller is holding the RCU read lock at the time anyway, then:
> 
>  	__task_cred(task)->uid
>  	__task_cred(task)->euid
> 
>  should be used instead.  Similarly, if multiple aspects of a task's credentials
> -need to be accessed, RCU read lock or a spinlock should be used, __task_cred()
> +need to be accessed, RCU read lock should be used, __task_cred()
>  called, the result stored in a temporary pointer and then the credential
>  aspects called from that before dropping the lock.  This prevents the
>  potentially expensive RCU magic from being invoked multiple times.
> -- 
> 1.6.3.3
> 
