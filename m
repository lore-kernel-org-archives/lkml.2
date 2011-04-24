Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354Ab1DXTKF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 15:10:05 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:18535 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166Ab1DXTKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 15:10:01 -0400
Message-ID: <4DB47564.3020202@oracle.com>
Date: Sun, 24 Apr 2011 12:09:24 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Olaf Dietsche <olaf+list.linux-kernel@olafdietsche.de>
CC: linux-kernel@vger.kernel.org, Rod Cordova <rcordova@ethernet.org>
Subject: Re: [PATCH] 2.6.38: access permission filesystem 0.25
References: <Pine.LNX.4.64.1103291321440.32194@fatboy.ethernet.org>	<87sjtpai9d.fsf@rat.lan> <4DA26159.7050902@oracle.com> <87zknw8qh5.fsf@rat.lan>
In-Reply-To: <87zknw8qh5.fsf@rat.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4DB4756E.0144:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/11 13:47, Olaf Dietsche wrote:
> Randy Dunlap <randy.dunlap@oracle.com> writes:
> 
>> +config ACCESSFS_USER_PORTS
>> +	tristate "User permission based IP ports"
>> +	depends on ACCESS_FS
>> +	select NET_HOOKS
>> +	default n
>> +	help
>> +	  If you say Y here, you will be able to control access to IP ports
>> +	  based on user-/groupid. For this to work, you must say Y
>> +	  to CONFIG_NET_HOOKS.
>>
>> That last sentence is handled (in theory) by "select NET_HOOKS", right?
>>
>> But NET_HOOKS depends on INET && EXPERIMENTAL, so this config should not
>> select NET_HOOKS unless INET && EXPERIMENTAL are enabled also.
> 
> Thanks for spotting this. Fixed version is below and at 

+config ACCESSFS_USER_PORTS
+	tristate "User permission based IP ports"
+	depends on ACCESS_FS && INET
+	select NET_HOOKS
+	default n
+	help
+	  If you say Y here, you will be able to control access to IP ports
+	  based on user-/groupid. For this to work, you must say Y
+	  to CONFIG_NET_HOOKS.

The last sentence of help text is unneeded and could be confusing to a user
since the "select NET_HOOKS" is already done above.


Have you built this lately?  There have been a few vfs changes recently.
Building on 2.6.39-rc4, I get this:

/lnx/src/lnx-2639-rc4/fs/accessfs/inode.c: In function 'accessfs_get_sb':
/lnx/src/lnx-2639-rc4/fs/accessfs/inode.c:363: error: implicit declaration of function 'get_sb_single'
/lnx/src/lnx-2639-rc4/fs/accessfs/inode.c: At top level:
/lnx/src/lnx-2639-rc4/fs/accessfs/inode.c:404: error: unknown field 'get_sb' specified in initializer
/lnx/src/lnx-2639-rc4/fs/accessfs/inode.c:404: warning: initialization makes integer from pointer without a cast
/lnx/src/lnx-2639-rc4/fs/accessfs/inode.c:404: error: initializer element is not computable at load time
/lnx/src/lnx-2639-rc4/fs/accessfs/inode.c:404: error: (near initialization for 'accessfs_fs_type.fs_flags')


> <http://www.olafdietsche.de/linux/accessfs/>
> 
> Regards, Olaf
> 
>  Documentation/filesystems/accessfs.txt |   41 +++
>  fs/Kconfig                             |    1 +
>  fs/Makefile                            |    1 +
>  fs/accessfs/Kconfig                    |   63 +++++
>  fs/accessfs/Makefile                   |   11 +
>  fs/accessfs/capabilities.c             |  108 ++++++++
>  fs/accessfs/inode.c                    |  432 ++++++++++++++++++++++++++++++++
>  fs/accessfs/ip.c                       |  101 ++++++++
>  include/linux/accessfs_fs.h            |   42 +++
>  include/net/sock.h                     |   43 ++++
>  net/Kconfig                            |   12 +
>  net/Makefile                           |    1 +
>  net/hooks.c                            |   55 ++++
>  net/ipv4/af_inet.c                     |    2 +-
>  net/ipv6/af_inet6.c                    |    2 +-
>  15 files changed, 913 insertions(+), 2 deletions(-)


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
