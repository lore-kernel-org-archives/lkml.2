Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759021Ab0GAVZs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:25:48 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:60725 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933230Ab0GAVP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:15:59 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Neil Brown <neilb@suse.de>
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, hooanon05@yahoo.co.jp,
       bfields@fieldses.org, linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
       philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V14 0/11] Generic name to handle and open by handle syscalls
In-Reply-To: <20100702064108.64034561@notabene.brown>
References: <1276621981-2774-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <871vbn2mk9.fsf@linux.vnet.ibm.com> <20100702064108.64034561@notabene.brown>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Fri, 02 Jul 2010 02:45:45 +0530
Message-ID: <87iq4y29a6.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Jul 2010 06:41:08 +1000, Neil Brown <neilb@suse.de> wrote:
> On Thu, 01 Jul 2010 21:58:54 +0530
> "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> 
> > On Tue, 15 Jun 2010 22:42:50 +0530, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> > 
> > Hi Al,
> > 
> > Any chance of getting this reviewed/merged in the next merge window ?
> 
>  My own opinion of the patchset is that the code itself is fine,
>  however there is one part of the interface that bothers me.
> 
>  I think that it is a little ugly that filesystem uuid extraction is so
>  closely tied to filehandle manipulation.  They are certainly related, and we
>  certainly need to be able to get the filesystem uuid directly from the
>  filesystem, but given that filehandle -> fd mapping doesn't (and shouldn't)
>  use the uuid, the fact that fd/name -> filehandle mapping does return the
>  uuid looks like it is simply piggy backing some functionality on the side,
>  rather than creating a properly designed and general interface.
> 
>  I would feel happier about the patches if you removed all reference to uuids
>  and then found some other way to ask a filesystem what its uuid was.
> 
>  This is not an issue that would make be want to stop the patches going
>  upstream, but it does hold me back from offering a reviewed-by or
>  acked-by (for whatever they might be worth).
> 

One use case i had was that if the userspace file server can directly work
with the returned file system UUID, the it can build the file handle for client
in a single call.


-aneesh
