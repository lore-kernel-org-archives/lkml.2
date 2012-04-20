Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab2DTUho (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 16:37:44 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:45709 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205Ab2DTUhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 16:37:41 -0400
Date: Fri, 20 Apr 2012 15:37:26 -0500
From: Malahal Naineni <malahal@us.ibm.com>
To: Steve Dickson <SteveD@redhat.com>
Cc: Jeff Layton <jlayton@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        miklos@szeredi.hu, viro@ZenIV.linux.org.uk, hch@infradead.org,
        michael.brantley@deshaw.com, sven.breuner@itwm.fraunhofer.de,
        chuck.lever@oracle.com, pstaubach@exagrid.com, bfields@fieldses.org,
        trond.myklebust@fys.uio.no, rees@umich.edu
Subject: Re: [PATCH RFC v3] vfs: make fstatat retry once on ESTALE errors
 from getattr call
Message-ID: <20120420203725.GA3512@us.ibm.com>
Mail-Followup-To: Steve Dickson <SteveD@redhat.com>,
	Jeff Layton <jlayton@redhat.com>, linux-fsdevel@vger.kernel.org,
	linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	miklos@szeredi.hu, viro@ZenIV.linux.org.uk, hch@infradead.org,
	michael.brantley@deshaw.com, sven.breuner@itwm.fraunhofer.de,
	chuck.lever@oracle.com, pstaubach@exagrid.com, bfields@fieldses.org,
	trond.myklebust@fys.uio.no, rees@umich.edu
References: <1334316311-22331-1-git-send-email-jlayton@redhat.com>
 <1334749927-26138-1-git-send-email-jlayton@redhat.com>
 <20120420104055.511e15bc@tlielax.poochiereds.net>
 <4F91C49D.8070908@RedHat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F91C49D.8070908@RedHat.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042020-2398-0000-0000-000005FADF51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steve Dickson [SteveD@redhat.com] wrote:
> > 2) if we assume that it is fairly representative of one, how can we
> > achieve retrying indefinitely with NFS, or at least some large finite
> > amount?
> The amount of looping would be peer speculation. If the problem can
> not be handled by one simple retry I would say we simply pass the
> error up to the app... Its an application issue... 

As someone said, ESTALE is an incorrect errno for a path based call.
How about turning ESTALE into ENOENT after a retry or few retries?

Regards, Malahal.

