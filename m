Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461Ab1BHIsD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 03:48:03 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:50248 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab1BHIsB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 03:48:01 -0500
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: v9fs-developer@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [V9fs-developer] [RFC PATCH -V2 01/17] fs/9p: set the cached file_operations struct during inode init
In-Reply-To: <AANLkTimJS5Y11HD=hbg3gtXpwR+ddwQpRSLm-i8inDbY@mail.gmail.com>
References: <1296928005-9529-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1296928005-9529-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <AANLkTimJS5Y11HD=hbg3gtXpwR+ddwQpRSLm-i8inDbY@mail.gmail.com>
User-Agent: Notmuch/0.5-64-gc3ae51d (http://notmuchmail.org) Emacs/23.1.1 (i486-pc-linux-gnu)
Date: Tue, 08 Feb 2011 14:17:54 +0530
Message-ID: <87zkq6hpz9.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Feb 2011 09:02:11 -0600, Eric Van Hensbergen <ericvh@gmail.com> wrote:
> On Sat, Feb 5, 2011 at 11:46 AM, Aneesh Kumar K.V
> <aneesh.kumar@linux.vnet.ibm.com> wrote:
> 
> >  /**
> >  * v9fs_file_open - open a file (or directory)
> >  * @inode: inode to be opened
> > @@ -89,19 +86,12 @@ int v9fs_file_open(struct inode *inode, struct file *file)
> >        }
> >
> >        file->private_data = fid;
> > +#ifdef CONFIG_9P_FSCACHE
> >        if ((fid->qid.version) && (v9ses->cache)) {
> >                P9_DPRINTK(P9_DEBUG_VFS, "cached");
> > -               /* enable cached file options */
> > -               if(file->f_op == &v9fs_file_operations)
> > -                       file->f_op = &v9fs_cached_file_operations;
> > -               else if (file->f_op == &v9fs_file_operations_dotl)
> > -                       file->f_op = &v9fs_cached_file_operations_dotl;
> > -
> > -#ifdef CONFIG_9P_FSCACHE
> >                v9fs_cache_inode_set_cookie(inode, file);
> > -#endif
> >        }
> > -
> > +#endif
> >        return 0;
> >  }
> 
> Doesn't this conditionalize all cached operations on FSCACHE operation?
> What if we want loose cache policy without FSCACHE?
> 

we set file_operations is set in inode init now. The only remaining part 
is v9fs_cache_inode_set_cookie which is FSCACHE specific

-aneesh
