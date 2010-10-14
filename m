Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928Ab0JNSXa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 14:23:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2046 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755633Ab0JNSX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 14:23:29 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Edward Shishkin <edward.shishkin@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
        Eric Sandeen <sandeen@redhat.com>, lmcilroy@redhat.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/2] vfs: fix overflow in direct-io subsystem
References: <201010132245.57467.edward.shishkin@gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 14 Oct 2010 14:20:23 -0400
In-Reply-To: <201010132245.57467.edward.shishkin@gmail.com> (Edward Shishkin's
	message of "Wed, 13 Oct 2010 22:45:57 +0200")
Message-ID: <x4962x41vrs.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Edward Shishkin <edward.shishkin@gmail.com> writes:

> Fix up overflow (ssize_t->int) in the direct-io subsystem.
>
> Signed-off-by: Edward Shishkin <edward@redhat.com>
> ---
>  fs/direct-io.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- linux-2.6.36-rc7.orig/fs/direct-io.c
> +++ linux-2.6.36-rc7/fs/direct-io.c
> @@ -218,7 +218,7 @@ static struct page *dio_get_page(struct 
>   * filesystems can use it to hold additional state between get_block calls and
>   * dio_complete.
>   */
> -static int dio_complete(struct dio *dio, loff_t offset, int ret, bool is_async)
> +static ssize_t dio_complete(struct dio *dio, loff_t offset, ssize_t ret, bool is_async)
>  {
>  	ssize_t transferred = 0;

Acked-by: Jeff Moyer <jmoyer@redhat.com>
