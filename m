Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518Ab2CWUGK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 16:06:10 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:51278 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752286Ab2CWUGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 16:06:08 -0400
Message-ID: <4F6CD7AD.9030306@xenotime.net>
Date: Fri, 23 Mar 2012 13:06:05 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: David Teigland <teigland@redhat.com>
CC: Steven Whitehouse <swhiteho@redhat.com>, linux-kernel@vger.kernel.org,
        cluster-devel@redhat.com
Subject: Re: GFS2: Pre-pull patch posting (merge window)
References: <1332152728-4027-1-git-send-email-swhiteho@redhat.com> <4F674696.7030602@xenotime.net> <1332169153.2689.20.camel@menhir> <4F674E4F.5080904@xenotime.net> <1332171247.2689.28.camel@menhir> <20120323194152.GD24746@redhat.com>
In-Reply-To: <20120323194152.GD24746@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2012 12:41 PM, David Teigland wrote:

> 
>> on i386:
>>
>> ERROR: "sctp_do_peeloff" [fs/dlm/dlm.ko] undefined!
>>
>>
>> GFS2_FS selects DLM (if GFS2_FS_LOCKING_DLM, which is enabled).
>> GFS2_FS selects IP_SCTP if DLM_SCTP, which is not enabled and not
>> used anywhere else in the kernel tree AFAICT.
>> DLM just always selects IP_SCTP.
> 
> Here's what we have now:
> 
> config GFS2_FS
>         tristate "GFS2 file system support"
>         depends on (64BIT || LBDAF)
>         select DLM if GFS2_FS_LOCKING_DLM
>         select CONFIGFS_FS if GFS2_FS_LOCKING_DLM
>         select SYSFS if GFS2_FS_LOCKING_DLM
>         select IP_SCTP if DLM_SCTP
>         select FS_POSIX_ACL
>         select CRC32
>         select QUOTACTL
> 
> menuconfig DLM
>         tristate "Distributed Lock Manager (DLM)"
>         depends on EXPERIMENTAL && INET
>         depends on SYSFS && CONFIGFS_FS && (IPV6 || IPV6=n)
>         select IP_SCTP
> 
> Why does gfs2 Kconfig bother with SCTP at all?  It seems that line should
> just be removed.  I'll also remove EXPERIMENTAL.  I don't understand the
> vagaries of Kconfig, so a dumb question, how could sctp_do_peeloff
> possibly be undefined if we're selecting SCTP.

What is selecting SCTP?  DLM?  so GFS2 selects DLM, but selects
don't follow dependency chains.  Also, the "select IP_SCTP if DLM_SCTP"
in GFS2 is meaningless since there is no DLM_SCTP.

I just verified that the (posted) failing config still fails with
today's linux-next.

-- 
~Randy
