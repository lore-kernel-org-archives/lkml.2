Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937Ab2HOU7K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:59:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57625 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756333Ab2HOU7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 16:59:08 -0400
Message-ID: <502C0D7C.2040707@zytor.com>
Date: Wed, 15 Aug 2012 13:58:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Stanislav Kinsbursky <skinsbursky@parallels.com>, tglx@linutronix.de,
        mingo@redhat.com, davem@davemloft.net,
        thierry.reding@avionic-design.de, bfields@redhat.com,
        eric.dumazet@gmail.com, xemul@parallels.com, neilb@suse.de,
        netdev@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        paul.gortmaker@windriver.com, viro@zeniv.linux.org.uk,
        gorcunov@openvz.org, akpm@linux-foundation.org,
        tim.c.chen@linux.intel.com, devel@openvz.org
Subject: Re: [RFC PATCH 0/5] net: socket bind to file descriptor introduced
References: <20120815161141.7598.16682.stgit@localhost.localdomain> <87a9xwc4vr.fsf@xmission.com>
In-Reply-To: <87a9xwc4vr.fsf@xmission.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2012 12:49 PM, Eric W. Biederman wrote:
> 
> There is also the trick of getting a shorter directory name using
> /proc/self/fd if you are threaded and can't change the directory.
> 
> The obvious choices at this point are
> - Teach bind and connect and af_unix sockets to take longer AF_UNIX
>   socket path names.
> 
> - introduce sockaddr_fd that can be applied to AF_UNIX sockets,
>   and teach unix_bind and unix_connect how to deal with a second type of sockaddr.
>   struct sockaddr_fd { short fd_family; short pad; int fd; };
> 
> - introduce sockaddr_unix_at that takes a directory file descriptor
>   as well as a unix path, and teach unix_bind and unix_connect to deal with a
>   second sockaddr type.
>   struct sockaddr_unix_at { short family; short pad; int dfd; char path[102]; }
>   AF_UNIX_AT
> 
> I don't know what the implications of for breaking connect up into 3
> system calls and changing the semantics are and I would really rather
> not have to think about it.
> 
> But it certainly does not look to me like you introduce new systems
> calls to do what you want.
> 

How would you distinguish the new sockaddr types from the traditional
one?  New AF_?

	-hpa
