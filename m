Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743Ab2HYI7r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 04:59:47 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50633 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab2HYI7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 04:59:38 -0400
Date: Sat, 25 Aug 2012 12:02:31 +0300
From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To: Huang Shijie <shijie8@gmail.com>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, dedekind1@gmail.com
Subject: Re: [PATCH v2] mtd: cmdlinepart: fix the wrong partitions number
 when truncating occurs
Message-ID: <20120825120231.73577d6a@halley>
In-Reply-To: <1345904767-23011-1-git-send-email-shijie8@gmail.com>
References: <1345904767-23011-1-git-send-email-shijie8@gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Huang,

On Sat, 25 Aug 2012 10:26:07 -0400 Huang Shijie <shijie8@gmail.com> wrote:
> diff --git a/drivers/mtd/cmdlinepart.c b/drivers/mtd/cmdlinepart.c
> index 4558e0f..fc960a3 100644
> --- a/drivers/mtd/cmdlinepart.c
> +++ b/drivers/mtd/cmdlinepart.c
> @@ -344,7 +344,8 @@ static int parse_cmdline_partitions(struct mtd_info *master,
>  					       "%s: partitioning exceeds flash size, truncating\n",
>  					       part->mtd_id);
>  					part->parts[i].size = master->size - offset;
> -					part->num_parts = i;
> +					part->num_parts = i + 1;
> +					break;

Your analysis seems right, but let me offer an alternative approach.

I would simply:

-					part->num_parts = i;

(and not replace it with anything).

The specified cmdline partitions might not be ordered (according to
start offset), so next partition specified after the truncated one might
define a partition at the beginning of the device, which is okay
(regardless the truncation of current partition).

Your patch skips the definitions of next partitions, which can be legit.

I agree specifying "unsorted" partitions is not commonly used (and it
might make no sense when using the "remaining" syntax), but it is legit
to define all partitions _explicitly_ with their size@offset in an
unordered fashion.

Regards,
Shmulik
