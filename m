Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034Ab0EMIKN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 04:10:13 -0400
Received: from cantor.suse.de ([195.135.220.2]:39664 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785Ab0EMIKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 04:10:09 -0400
Date: Thu, 13 May 2010 18:09:53 +1000
From: Neil Brown <neilb@suse.de>
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, linux-fsdevel@vger.kernel.org,
       sfrench@us.ibm.com, philippe.deniel@CEA.FR,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V7 5/9] vfs: Add freadlink syscall
Message-ID: <20100513180953.127df6c2@notabene.brown>
In-Reply-To: <87mxw41chx.fsf@linux.vnet.ibm.com>
References: <1273679444-14903-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1273679444-14903-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<20100513114351.793caf70@notabene.brown>
	<87vdas1fnv.fsf@linux.vnet.ibm.com>
	<20100513165606.4bf57bd6@notabene.brown>
	<87mxw41chx.fsf@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 May 2010 13:04:18 +0530
"Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com> wrote:

> On Thu, 13 May 2010 16:56:06 +1000, Neil Brown <neilb@suse.de> wrote:
> > On Thu, 13 May 2010 11:55:56 +0530
> > "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> > 
> > > On Thu, 13 May 2010 11:43:51 +1000, Neil Brown <neilb@suse.de> wrote:
> > > > On Wed, 12 May 2010 21:20:40 +0530
> > > > "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> > > > 
> > > > > This enables to use open-by-handle and then get the link target
> > > > > details of a symlink using the fd returned by handle
> > > > > 
> > > > 
> > > > 
> > > > I find it very frustrating that a new syscall seems to be needed here.
> > > > We have 'readlinkat', and it should be enough.
> > > > How:  the 'dfd' has to be a 'directory', and the path name as to be non-empty.
> > > > 
> > > > The following patch allows 'path' to be NULL and in that case 'dfd' to be a
> > > > non-directory.  This allows readlinkat and faccessat (and probably others)
> > > > to be used on an fd with not following path name.
> > > > 
> > > > What do people think of this alternative?
> > > > 
> > > 
> > > I will add this in the next iteration and drop the freadlink syscall.
> > > 
> > 
> > I wouldn't be quite that hasty.  It was only a proposal.  It might not be
> > appropriate to change all those syscalls..
> > 
> > An alternative that I don't think is a nice, but is a lot 'safer' is
> > to just change readlinkat to accept a NULL path:
> 
> That would mean only readlinkat now have a special case of accepting NULL path
> and  dirfd can point to objects other than directory. So from the
> interface point of having the special case is confusing. But if you feel
> strong enough to drop freadlink syscall i can do that. Just not sure
> whether special case for only readlinkat is the right way considering we
> have  fstat/fchwon type calls for other file system operations.
> 
>

Not completely a special case.  I modelled this code on utimesat.

NeilBrown

