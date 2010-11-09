Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab0KIKFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 05:05:39 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42341 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684Ab0KIKFh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 05:05:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WAkjS6+jG0jUXMMD1xGVCs10Qz2pUf7CCyxb0oz/Wixuy/ntV0KBn9Kej+d2Pr/2QZ
         SKBsu0Sg1LuqpamKbWAixMBzU82eehPD18gOSqdhAUdt7otribhNc31LNt5vlfuMuBQy
         tUxGje2T/w2THha0DbVdyoNbvYNvThK8iRUkM=
MIME-Version: 1.0
In-Reply-To: <1289248327-16308-5-git-send-email-josef@redhat.com>
References: <1289248327-16308-1-git-send-email-josef@redhat.com>
	<1289248327-16308-5-git-send-email-josef@redhat.com>
Date: Tue, 9 Nov 2010 10:05:34 +0000
Message-ID: <AANLkTiksTsZqo1yUNVEJSiwE-7ccyWDv+wLvTZaoZOJ0@mail.gmail.com>
Subject: Re: [PATCH 5/6] Btrfs: fail if we try to use hole punch
From: Will Newton <will.newton@gmail.com>
To: Josef Bacik <josef@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        xfs@oss.sgi.com, joel.becker@oracle.com, cmm@us.ibm.com,
        cluster-devel@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 8, 2010 at 8:32 PM, Josef Bacik <josef@redhat.com> wrote:

Hi Josef,

> Btrfs doesn't have the ability to punch holes yet, so make sure we return
> EOPNOTSUPP if we try to use hole punching through fallocate.  This support can
> be added later.  Thanks,
>
> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
>  fs/btrfs/inode.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 78877d7..c590add 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -6936,6 +6936,10 @@ static long btrfs_fallocate(struct inode *inode, int mode,
>        alloc_start = offset & ~mask;
>        alloc_end =  (offset + len + mask) & ~mask;
>
> +       /* We only support the FALLOC_FL_KEEP_SIZE mode */
> +       if (mode && (mode & FALLOC_FL_KEEP_SIZE))
> +               return -EOPNOTSUPP;
> +

This test looks rather odd. Why do we need to test that mode is
non-zero AND that mode has a specific bit set? Is there a missing !
here?
