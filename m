Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab1D1IIm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 04:08:42 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:59161 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755072Ab1D1IIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 04:08:30 -0400
X-Sasl-enc: hQWlsyYuf9U3/I3BFHXjgqe7QDog8VXKB7VbzU+q7piX 1303978109
From: Roberto Sassu <roberto.sassu@polito.it>
Organization: Politecnico di Torino
To: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [RFC][PATCH 3/7] smack: assign the label set in file->f_cred to new file descriptors
Date: Thu, 28 Apr 2011 10:06:05 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.35.12-88.fc14.x86_64; KDE/4.6.2; x86_64; ; )
Cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, dhowells@redhat.com, jmorris@namei.org,
        zohar@linux.vnet.ibm.com, safford@watson.ibm.com,
        tyhicks@linux.vnet.ibm.com, kirkland@canonical.com,
        ecryptfs-devel@lists.launchpad.net, eparis@redhat.com,
        sds@tycho.nsa.gov, selinux@tycho.nsa.gov, viro@zeniv.linux.org.uk
References: <1303907657-18366-1-git-send-email-roberto.sassu@polito.it> <1303907657-18366-4-git-send-email-roberto.sassu@polito.it> <4DB8A633.6080102@schaufler-ca.com>
In-Reply-To: <4DB8A633.6080102@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104281006.05629.roberto.sassu@polito.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 28, 2011 01:26:43 AM Casey Schaufler wrote:
> On 4/27/2011 5:34 AM, Roberto Sassu wrote:
> > The SMACK label of new file descriptors is obtained from the credentials
> > set in the 'f_cred' field of the same structure.
> >
> > Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
> > ---
> >  security/smack/smack_lsm.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> > index c6f8fca..e3c9e54 100644
> > --- a/security/smack/smack_lsm.c
> > +++ b/security/smack/smack_lsm.c
> > @@ -1011,7 +1011,7 @@ static int smack_file_permission(struct file *file, int mask)
> >   */
> >  static int smack_file_alloc_security(struct file *file)
> >  {
> > -	file->f_security = smk_of_current();
> > +	file->f_security = smk_of_task(file->f_cred->security);
> 
> Now hang on. This just looks wrong. You're setting the value of one
> field of the file structure to another value in the same file structure.
> I don't see that this is what I want.
> 

Hi Casey

thanks for the review.
The field 'f_cred' stores the credentials of the subject that issued the open.
The first patch allows to set this field with the credentials provided to
the function get_empty_filp() which may be those of the 'current'
process as in the original case, or those provided by a kernel service that
called the function dentry_open() directly.

Roberto Sassu


> >  	return 0;
> >  }
> >  
> 
> 
