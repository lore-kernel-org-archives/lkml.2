Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750932Ab1HLEJB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 00:09:01 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:54058 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726Ab1HLEI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 00:08:59 -0400
Subject: Re: [PATCH 1/2] evm: building without EVM enabled fixes
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-security-module@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <20110812125234.bb689ec3cd29f2ac48f3453d@canb.auug.org.au>
References: <1313036572-27122-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <20110812125234.bb689ec3cd29f2ac48f3453d@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Aug 2011 00:08:28 -0400
Message-ID: <1313122108.3228.22.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-12 at 12:52 +1000, Stephen Rothwell wrote:
> Hi Mimi,
> 
> On Thu, 11 Aug 2011 00:22:51 -0400 Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> >
> > - Missing 'inline' on evm_inode_setattr() definition.
> > Introduced by commit 817b54aa45db ("evm: add evm_inode_setattr to prevent
> > updating an invalid security.evm").
> > 
> > - Missing security_old_inode_init_security() stub function definition.
> > Caused by commit 9d8f13ba3f48 ("security: new security_inode_init_security
> > API adds function callback").
> > 
> > Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> > ---
> >  include/linux/evm.h      |    2 +-
> >  include/linux/security.h |    7 +++++++
> >  2 files changed, 8 insertions(+), 1 deletions(-)
> > 
> > diff --git a/include/linux/evm.h b/include/linux/evm.h
> > index db5556d..62deb65 100644
> > --- a/include/linux/evm.h
> > +++ b/include/linux/evm.h
> > @@ -45,7 +45,7 @@ static inline enum integrity_status evm_verifyxattr(struct dentry *dentry,
> >  }
> >  #endif
> >  
> > -static int evm_inode_setattr(struct dentry *dentry, struct iattr *attr)
> > +static inline int evm_inode_setattr(struct dentry *dentry, struct iattr *attr)
> >  {
> >  	return 0;
> >  }
> > diff --git a/include/linux/security.h b/include/linux/security.h
> > index 1c528b1..f399cf1 100644
> > --- a/include/linux/security.h
> > +++ b/include/linux/security.h
> > @@ -2048,6 +2048,13 @@ static inline int security_inode_init_security(struct inode *inode,
> >  	return -EOPNOTSUPP;
> >  }
> >  
> > +int security_old_inode_init_security(struct inode *inode, struct inode *dir,
> > +				     const struct qstr *qstr, char **name,
> > +				     void **value, size_t *len)
> > +{
> > +	return -EOPNOTSUPP;
> > +}
> > +
> 
> These stub functions *must* be "staic inline" (see my build report on
> linux-next) just like the one you fixed above.
> 
> Good plan:  if you introduce a function whose existance (or behaviour)
> depends on a CONFIG option, then build test with and without that CONFIG
> option set.

I really did rebuild and test without EVM enabled.  sigh, it would have
helped to also configure the filesystems which use the stub function.

Mimi



