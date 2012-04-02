Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab2DBPfW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 11:35:22 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:49713 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751628Ab2DBPfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 11:35:21 -0400
Message-ID: <4F79C733.60604@xenotime.net>
Date: Mon, 02 Apr 2012 08:35:15 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Steven Whitehouse <swhiteho@redhat.com>
CC: Benjamin Poirier <bpoirier@suse.de>, David Teigland <teigland@redhat.com>,
        linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: Re: GFS2: Pre-pull patch posting (merge window)
References: <1332152728-4027-1-git-send-email-swhiteho@redhat.com>	 <4F674696.7030602@xenotime.net> <1332169153.2689.20.camel@menhir>	 <4F674E4F.5080904@xenotime.net> <1332171247.2689.28.camel@menhir>	 <20120323194152.GD24746@redhat.com> <4F6CD7AD.9030306@xenotime.net>	 <20120323201820.GE24746@redhat.com>	 <20120323220618.GA30906@d2.synalogic.ca> <1332758662.2721.10.camel@menhir>
In-Reply-To: <1332758662.2721.10.camel@menhir>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2012 03:44 AM, Steven Whitehouse wrote:

> Hi,
> 
> On Fri, 2012-03-23 at 18:06 -0400, Benjamin Poirier wrote:
> [snip]
>>
>> Instead of trying to select everything in GFS2, how about doing it this way?
>>
>> [PATCH] gfs2: use depends instead of select in kconfig
>>
>> Avoids having to duplicate the dependencies of what is 'select'ed (and on
>> down...)
>>
>> Those dependencies are currently incomplete, leading to broken builds with
>> GFS2_FS_LOCKING_DLM=y and IP_SCTP=n.
>>
>> Signed-off-by: Benjamin Poirier <bpoirier@suse.de>
>> ---
>>  fs/gfs2/Kconfig |    7 ++-----
>>  1 files changed, 2 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/gfs2/Kconfig b/fs/gfs2/Kconfig
>> index c465ae0..eb08c9e 100644
>> --- a/fs/gfs2/Kconfig
>> +++ b/fs/gfs2/Kconfig
>> @@ -1,10 +1,6 @@
>>  config GFS2_FS
>>  	tristate "GFS2 file system support"
>>  	depends on (64BIT || LBDAF)
>> -	select DLM if GFS2_FS_LOCKING_DLM
>> -	select CONFIGFS_FS if GFS2_FS_LOCKING_DLM
>> -	select SYSFS if GFS2_FS_LOCKING_DLM
>> -	select IP_SCTP if DLM_SCTP
>>  	select FS_POSIX_ACL
>>  	select CRC32
>>  	select QUOTACTL
>> @@ -29,7 +25,8 @@ config GFS2_FS
>>  
>>  config GFS2_FS_LOCKING_DLM
>>  	bool "GFS2 DLM locking"
>> -	depends on (GFS2_FS!=n) && NET && INET && (IPV6 || IPV6=n) && HOTPLUG
>> +	depends on (GFS2_FS!=n) && NET && INET && (IPV6 || IPV6=n) && \
>> +		HOTPLUG && DLM && CONFIGFS_FS && SYSFS
>>  	help
>>  	  Multiple node locking module for GFS2
>>  
> 
> That looks ok to me. I've put it in the GFS2 -fixes tree, and if
> everybody is happy with that I'll send a pull request shortly,


Can we get Benjamin's patch merged, please?
linux-next is still having build errors without it.

-- 
~Randy
