Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab1BCVza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 16:55:30 -0500
Received: from mx2.netapp.com ([216.240.18.37]:41005 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753735Ab1BCVz1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 16:55:27 -0500
X-IronPort-AV: E=Sophos;i="4.60,422,1291622400"; 
   d="scan'208";a="514035627"
Subject: Re: [PATCH] Fix size argument to memset call in nfsacl_encode
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Chuck Lever <chuck.lever@oracle.com>
Cc: Jesper Juhl <jj@chaosbits.net>, Milton Miller <miltonm@bga.com>,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Neil Brown <neilb@suse.de>, bfields@fieldses.org
In-Reply-To: <67867FEF-6C10-4A35-8952-4EB56EAB79B9@oracle.com>
References: <alpine.LNX.2.00.1102032012540.15101@swampdragon.chaosbits.net>
	 <1296761330.3015.22.camel@heimdal.trondhjem.org>
	 <alpine.LNX.2.00.1102032035280.15101@swampdragon.chaosbits.net>
	 <705C97E5-E273-45AA-9714-2BF409DE1322@oracle.com>
	 <1296763614.3015.26.camel@heimdal.trondhjem.org>
	 <67867FEF-6C10-4A35-8952-4EB56EAB79B9@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp Inc
Date: Thu, 03 Feb 2011 16:55:10 -0500
Message-ID: <1296770110.12342.6.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
X-OriginalArrivalTime: 03 Feb 2011 21:55:13.0409 (UTC) FILETIME=[08E51F10:01CBC3ED]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-03 at 15:29 -0500, Chuck Lever wrote: 
> Sorry, I wasn't clear.  IMO, data that is destined for the network is an important case where we have to be careful about the rule of using either assignments or memset(), not both, when initializing a data structure.
> 
> If the compiler doesn't pack the fields in struct posix_acl, there is unused space between them.  Memory for acl2 comes from the stack, which contains arbitrary data when this function is invoked.  The areas between the structure fields are not affected by the variable assignments used here.  If the data in acl2 is then simply memcpy'd to the XDR buffer, that old stack data can possibly appear on the wire.
> 
> I agree that the current memset() is incorrect.  My conditional ACK was more about what happens in xdr_encode_array2() rather than how the posix_acl acl2 is initialized.  I think in that regard we are also safe, if the array encoding operates by data type rather than by simply doing a blanket memcpy.  See xdr_nfsace_encode().  It's always possible I misunderstood how ACEs are XDR encoded.

We shouldn't ever be memcopying entire structures directly to or from
the XDR buffer, and as far as I know, the current code will always copy
them element by element.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

