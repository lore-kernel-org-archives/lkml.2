Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab0CYKWh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 06:22:37 -0400
Received: from daytona.panasas.com ([67.152.220.89]:31909 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753690Ab0CYKWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 06:22:36 -0400
Message-ID: <4BAB3967.6000702@panasas.com>
Date: Thu, 25 Mar 2010 12:22:31 +0200
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Boaz Harrosh <bharrosh@panasas.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       pNFS Mailing List <pnfs@linux-nfs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Doug Nazar <nazard.lkml@gmail.com>,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [pnfs] [GIT BISECT] first bad commit: 1f36f774 Switch !O_CREAT
 case to use of do_last()
References: <4BAA398C.5050901@panasas.com>	<20100324163948.GR30031@ZenIV.linux.org.uk>	<4BAA48A3.1030801@panasas.com> <4BAA4CAC.6060104@panasas.com>	<4BAA5035.1060906@panasas.com> <4BAA52A8.2080304@panasas.com>	<20100324180622.GS30031@ZenIV.linux.org.uk>	<4BAA5955.4000001@gmail.com>	<20100324185604.GT30031@ZenIV.linux.org.uk>	<4BAB2F5A.30409@panasas.com> <20100325101231.GU30031@ZenIV.linux.org.uk>
In-Reply-To: <20100325101231.GU30031@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Mar 2010 10:22:34.0656 (UTC) FILETIME=[15D36A00:01CACC05]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar. 25, 2010, 12:12 +0200, Al Viro <viro@ZenIV.linux.org.uk> wrote:
> On Thu, Mar 25, 2010 at 11:39:38AM +0200, Boaz Harrosh wrote:
> 
>> It makes no difference, fails just the same. Would an "strace" help?
> 
> It might, especially if you ran it for identical repositories on local
> fs and on NFS; at least that way it would be possible to see where do
> they diverge...
> _______________________________________________
> pNFS mailing list
> pNFS@linux-nfs.org
> http://linux-nfs.org/cgi-bin/mailman/listinfo/pnfs

ext3 fs exported on the server
client mount -t nfs4 localhost:/ /mnt/localhost
$ strace git status
...
open(".git/objects/pack", O_RDONLY|O_NONBLOCK|O_DIRECTORY|0x80000) = -1 EISDIR (Is a directory)
