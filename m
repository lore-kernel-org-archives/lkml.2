Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762Ab1CUStx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 14:49:53 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54268 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab1CUStv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 14:49:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NWVIV8har3M2b2i85fRu95i4U6WLKwPI05s3H84R3f+ljmUePHvQcdj/DcCAYGyXXy
         SZu8F09hrVs/9/mUj1WyFef8OeZUaZKv+XojADFLVUNzYB1B1E+Z+CL4ff8r3LjFxKu1
         d+34m+st75jiW+Mh4VGcM0UoMnRHrAYHvOh/E=
MIME-Version: 1.0
In-Reply-To: <1300229605-14499-8-git-send-email-kirill@shutemov.name>
References: <1300229605-14499-1-git-send-email-kirill@shutemov.name>
	<1300229605-14499-8-git-send-email-kirill@shutemov.name>
Date: Mon, 21 Mar 2011 13:49:50 -0500
Message-ID: <AANLkTin6Btn+btgSa1C+kM-7PQ0KTufmPwGZ6UpqLjHR@mail.gmail.com>
Subject: Re: [PATCH 08/13] JFS: use list_move() instead of list_del()/list_add()
 combination
From: Dave Kleikamp <dkleikamp@gmail.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-kernel@vger.kernel.org, jfs-discussion@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 5:53 PM, Kirill A. Shutemov
<kirill@shutemov.name> wrote:
> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>

Acked-by: Dave Kleikamp <shaggy@kernel.org>

> ---
>  fs/jfs/jfs_txnmgr.c |    9 +++------
>  1 files changed, 3 insertions(+), 6 deletions(-)
>
> diff --git a/fs/jfs/jfs_txnmgr.c b/fs/jfs/jfs_txnmgr.c
> index 9466957..8cb7b92 100644
> --- a/fs/jfs/jfs_txnmgr.c
> +++ b/fs/jfs/jfs_txnmgr.c
> @@ -2979,12 +2979,9 @@ int jfs_sync(void *arg)
>                                 * put back on the anon_list.
>                                 */
>
> -                               /* Take off anon_list */
> -                               list_del(&jfs_ip->anon_inode_list);
> -
> -                               /* Put on anon_list2 */
> -                               list_add(&jfs_ip->anon_inode_list,
> -                                        &TxAnchor.anon_list2);
> +                               /* Move anon_list -> anon_list2 */
> +                               list_move(&jfs_ip->anon_inode_list,
> +                                         &TxAnchor.anon_list2);
>
>                                TXN_UNLOCK();
>                                iput(ip);
> --
> 1.7.4.1
>
>
