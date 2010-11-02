Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab0KBVQG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 17:16:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55863 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038Ab0KBVQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 17:16:03 -0400
Date: Tue, 2 Nov 2010 22:15:58 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Andi Kleen <andi@firstfloor.org>, bjschuma@netapp.com,
        torvalds@linux-foundation.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [regression] NFS readdir change break fully cached nfs root
Message-ID: <20101102211558.GE2167@basil.fritz.box>
References: <20101102180051.GA26089@basil.fritz.box>
 <1288731930.534.1.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288731930.534.1.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 02, 2010 at 05:05:30PM -0400, Trond Myklebust wrote:
> On Tue, 2010-11-02 at 19:00 +0100, Andi Kleen wrote:
> > My NFS root test systems stopped booting with 2.6.37-rc1. It just
> > hangs after entering user space.
> > 
> > The NFS root setup uses a slightly fancy parameter setup to minimize 
> > network traffic:
> > 
> > nfsroot=10.23.204.1:/home/nfsroot/edwin,nocto,acregmin=86400,acregmax=86400,acdirmin=86400,acdirmax=86400 root=/dev/nfs
> > 
> > I bisected it down to this commit from Bryan.
> > 
> > Unfortunately it's not trivially revertable because that conflicts
> > with later patches.
> 
> Does the following patch help?

Yes that fixes it. Thanks. Test system boots again.
-Andi
