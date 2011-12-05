Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932813Ab1LERlk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:41:40 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38791 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932535Ab1LERlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:41:37 -0500
Date: Mon, 5 Dec 2011 09:41:26 -0800
From: Tejun Heo <tj@kernel.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Woody Suwalski <terraluna977@gmail.com>, Jeff Layton <jlayton@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Belisko Marek <marek.belisko@gmail.com>, linux-cifs@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, davem@davemloft.net
Subject: Re: CIFS mount: 3.2.0-rc3 suspend crash
Message-ID: <20111205174126.GF627@google.com>
References: <4ED56C12.1040708@gmail.com>
 <4ED5C047.6040500@linux.vnet.ibm.com>
 <20111130062502.68d9db59@tlielax.poochiereds.net>
 <4ED81077.2080305@gmail.com>
 <4ED8C940.20509@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ED8C940.20509@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Srivatsa.

On Fri, Dec 02, 2011 at 06:19:04PM +0530, Srivatsa S. Bhat wrote:
> So how about solving this problem more fundamentally, such as defining a
> freezable wrapper over kernel_recvmsg like:
> 
> #define kernel_recvmsg_freezable(sock, msg, vec, num, size, flags)      \
> ({                                                                      \
>         kernel_recvmsg(sock, msg, vec, num, size, flags)                \
> 	try_to_freeze();                                                \
> })
> 
> and using it instead of kernel_recvmsg(), throughout the kernel?
> 
> But kernel_recvmsg is an exported symbol. So if we are very very unwilling
> to change the kernel ABI, we could probably think about adding try_to_freeze()
> inside kernel_recvmsg itself,like this (but see below about my thoughts about
> which one is better):

I don't necessarily object to introducing the wrapper but I don't
really think we should be doing s//g over the source tree without
understanding where it's actually necessary.  For kernel threads and
user threads out of the signal delivery path, try_to_freeze() is an
exceptional event which introduces behavior which can be difficult to
reproduce track down and spreading it without actually knowing what
the surrounding code is doing doesn't sound like a good idea to me.

Thank you.

-- 
tejun
