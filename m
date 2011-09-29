Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480Ab1I2TWQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 15:22:16 -0400
Received: from mx2.netapp.com ([216.240.18.37]:26791 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755308Ab1I2TWP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 15:22:15 -0400
X-IronPort-AV: E=Sophos;i="4.68,462,1312182000"; 
   d="scan'208";a="585715230"
Subject: Re: 3.1rc7+ FSX failure over NFS
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Dave Jones <davej@redhat.com>
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 29 Sep 2011 15:22:13 -0400
In-Reply-To: <20110929190519.GA15165@redhat.com>
References: <20110929184127.GA12236@redhat.com>
	 <1317322772.8708.30.camel@lade.trondhjem.org>
	 <20110929190519.GA15165@redhat.com>
Organization: NetApp Inc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Message-ID: <1317324133.8708.43.camel@lade.trondhjem.org>
Mime-Version: 1.0
X-OriginalArrivalTime: 29 Sep 2011 19:22:14.0035 (UTC) FILETIME=[17E04E30:01CC7EDD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-29 at 15:05 -0400, Dave Jones wrote: 
> On Thu, Sep 29, 2011 at 02:59:32PM -0400, Trond Myklebust wrote:
>  
>  > 1) What filesystem are you using on the server, and does that filesystem
>  > support high resolution timestamps?
> 
> ext3

Hmm... Is the problem also reproducible with ext4 or xfs?

ext3 has the issue that mtime/ctime timestamps are only accurate to
within 1 second, and so the client often has trouble figuring out which
returned attribute values reflect the most recent state on the server
when several RPC calls have been transmitted in parallel. 

> > 2) Does the file length on the server match the reported erroneous file
>  > length on the client?
> 
> No. Server side is 213853 bytes (0x3435d)

Ouch. That would seem to indicate that something is happening after the
truncate(). I would have expected the server to show 0x3210a...

> > 3) Do the mtime and ctime on the erroneous file match on the client and
>  > server?
>  
> both show..
> Modify: 2011-09-29 13:50:00.000000000 -0400

OK. This result looks consistent with the hypothesis put forward under
question (1) above. However your reply to (2) does not. Let me
investigate and see if I can reproduce it...

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

