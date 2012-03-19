Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161396Ab2CSPSm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 11:18:42 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:48483 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758701Ab2CSPSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 11:18:39 -0400
Message-ID: <4F674E4F.5080904@xenotime.net>
Date: Mon, 19 Mar 2012 08:18:39 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Steven Whitehouse <swhiteho@redhat.com>
CC: linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
        teigland@redhat.com
Subject: Re: GFS2: Pre-pull patch posting (merge window)
References: <1332152728-4027-1-git-send-email-swhiteho@redhat.com>	 <4F674696.7030602@xenotime.net> <1332169153.2689.20.camel@menhir>
In-Reply-To: <1332169153.2689.20.camel@menhir>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2012 07:59 AM, Steven Whitehouse wrote:

> Hi,
> 
> On Mon, 2012-03-19 at 07:45 -0700, Randy Dunlap wrote:
>> On 03/19/2012 03:25 AM, Steven Whitehouse wrote:
>>
>>> Hi,
>>>
>>> Not a huge number of patches this time. Some notable new features
>>> though:
>>>  - Glock stats gathering (v. useful for performance analysis)
>>>  - FITRIM ioctl support
>>>  - Sorting the ordered write list (big performance increase when the workload
>>>    doesn't result in the write requests being nicely ordered to start with)
>>>
>>> Plus a few clean ups, and bug fixes in addition,
>>
>>
>>
>> Hi,
>>
>> I reported a build error in linux-next 20120313, but it appears
>> that mainline also needs the fix (when it's ready) since mainline
>> gfs2 Kconfig selects DLM_SCTP, which does not exist.
>>
>> https://lkml.org/lkml/2012/3/13/456
>>
> 
> Does the following fix the problem? If so then I'll roll that into the
> tree before it gets pushed,
> 

No, that's not sufficient:

warning: (GFS2_FS) selects DLM which has unmet direct dependencies (EXPERIMENTAL && INET && SYSFS && CONFIGFS_FS && (IPV6 || IPV6=n))
warning: (DLM && GFS2_FS) selects IP_SCTP which has unmet direct dependencies (NET && INET && EXPERIMENTAL && (IPV6 || IPV6=n))

and

ERROR: "crc32c" [net/sctp/sctp.ko] undefined!




> 
> diff --git a/fs/gfs2/Kconfig b/fs/gfs2/Kconfig
> index c465ae0..f4e1c60 100644
> --- a/fs/gfs2/Kconfig
> +++ b/fs/gfs2/Kconfig
> @@ -4,7 +4,7 @@ config GFS2_FS
>  	select DLM if GFS2_FS_LOCKING_DLM
>  	select CONFIGFS_FS if GFS2_FS_LOCKING_DLM
>  	select SYSFS if GFS2_FS_LOCKING_DLM
> -	select IP_SCTP if DLM_SCTP
> +	select IP_SCTP if GFS2_FS_LOCKING_DLM
>  	select FS_POSIX_ACL
>  	select CRC32
>  	select QUOTACTL
> 
> 



-- 
~Randy
