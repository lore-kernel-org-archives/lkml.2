Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab0CVJt7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 05:49:59 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:34888 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754461Ab0CVJt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 05:49:57 -0400
References: <20100322112655.0f23c1fb.sfr@canb.auug.org.au>
Message-Id: <351E30A8-F8E2-4DD8-8AB1-52D1D397785D@fys.uio.no>
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <20100322112655.0f23c1fb.sfr@canb.auug.org.au>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (7E18)
Mime-Version: 1.0 (iPhone Mail 7E18)
Subject: Re: linux-next: build failure after merge of the nfs tree
Date: Mon, 22 Mar 2010 05:49:40 -0400
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-UiO-Ratelimit-Test: rcpts/h 3 msgs/h 1 sum rcpts/h 4 sum msgs/h 1 total rcpts 2588 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 458E419769A0919C58EEDCE516F266686A388650
X-UiO-SPAM-Test: remote_host: 166.137.136.38 spam_score: -49 maxlevel 80 minaction 2 bait 0 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 21, 2010, at 20:26, Stephen Rothwell <sfr@canb.auug.org.au>  
wrote:

> Hi Trond,
>
> After merging the nfs tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>
> net/sunrpc/xprt.c: In function 'xprt_release':
> net/sunrpc/xprt.c:1045: error: implicit declaration of function  
> 'xprt_free_bc_request'
>
> Caused by commit 0d28e05a53109bb52f254d5eac25dac6e3768b04 ("SUNRPC:  
> Fix a
> use after free bug with the NFSv4.1 backchannel").   
> xprt_free_bc_request()
> is only declared for CONFIG_NFS_V4_1 ...
>
> I have used the nfs tree from next-20100319 for today.

Hi Stephen

Sorry about that. I've got a fix for the above (just need to define  
empty inline function for the !CONFIG_NFS_V4_1 case).

I'll try to upload it later today. (I am unfortunately travelling so  
wifi access is a bit spotty).

Cheers
     Trond
