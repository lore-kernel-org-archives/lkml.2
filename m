Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435Ab1GYNZn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 09:25:43 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35627 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab1GYNZl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 09:25:41 -0400
MIME-Version: 1.0
In-Reply-To: <4E2D6961.9000909@gmail.com>
References: <4E2D6961.9000909@gmail.com>
Date: Mon, 25 Jul 2011 16:25:39 +0300
Message-ID: <CAOQ4uxhGceySNm7-d=NdjPVZDsb4Pi8Gobf145zdDomZqhJCyQ@mail.gmail.com>
Subject: Re: [PATCH] jbd: change the field "b_cow_tid" of struct journal_head
 from type unsigned to tid_t
From: Amir Goldstein <amir73il@gmail.com>
To: Wang Sheng-Hui <shhuiw@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 4:02 PM, Wang Sheng-Hui <shhuiw@gmail.com> wrote:
> The patch is against 3.0
>
> In the definition of struct journal_head, the comment for
> the field "unsigned b_cow_tid" says the field tracks the
> last transaction id in which this buffer has been cowed.
>
> In the header part of file journal-head.h, it defines
>   typedef unsigned int  tid_t;
> We should use type tid_t to define transaction id fields.
>
> Change the field "b_cow_tid" of struct journal_head from
> type unsigned to tid_t.
>
> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>

my bad.

Acked-by: Amir Goldstein <amir73il@users.sf.net>

> ---
>  include/linux/journal-head.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/include/linux/journal-head.h b/include/linux/journal-head.h
> index 44e95d0..423cb6d 100644
> --- a/include/linux/journal-head.h
> +++ b/include/linux/journal-head.h
> @@ -45,7 +45,7 @@ struct journal_head {
>         * has been cowed
>         * [jbd_lock_bh_state()]
>         */
> -       unsigned b_cow_tid;
> +       tid_t b_cow_tid;
>
>        /*
>         * Copy of the buffer data frozen for writing to the log.
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
