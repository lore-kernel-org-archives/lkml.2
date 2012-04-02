Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab2DBRHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 13:07:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63728 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731Ab2DBRHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 13:07:05 -0400
Date: Mon, 2 Apr 2012 13:07:05 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>, David Howells <dhowells@redhat.com>
Cc: jmorris@namei.org, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org, linux-kernel@vger.kernel.org
Subject: Re: [Keyrings] [PATCH 2/9] keys: update the description with info
 about "logon" keys
Message-ID: <20120402130705.285e5dc0@corrin.poochiereds.net>
In-Reply-To: <1332934098.2297.11.camel@falcor>
References: <20120328104607.10417.85745.stgit@warthog.procyon.org.uk>
	<20120328104619.10417.78851.stgit@warthog.procyon.org.uk>
	<1332934098.2297.11.camel@falcor>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2012 07:28:18 -0400
Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> On Wed, 2012-03-28 at 11:46 +0100, David Howells wrote:
> > From: Jeff Layton <jlayton@redhat.com>
> > 
> > Signed-off-by: Jeff Layton <jlayton@redhat.com>
> > Signed-off-by: David Howells <dhowells@redhat.com>
> > ---
> > 
> >  Documentation/security/keys.txt |   15 ++++++++++++++-
> >  1 files changed, 14 insertions(+), 1 deletions(-)
> > 
> > diff --git a/Documentation/security/keys.txt b/Documentation/security/keys.txt
> > index 7877170..4c8cf36 100644
> > --- a/Documentation/security/keys.txt
> > +++ b/Documentation/security/keys.txt
> > @@ -123,7 +123,7 @@ KEY SERVICE OVERVIEW
> > 
> >  The key service provides a number of features besides keys:
> > 
> > - (*) The key service defines two special key types:
> > + (*) The key service defines three special key types:
> > 
> >       (+) "keyring"
> > 
> > @@ -137,6 +137,19 @@ The key service provides a number of features besides keys:
> >  	 blobs of data. These can be created, updated and read by userspace,
> >  	 and aren't intended for use by kernel services.
> > 
> > +     (+) "logon"
> > +
> > +         Like a "user" key, a "logon" key has a payload that is an arbitrary
> > +         blob of data. It is intended as a place to store secrets that the
> > +         to which the kernel should have access but that should not be
> > +         accessable from userspace.
> 
> The last sentence is a bit awkward.  Can we rephrase it a bit?  Maybe
> "which is accessible by the kernel, ..."?
> 
> thanks,
> 
> Mimi
> 

Sorry for the late response. I somehow missed this email a few days
ago. I can reword it to make it a bit clearer. David, should I send a
respin of this patch or a new one on top of this one?

> > +
> > +         The description can be arbitrary, but must be prefixed with a non-zero
> > +         length string that describes the key "subclass". The subclass is
> > +         separated from the rest of the description by a ':'. "logon" keys can
> > +         be created and updated by userspace, but the payload is only readable
> > +         from kernel space.
> > +
> >   (*) Each process subscribes to three keyrings: a thread-specific keyring, a
> >       process-specific keyring, and a session-specific keyring.
> 
> 
> 


-- 
Jeff Layton <jlayton@redhat.com>
