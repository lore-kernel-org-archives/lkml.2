Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641Ab1AaLi4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 06:38:56 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:49889 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305Ab1AaLiy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 06:38:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=L3W5zoG5nPymaOYfkqPdA2BO3L6pxmYtNFXn3ghRipOgwv6vkgDBwZJ7bndIbnF73z
         emf7fcY0je/5pPa8LNBK/QLAuQEK0ZCsd7xOBMM1e2j6MtMLoMCAkOLPxV8DSXHkdPIL
         QhMeYB52EKzDuDym/v6kbYEGnCm+5Bxofuh5U=
MIME-Version: 1.0
In-Reply-To: <4D4693CF.9090903@suse.de>
References: <20110131133038.ab3aa826.sfr@canb.auug.org.au>
	<4D4693CF.9090903@suse.de>
Date: Mon, 31 Jan 2011 14:38:52 +0300
Message-ID: <AANLkTikcAEdFLwhcGC8uqRQAYVCCzR4Bz06Qr5ZdvyLd@mail.gmail.com>
Subject: Re: linux-next: build warning after merge of the cifs tree
From: Pavel Shilovsky <piastryyy@gmail.com>
To: Suresh Jayaraman <sjayaraman@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Steve French <smfrench@gmail.com>,
        linux-cifs@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeff Layton <jlayton@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/1/31 Suresh Jayaraman <sjayaraman@suse.de>:
> On 01/31/2011 08:00 AM, Stephen Rothwell wrote:
>> Hi all,
>>
>> After merging the cifs tree, today's linux-next build (powerpc
>> ppc64_defconfig) produced this warning:
>>
>> fs/cifs/file.c: In function 'cifs_iovec_write':
>> fs/cifs/file.c:1740: warning: passing argument 6 of 'CIFSSMBWrite2' from incompatible pointer type
>> fs/cifs/cifsproto.h:343: note: expected 'unsigned int *' but argument is of type 'size_t *'
>>
>> Introduced by commit 72432ffcf555decbbae47f1be338e1d2f210aa69 ("CIFS:
>> Implement cifs_strict_writev (try #4)").
>>
>
> The following patch should silence that warning.
>
> From: Suresh Jayaraman <sjayaraman@suse.de>
> Subject: [PATCH] cifs: fix compiler warning about incompatible pointer type
>
> fs/cifs/file.c: In function ‘cifs_iovec_write’:
> fs/cifs/file.c:1740:9: warning: passing argument 6 of ‘CIFSSMBWrite2’ from incompatible pointer type
> fs/cifs/cifsproto.h:343:12: note: expected ‘unsigned int *’ but argument is of type ‘size_t *’
>
> Cc: Pavel Shilovsky <piastryyy@gmail.com>
> Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
> ---
>  fs/cifs/file.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 0de17c1..2a3c5d8 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -1667,7 +1667,7 @@ static ssize_t
>  cifs_iovec_write(struct file *file, const struct iovec *iov,
>                 unsigned long nr_segs, loff_t *poffset)
>  {
> -       size_t total_written = 0, written = 0;
> +       unsigned int total_written = 0, written = 0;
>        unsigned long num_pages, npages;
>        size_t copied, len, cur_len, i;
>        struct kvec *to_send;
>

I've just noriced another bug: that 'i' variable should be unsigned
long. I will recreate the patch with this fix.

-- 
Best regards,
Pavel Shilovsky.
