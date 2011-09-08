Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976Ab1IHXNX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:13:23 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:36639 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753270Ab1IHXNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:13:06 -0400
Message-ID: <4E68FF70.1010709@xenotime.net>
Date: Thu, 08 Sep 2011 10:46:24 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        containers@lists.osdl.org, netdev@vger.kernel.org, xemul@parallels.com,
        "David S. Miller" <davem@davemloft.net>,
        Hiroyouki Kamezawa <kamezawa.hiroyu@jp.fujitsu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH v2 9/9] Add documentation about kmem_cgroup
References: <1315369399-3073-1-git-send-email-glommer@parallels.com> <1315369399-3073-10-git-send-email-glommer@parallels.com>
In-Reply-To: <1315369399-3073-10-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/11 21:23, Glauber Costa wrote:
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: David S. Miller <davem@davemloft.net>
> CC: Hiroyouki Kamezawa <kamezawa.hiroyu@jp.fujitsu.com>
> CC: Eric W. Biederman <ebiederm@xmission.com>
> CC: Randy Dunlap <rdunlap@xenotime.net>
> ---
>  Documentation/cgroups/kmem_cgroups.txt |   27 +++++++++++++++++++++++++++
>  1 files changed, 27 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/cgroups/kmem_cgroups.txt
> 
> diff --git a/Documentation/cgroups/kmem_cgroups.txt b/Documentation/cgroups/kmem_cgroups.txt
> new file mode 100644
> index 0000000..930e069
> --- /dev/null
> +++ b/Documentation/cgroups/kmem_cgroups.txt
> @@ -0,0 +1,27 @@
> +Kernel Memory Cgroup
> +====================
> +
> +This document briefly describes the kernel memory cgroup, or "kmem cgroup".
> +Unlike user memory, kernel memory cannot be swapped. This effectively means
> +that rogue processes can start operations that pin kernel objects permanently
> +into memory, exhausting resources of all other processes in the system.
> +
> +kmem_cgroup main goal is to control the amount of memory a group of processes

   kmem_cgroup's main goal

> +can pin at any given point in time. Other uses of this infrastructure are
> +expected to come up with time. Right now, the only resource effectively limited

                                                      resources

> +are tcp send and receive buffers.

or:
                                             the only resource effectively limited
  is TCP network buffers.

> +
> +TCP network buffers
> +===================
> +
> +TCP network buffers, both on the send and receive sides, can be controlled
> +by the kmem cgroup. Once a socket is created, it is attached to the cgroup of
> +the controller process, where it stays until the end of its lifetime.
> +
> +Files
> +=====
> +	kmem.tcp_maxmem: control the maximum amount in bytes that can be used by

	                 controls the maximum amount of memory in bytes ...


> +	tcp sockets inside the cgroup. 
> +
> +	kmem.tcp_current_memory: current amount in bytes used by all sockets in

	                         current amount of memory in bytes ...

> +	this cgroup


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
