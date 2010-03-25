Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347Ab0CYNL6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 09:11:58 -0400
Received: from daytona.panasas.com ([67.152.220.89]:56418 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750931Ab0CYNL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 09:11:56 -0400
Message-ID: <4BAB6118.4080201@panasas.com>
Date: Thu, 25 Mar 2010 15:11:52 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: pNFS Mailing List <pnfs@linux-nfs.org>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Doug Nazar <nazard.lkml@gmail.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [pnfs] [GIT BISECT] first bad commit: 1f36f774 Switch !O_CREAT
 case to use of do_last()
References: <4BAA4CAC.6060104@panasas.com> <4BAA5035.1060906@panasas.com>	<4BAA52A8.2080304@panasas.com>	<20100324180622.GS30031@ZenIV.linux.org.uk>	<4BAA5955.4000001@gmail.com>	<20100324185604.GT30031@ZenIV.linux.org.uk>	<4BAB2F5A.30409@panasas.com>	<20100325101231.GU30031@ZenIV.linux.org.uk>	<4BAB3967.6000702@panasas.com>	<20100325104924.GV30031@ZenIV.linux.org.uk>	<20100325115514.GY30031@ZenIV.linux.org.uk> <4BAB5E69.4090407@panasas.com>
In-Reply-To: <4BAB5E69.4090407@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Mar 2010 13:11:55.0377 (UTC) FILETIME=[BE166610:01CACC1C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2010 03:00 PM, Boaz Harrosh wrote:
> On 03/25/2010 01:55 PM, Al Viro wrote:
>> On Thu, Mar 25, 2010 at 10:49:24AM +0000, Al Viro wrote:
>>
>>> Does that happen with nfsv3 or is that v4-only?  I'm going to set up v4
>>> server and client and see what happens, but that information could be
>>> useful...
>>
>> *grumble*
>> I'd managed to forget that rpc.imapd in its infinite wisdom relies on
>> the FPOS I normally disable.  Oh, well... rebuilding testbox kernel
>> with dnotify enabled ;-/
> 
> I just wanted to make sure, on top of 2.6.34-rc2 i did:
> git revert 781b16775ba0bb55fac0e1757bf0bd87c8879632
> 	Revert "Fix a dumb typo - use of & instead of &&"
> and:
> git revert 1f36f774b22a0ceb7dd33eca626746c81a97b6a5
> 	Revert "Switch !O_CREAT case to use of do_last()"
> 
> The revert is now clean and the problem does not show.
> Are you able to reproduce this? Anything I can do to help?
> 

I'm not sure I mentioned this. If you are able to reproduce the
error, then after the error in "git status" the tree becomes unusable.
Not even from the local_mount. I have not found a method to fix the tree.
So what I do is:
- Before I start playing I save "cp some_tree/.git/index index.back"
- then after the error and tree damage On local mount I:
  "rm some_tree/.git/index"
  "cp index.back cp some_tree/.git/index"
  "cd some_tree; git status"

this will fix it so I can try a new iteration

> Thanks
> Boaz
