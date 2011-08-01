Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403Ab1HALb3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 07:31:29 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:59450 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751937Ab1HALbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 07:31:24 -0400
X-Sasl-enc: +Lnk/auY+tTol8O5Xdt07z5CFhyJX0+98Mp+QV0/WC59 1312198282
From: Roberto Sassu <roberto.sassu@polito.it>
To: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Subject: Re: [PATCH] eCryptfs: fix compile error
Date: Mon, 1 Aug 2011 13:31:11 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38.8-35.fc15.x86_64; KDE/4.6.5; x86_64; ; )
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        kirkland@canonical.com, ecryptfs-devel@lists.launchpad.net,
        hilld@binarystorm.net
References: <1311958266-3724-1-git-send-email-roberto.sassu@polito.it> <20110729170932.GC29604@boyd.l.tihix.com>
In-Reply-To: <20110729170932.GC29604@boyd.l.tihix.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108011331.11454.roberto.sassu@polito.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 29, 2011 07:09:32 PM Tyler Hicks wrote:
> On Fri Jul 29, 2011 at 06:51:04PM +0200, Roberto Sassu 
<roberto.sassu@polito.it> wrote:
> > This patch fixes the compile error reported at the address:
> > 
> > https://bugzilla.kernel.org/show_bug.cgi?id=40292
> > 
> > The problem arises when compiling eCryptfs as built-in and the
> > 'encrypted' key type as a module. The patch enables the 'encrypted' key
> > type support for eCryptfs only when both components are compiled as
> > built-in, both as modules or eCryptfs as a module and the 'encrypted'
> > key type as built-in.
> > 
> > Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
> > Reported-by: David Hill <hilld@binarystorm.net>
> > ---
> > 
> >  fs/ecryptfs/ecryptfs_kernel.h |    4 +++-
> >  1 files changed, 3 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/ecryptfs/ecryptfs_kernel.h
> > b/fs/ecryptfs/ecryptfs_kernel.h index b36c557..a2da660 100644
> > --- a/fs/ecryptfs/ecryptfs_kernel.h
> > +++ b/fs/ecryptfs/ecryptfs_kernel.h
> > @@ -79,7 +79,9 @@ struct ecryptfs_page_crypt_context {
> > 
> >  	} param;
> >  
> >  };
> > 
> > -#if defined(CONFIG_ENCRYPTED_KEYS) ||
> > defined(CONFIG_ENCRYPTED_KEYS_MODULE) +#if (defined(CONFIG_ECRYPT_FS) &&
> > defined(CONFIG_ENCRYPTED_KEYS)) || \ +	(defined(CONFIG_ECRYPT_FS_MODULE)
> > && \
> > +	(defined(CONFIG_ENCRYPTED_KEYS) ||
> > defined(CONFIG_ENCRYPTED_KEYS_MODULE)))
> 
> Thanks for the patch, Roberto.
> 
> Shouldn't this be handled in the Kconfig? It seems like it would be
> better to force the encrypted key type to be built-in if eCryptfs is
> configured to be built-in.
> 
> With this patch, a user could have CONFIG_ENCRYPTED_KEYS=m and
> CONFIG_ECRYPT_FS=y, but still hit potentially confusing error conditions
> when trying to use encrypted key support with eCryptfs.
> 

Hi Tyler

thanks for comments. I'm posting the new version
of the patch which modifies only the Kconfig file of
eCryptfs.

Roberto Sassu


> Tyler
> 
> >  static inline struct ecryptfs_auth_tok *
> >  ecryptfs_get_encrypted_key_payload_data(struct key *key)
> >  {
