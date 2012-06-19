Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab2FSTfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 15:35:46 -0400
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:38913 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753043Ab2FSTfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 15:35:45 -0400
Date: Tue, 19 Jun 2012 20:35:40 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: nfs3 problem with -rc{2,3} : blame
Message-ID: <20120619193540.GA14702@milliways>
References: <20120618160005.GA10169@milliways>
 <20120618200525.GA15654@milliways>
 <20120618215323.GA17561@milliways>
 <1340057002.20570.31.camel@lade.trondhjem.org>
 <20120618221052.GA18341@milliways>
 <20120619010641.GA22288@milliways>
 <1340122836.3754.9.camel@lade.trondhjem.org>
 <1340123001.3754.11.camel@lade.trondhjem.org>
 <20120619165520.GA11015@milliways>
 <1340127987.3754.16.camel@lade.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1340127987.3754.16.camel@lade.trondhjem.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Cloudmark-Analysis: v=1.1 cv=JvdXmxIgLJv2/GthKqHpGJEEHukvLcvELVXUanXFreg= c=1 sm=0 a=wom5GMh1gUkA:10 a=3oYqF3-p60YA:10 a=uObrxnre4hsA:10 a=IkcTkHD0fZMA:10 a=JDjsHSkAAAAA:8 a=_PNYrBQna78QkEU3VdAA:9 a=QEXdDO2ut3YA:10 a=Hf6muOzgCGQA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 05:46:28PM +0000, Myklebust, Trond wrote:
> 
> Does the following patch make any difference?
> 
> You probably want to ensure that you also have commit
> 906369e43c29001c39c7dfed8a01b9dff24ace75 (which is in 3.5-rc3) since
> that corrects a similar issue.
> 
> Cheers
>   Trond
> 8<------------------------------------------------------------
> From ed3b97f9af6421f326de413e6d6556d1ecc3399d Mon Sep 17 00:00:00 2001
> From: Trond Myklebust <Trond.Myklebust@netapp.com>
> Date: Tue, 19 Jun 2012 13:39:14 -0400
> Subject: [PATCH] NFS: Fix a refcounting issue in O_DIRECT
> 
> In nfs_direct_write_reschedule(), the requests from nfs_scan_commit_list
> have a refcount of 2, whereas the operations in
> nfs_direct_write_completion_ops expect them to have a refcount of 1.
> 
> This patch adds a call to release the extra references.

 Unfortunately, no difference (on top of -rc3).

 FWIW, after rsync stalled I tried a download from firefox, to a
different nfs mount, and that too appeared to lock up firefox.

ĸen
-- 
das eine Mal als Tragödie, das andere Mal als Farce
