Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab0CYSGK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 14:06:10 -0400
Received: from daytona.panasas.com ([67.152.220.89]:3083 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753675Ab0CYSGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 14:06:05 -0400
Message-ID: <4BABA609.3060408@panasas.com>
Date: Thu, 25 Mar 2010 20:06:01 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Trond Myklebust <trond.myklebust@fys.uio.no>
CC: Al Viro <viro@ZenIV.linux.org.uk>, Benny Halevy <bhalevy@panasas.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       pNFS Mailing List <pnfs@linux-nfs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Doug Nazar <nazard.lkml@gmail.com>
Subject: Re: [pnfs] [GIT BISECT] first bad commit: 1f36f774 Switch !O_CREAT
 case to use of do_last()
References: <20100325101231.GU30031@ZenIV.linux.org.uk>	 <20100325105406.GW30031@ZenIV.linux.org.uk> <4BAB51F5.609@panasas.com>	 <4BAB54B0.3080109@panasas.com> <20100325130610.GZ30031@ZenIV.linux.org.uk>	 <4BAB656E.8020204@panasas.com> <20100325133746.GA30031@ZenIV.linux.org.uk>	 <4BAB6911.5020009@panasas.com> <20100325140457.GB30031@ZenIV.linux.org.uk>	 <4BAB72C1.6090002@panasas.com> <20100325152505.GD30031@ZenIV.linux.org.uk>	 <4BAB9D53.4000909@panasas.com> <1269539981.3648.31.camel@localhost.localdomain>
In-Reply-To: <1269539981.3648.31.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Mar 2010 18:06:04.0566 (UTC) FILETIME=[D5D2EB60:01CACC45]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2010 07:59 PM, Trond Myklebust wrote:
> On Thu, 2010-03-25 at 19:28 +0200, Boaz Harrosh wrote: 
>> On 03/25/2010 05:25 PM, Al Viro wrote:
> 
>>> I'm going to send a fix for O_DIRECTORY case (restoring the behaviour
>>> we had in 2.6.33) today, but NFS side of things also needs to be dealt
>>> with.
>>
>> Thank you Al for fixing this, I hope some capable NFS person will take
>> that issue to heart.
> 
> The NFSv4 fix is a trivial 1 liner. Pushed to bugfixes.
> 

Thanks

> Now to understand that screwed up xdr decode...
> 

Tell me if you need that I run any tests. I still have that
failing setup if you need it.

> Trond

Boaz

> ------------------------------------------------------------------------------------------ 
> NFSv4: Fall back to ordinary lookup if nfs4_atomic_open() returns EISDIR
> From: Trond Myklebust <Trond.Myklebust@netapp.com>
> 
> Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
> ---
> 
>  fs/nfs/dir.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> 
> diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
> index c6f2750..be46f26 100644
> --- a/fs/nfs/dir.c
> +++ b/fs/nfs/dir.c
> @@ -1025,12 +1025,12 @@ static struct dentry *nfs_atomic_lookup(struct inode *dir, struct dentry *dentry
>  				res = NULL;
>  				goto out;
>  			/* This turned out not to be a regular file */
> +			case -EISDIR:
>  			case -ENOTDIR:
>  				goto no_open;
>  			case -ELOOP:
>  				if (!(nd->intent.open.flags & O_NOFOLLOW))
>  					goto no_open;
> -			/* case -EISDIR: */
>  			/* case -EINVAL: */
>  			default:
>  				goto out;
> 
> 

