Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397Ab1JJAKy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 20:10:54 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:39171 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab1JJAKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 20:10:54 -0400
Subject: Re: [PATCH v9]: Improve performance of LZO/plain hibernation, check
 image with CRC32
From: Bojan Smojver <bojan@rexursive.com>
To: linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Mon, 10 Oct 2011 11:10:52 +1100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1318205452.1991.23.camel@shrek.rexursive.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-10 at 10:53 +1100, Bojan Smojver wrote:
>  static void release_swap_reader(struct swap_map_handle *handle)
>  {
> -       if (handle->cur)
> -               free_page((unsigned long)handle->cur);
> +       struct swap_map_page_list *tmp;
> +
> +       while (handle->maps) {
> +               if (handle->maps->map)
> +                       free_page((unsigned long)handle->maps->map);
> +               tmp = handle->maps;
> +               handle->maps = handle->maps->next;
> +               kfree(tmp);
> +       }
>         handle->cur = NULL;
> +       handle->maps = NULL;
>  } 

Obviously, that handle->maps = NULL is redundant there.

PS. It's funny how errors only become visible once you send them
out. :-)

-- 
Bojan

