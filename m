Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425Ab0HNBcn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 21:32:43 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55534 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277Ab0HNBcm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 21:32:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pu2SFrfP3R+VGquvoOeqXFEx09LUX5T5zdNnpcRKSsSOojxcJsgDA8oPsmLdcIdacU
         8rx1J7oaNPw/C/XOcYfjuVfsO9rFt/BKQw8kYBauGkviYO5CLvGa3+eCRGgjjyO6Dkx5
         z+DdQEGylQ4Dum6nSukf2iSfgwhePEZXpvMFQ=
MIME-Version: 1.0
In-Reply-To: <s5h4oeywrde.wl%tiwai@suse.de>
References: <s5h4oeywrde.wl%tiwai@suse.de>
Date: Sat, 14 Aug 2010 10:32:41 +0900
Message-ID: <AANLkTimh=r57ZJU5KiXganaZhVk18jJE5qm=s+nhpX8v@mail.gmail.com>
Subject: Re: [PATCH] nfsd: fix NULL dereference in nfsd_statfs()
From: Minchan Kim <minchan.kim@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
        Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 13, 2010 at 10:53 PM, Takashi Iwai <tiwai@suse.de> wrote:
> The commit ebabe9a9001af0af56c0c2780ca1576246e7a74b
>    pass a struct path to vfs_statfs
> introduced the struct path initialization, and this seems to trigger
> an Oops on my machine.
>
> fh_dentry field may be NULL and set later in fh_verify(), thus the
> initialization of path must be after fh_verify().
>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Today, I had a same problem on mmotm so I made a similar patch.
Andrew. Please apply this patch on mmotm for smooth testing.


-- 
Kind regards,
Minchan Kim
