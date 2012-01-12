Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab2ALHOl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 02:14:41 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:35440 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab2ALHOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 02:14:40 -0500
X-Originating-IP: 217.70.178.129
X-Originating-IP: 50.43.15.19
Date: Wed, 11 Jan 2012 23:14:31 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: paulmck@linux.vnet.ibm.com, laijs@cn.fujitsu.com, manfred@colorfullife.com,
        dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rcu: avoid checking for constant
Message-ID: <20120112071431.GA1896@leaf>
References: <1326345104-6919-1-git-send-email-jengelh@medozas.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326345104-6919-1-git-send-email-jengelh@medozas.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 06:11:44AM +0100, Jan Engelhardt wrote:
> When compiling kernel or module code with -O0, "offset" is no longer
> considered a constant, and therefore always triggers the build error
> that BUILD_BUG_ON is defined to yield.
> 
> What is the rationale between the forced constant check,
> introduced in 9ab1544eb4196ca8d05c433b2eb56f74496b1ee3?
[...]
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -805,8 +805,6 @@ void __kfree_rcu(struct rcu_head *head, unsigned long offset)
>  {
>  	typedef void (*rcu_callback)(struct rcu_head *);
>  
> -	BUILD_BUG_ON(!__builtin_constant_p(offset));
> -
>  	/* See the kfree_rcu() header comment. */
>  	BUILD_BUG_ON(!__is_kfree_rcu_offset(offset));

The very next check after the one you removed will break if the
compiler can't check the offset at compile time.

- Josh Triplett
