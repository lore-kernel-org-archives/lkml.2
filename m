Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150Ab0EMHea (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 03:34:30 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:57506 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675Ab0EMHe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 03:34:28 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Neil Brown <neilb@suse.de>
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, linux-fsdevel@vger.kernel.org,
       sfrench@us.ibm.com, philippe.deniel@CEA.FR,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V7 5/9] vfs: Add freadlink syscall
In-Reply-To: <20100513165606.4bf57bd6@notabene.brown>
References: <1273679444-14903-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1273679444-14903-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20100513114351.793caf70@notabene.brown> <87vdas1fnv.fsf@linux.vnet.ibm.com> <20100513165606.4bf57bd6@notabene.brown>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Thu, 13 May 2010 13:04:18 +0530
Message-ID: <87mxw41chx.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 May 2010 16:56:06 +1000, Neil Brown <neilb@suse.de> wrote:
> On Thu, 13 May 2010 11:55:56 +0530
> "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> 
> > On Thu, 13 May 2010 11:43:51 +1000, Neil Brown <neilb@suse.de> wrote:
> > > On Wed, 12 May 2010 21:20:40 +0530
> > > "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> > > 
> > > > This enables to use open-by-handle and then get the link target
> > > > details of a symlink using the fd returned by handle
> > > > 
> > > 
> > > 
> > > I find it very frustrating that a new syscall seems to be needed here.
> > > We have 'readlinkat', and it should be enough.
> > > How:  the 'dfd' has to be a 'directory', and the path name as to be non-empty.
> > > 
> > > The following patch allows 'path' to be NULL and in that case 'dfd' to be a
> > > non-directory.  This allows readlinkat and faccessat (and probably others)
> > > to be used on an fd with not following path name.
> > > 
> > > What do people think of this alternative?
> > > 
> > 
> > I will add this in the next iteration and drop the freadlink syscall.
> > 
> 
> I wouldn't be quite that hasty.  It was only a proposal.  It might not be
> appropriate to change all those syscalls..
> 
> An alternative that I don't think is a nice, but is a lot 'safer' is
> to just change readlinkat to accept a NULL path:

That would mean only readlinkat now have a special case of accepting NULL path
and  dirfd can point to objects other than directory. So from the
interface point of having the special case is confusing. But if you feel
strong enough to drop freadlink syscall i can do that. Just not sure
whether special case for only readlinkat is the right way considering we
have  fstat/fchwon type calls for other file system operations.


-aneesh
