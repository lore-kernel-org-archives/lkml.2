Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460Ab0DTM32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 08:29:28 -0400
Received: from mx2.netapp.com ([216.240.18.37]:19956 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753953Ab0DTM30 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 08:29:26 -0400
X-IronPort-AV: E=Sophos;i="4.52,243,1270450800"; 
   d="scan'208";a="347236817"
Subject: Re: RCU-isms in fs/nfs/delegation.c
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: David Howells <dhowells@redhat.com>
Cc: paulmck@linux.vnet.ibm.com, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <32174.1271753314@redhat.com>
References: <1271698361.13653.79.camel@localhost.localdomain>
	 <14317.1271691185@redhat.com>  <32174.1271753314@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp
Date: Tue, 20 Apr 2010 08:29:06 -0400
Message-ID: <1271766546.25129.76.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
X-OriginalArrivalTime: 20 Apr 2010 12:29:07.0608 (UTC) FILETIME=[12517180:01CAE085]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-20 at 09:48 +0100, David Howells wrote: 
> Trond Myklebust <Trond.Myklebust@netapp.com> wrote:
> 
> > +		nfs_inode_set_delegation(inode, cred, res);
> > +	}
> > +out:
> > +	rcu_read_unlock();
> >  }
> 
> I think this is wrong.  nfs_inode_set_delegation() may sleep as it calls
> kmalloc() with GFP_KERNEL - but you still have the RCU read lock held.  I
> think you need to drop the RCU read lock before calling it.
> 
> David

Agreed. Thanks for the review...

Cheers
  Trond
