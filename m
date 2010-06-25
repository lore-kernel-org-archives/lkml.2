Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab0FYLPQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 07:15:16 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:41999 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753932Ab0FYLPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 07:15:13 -0400
Subject: Re: [PATCH 02/15] security: move LSM xattrnames to xattr.h
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <4C242745.6050801@schaufler-ca.com>
References: <1277403031-3080-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <1277403031-3080-3-git-send-email-zohar@linux.vnet.ibm.com>
	 <4C242745.6050801@schaufler-ca.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Jun 2010 07:15:06 -0400
Message-ID: <1277464506.3220.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-24 at 20:49 -0700, Casey Schaufler wrote: 
> Mimi Zohar wrote:
> > Make the security extended attributes names global.
> >
> > Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> > Acked-by: Serge Hallyn <serue@us.ibm.com>
> > ---
> >  include/linux/capability.h |    3 ---
> >  include/linux/xattr.h      |   10 ++++++++++
> >  security/selinux/hooks.c   |    3 ---
> >  security/smack/smack.h     |    2 --
> >  4 files changed, 10 insertions(+), 8 deletions(-)
> >
> > diff --git a/include/linux/capability.h b/include/linux/capability.h
> > index 39e5ff5..90012b9 100644
> > --- a/include/linux/capability.h
> > +++ b/include/linux/capability.h
> > @@ -49,9 +49,6 @@ typedef struct __user_cap_data_struct {
> >  } __user *cap_user_data_t;
> >  
> >  
> > -#define XATTR_CAPS_SUFFIX "capability"
> > -#define XATTR_NAME_CAPS XATTR_SECURITY_PREFIX XATTR_CAPS_SUFFIX
> > -
> >  #define VFS_CAP_REVISION_MASK	0xFF000000
> >  #define VFS_CAP_REVISION_SHIFT	24
> >  #define VFS_CAP_FLAGS_MASK	~VFS_CAP_REVISION_MASK
> > diff --git a/include/linux/xattr.h b/include/linux/xattr.h
> > index 0cfa1e9..62ca853 100644
> > --- a/include/linux/xattr.h
> > +++ b/include/linux/xattr.h
> > @@ -33,6 +33,16 @@
> >  #define XATTR_USER_PREFIX "user."
> >  #define XATTR_USER_PREFIX_LEN (sizeof (XATTR_USER_PREFIX) - 1)
> >  
> > +/* Security namespace */
> > +#define XATTR_SELINUX_SUFFIX "selinux"
> > +#define XATTR_NAME_SELINUX XATTR_SECURITY_PREFIX XATTR_SELINUX_SUFFIX
> > +
> > +#define XATTR_SMACK_SUFFIX "SMACK64"
> > +#define XATTR_NAME_SMACK XATTR_SECURITY_PREFIX XATTR_SMACK_SUFFIX
> > +
> > +#define XATTR_CAPS_SUFFIX "capability"
> > +#define XATTR_NAME_CAPS XATTR_SECURITY_PREFIX XATTR_CAPS_SUFFIX
> > +
> >  struct inode;
> >  struct dentry;
> >  
> > diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> > index 0f524b7..85338f0 100644
> > --- a/security/selinux/hooks.c
> > +++ b/security/selinux/hooks.c
> > @@ -87,9 +87,6 @@
> >  #include "netlabel.h"
> >  #include "audit.h"
> >  
> > -#define XATTR_SELINUX_SUFFIX "selinux"
> > -#define XATTR_NAME_SELINUX XATTR_SECURITY_PREFIX XATTR_SELINUX_SUFFIX
> > -
> >  #define NUM_SEL_MNT_OPTS 5
> >  
> >  extern int selinux_nlmsg_lookup(u16 sclass, u16 nlmsg_type, u32 *perm);
> > diff --git a/security/smack/smack.h b/security/smack/smack.h
> > index c6e9aca..9c773e3 100644
> > --- a/security/smack/smack.h
> > +++ b/security/smack/smack.h
> > @@ -126,10 +126,8 @@ struct smack_known {
> >  /*
> >   * xattr names
> >   */
> > -#define XATTR_SMACK_SUFFIX	"SMACK64"
> >  #define XATTR_SMACK_IPIN	"SMACK64IPIN"
> >  #define XATTR_SMACK_IPOUT	"SMACK64IPOUT"
> > -#define XATTR_NAME_SMACK	XATTR_SECURITY_PREFIX XATTR_SMACK_SUFFIX
> >  #define XATTR_NAME_SMACKIPIN	XATTR_SECURITY_PREFIX XATTR_SMACK_IPIN
> >  #define XATTR_NAME_SMACKIPOUT	XATTR_SECURITY_PREFIX XATTR_SMACK_IPOUT
> >   
> 
> Why just the SMACK64 attribute name, and not the others? They are
> manipulated with the same interfaces (well, fsetxattr, fgetxattr)
> as the SMACK64 attribute. There isn't any conceptual difference and
> the rationale for moving attribute names really ought to apply to
> them as well.

Hi Casey,

Moving the other SMACK xattrs is fine, but are they used on persistent
files and need to be EVM protected?

Mimi

