Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab1DKCDU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 22:03:20 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:54808 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802Ab1DKCDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 22:03:19 -0400
Message-ID: <4DA26159.7050902@oracle.com>
Date: Sun, 10 Apr 2011 19:03:05 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Olaf Dietsche <olaf+list.linux-kernel@olafdietsche.de>
CC: linux-kernel@vger.kernel.org, Rod Cordova <rcordova@ethernet.org>
Subject: Re: [PATCH] 2.6.38: access permission filesystem 0.24
References: <Pine.LNX.4.64.1103291321440.32194@fatboy.ethernet.org> <87sjtpai9d.fsf@rat.lan>
In-Reply-To: <87sjtpai9d.fsf@rat.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4DA26154.0140:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/10/2011 2:50 PM, Olaf Dietsche wrote:
> This *untested* patch adds a new permission managing file system.
> Furthermore, it adds two modules, which make use of this file system.
>
> One module allows granting capabilities based on user-/groupid. The
> second module allows to grant access to lower numbered ports based on
> user-/groupid, too.
>
> Changes:
> - updated to 2.6.38
>
> This patch is available at:
> <http://www.olafdietsche.de/linux/accessfs/>
>
> and attached inline below.
>
> Regards, Olaf
>
>   Documentation/filesystems/accessfs.txt |   41 +++
>   fs/Kconfig                             |    1 +
>   fs/Makefile                            |    1 +
>   fs/accessfs/Kconfig                    |   63 +++++
>   fs/accessfs/Makefile                   |   11 +
>   fs/accessfs/capabilities.c             |  108 ++++++++
>   fs/accessfs/inode.c                    |  432 ++++++++++++++++++++++++++++++++
>   fs/accessfs/ip.c                       |  101 ++++++++
>   include/linux/accessfs_fs.h            |   42 +++
>   include/net/sock.h                     |   43 ++++
>   net/Kconfig                            |   12 +
>   net/Makefile                           |    1 +
>   net/hooks.c                            |   55 ++++
>   net/ipv4/af_inet.c                     |    2 +-
>   net/ipv6/af_inet6.c                    |    2 +-
>   15 files changed, 913 insertions(+), 2 deletions(-)


+config ACCESSFS_USER_PORTS
+	tristate "User permission based IP ports"
+	depends on ACCESS_FS
+	select NET_HOOKS
+	default n
+	help
+	  If you say Y here, you will be able to control access to IP ports
+	  based on user-/groupid. For this to work, you must say Y
+	  to CONFIG_NET_HOOKS.

That last sentence is handled (in theory) by "select NET_HOOKS", right?

But NET_HOOKS depends on INET && EXPERIMENTAL, so this config should not
select NET_HOOKS unless INET && EXPERIMENTAL are enabled also.

