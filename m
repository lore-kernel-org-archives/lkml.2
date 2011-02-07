Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab1BGPCQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 10:02:16 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44877 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab1BGPCM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 10:02:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jk51u2HBtxWd86ZaSL8cECTnzjIlqhjzjeKuM2tY4z2R13JjLW3QNN2ooARnCmEckv
         n0bvmZFrt2xOC868Lt330fTDb17ZzpI2t4luNe3MJLoAUwbT/ijOs5IDk83viladSN2S
         6ukki6NxlnKTSKF83kHDK4RHeNbDO9u3HAp/o=
MIME-Version: 1.0
In-Reply-To: <1296928005-9529-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1296928005-9529-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1296928005-9529-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Date: Mon, 7 Feb 2011 09:02:11 -0600
Message-ID: <AANLkTimJS5Y11HD=hbg3gtXpwR+ddwQpRSLm-i8inDbY@mail.gmail.com>
Subject: Re: [V9fs-developer] [RFC PATCH -V2 01/17] fs/9p: set the cached
 file_operations struct during inode init
From: Eric Van Hensbergen <ericvh@gmail.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: v9fs-developer@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 5, 2011 at 11:46 AM, Aneesh Kumar K.V
<aneesh.kumar@linux.vnet.ibm.com> wrote:

>  /**
>  * v9fs_file_open - open a file (or directory)
>  * @inode: inode to be opened
> @@ -89,19 +86,12 @@ int v9fs_file_open(struct inode *inode, struct file *file)
>        }
>
>        file->private_data = fid;
> +#ifdef CONFIG_9P_FSCACHE
>        if ((fid->qid.version) && (v9ses->cache)) {
>                P9_DPRINTK(P9_DEBUG_VFS, "cached");
> -               /* enable cached file options */
> -               if(file->f_op == &v9fs_file_operations)
> -                       file->f_op = &v9fs_cached_file_operations;
> -               else if (file->f_op == &v9fs_file_operations_dotl)
> -                       file->f_op = &v9fs_cached_file_operations_dotl;
> -
> -#ifdef CONFIG_9P_FSCACHE
>                v9fs_cache_inode_set_cookie(inode, file);
> -#endif
>        }
> -
> +#endif
>        return 0;
>  }

Doesn't this conditionalize all cached operations on FSCACHE operation?
What if we want loose cache policy without FSCACHE?

     -eric
