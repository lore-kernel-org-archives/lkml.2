Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab1H0AQg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 20:16:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754390Ab1H0AQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 20:16:35 -0400
Message-ID: <4E58375E.3010603@redhat.com>
Date: Fri, 26 Aug 2011 20:16:30 -0400
From: Eric Paris <eparis@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Casey Schaufler <casey@schaufler-ca.com>
CC: "Sakkinen, Jarkko" <jarkko.sakkinen@intel.com>,
        Eric Paris <eparis@parisplace.org>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Smack: SMACK_IOCLOADACCESS
References: <1314337927-17210-1-git-send-email-jarkko.sakkinen@intel.com> <CACLa4pvbaWM8jRJvBW2NvN2OLK8x4wP44pfdUQ9He1fZwWYcfA@mail.gmail.com> <CADjiTvBkwusfjdE=PQ5B=MPMxr1bewR6v9qoqq6yMNWjp-BeLQ@mail.gmail.com> <4E57D17E.9020806@redhat.com> <4E58175A.9090209@schaufler-ca.com>
In-Reply-To: <4E58175A.9090209@schaufler-ca.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2011 05:59 PM, Casey Schaufler wrote:
> On 8/26/2011 10:01 AM, Eric Paris wrote:

> Better to have a single question answered as required and with
> complete accuracy than to carry around the baggage necessary to
> maintain a cached duplicate of the kernel's rules and all the
> bookkeeping that requires. SELinux libraries probably have to
> make a system call just to determine if the caches they are
> maintaining are out of date.

Come on Casey, this is Linux.  We have choices!  I believe there are
currently 3 solutions to solving the 'out of date caches' problem.  The
first and oldest is just a syscall per access request option (I think it
does read() but don't remember).  There is an option to get a netlink
message informing you to flush your cache.  SE-XWindows found that ONE
syscall per check was WAY WAY WAY too much overhead and uses this
method.  There is also a magic selinuxfs file which a userspace process
can mmap and just read the memory location to tell if a reload occurred.
 SE-PostgreSQL uses this method because their software architecture did
not have a good way to handle a netlink socket.

The value of the userspace cache is admittedly entirely a question of
the willingness to accept the overhead of kernel lookups.

/me checks out of thread.

-Eric
