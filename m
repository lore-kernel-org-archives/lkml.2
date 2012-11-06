Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab2KFXYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 18:24:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39972 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520Ab2KFXY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 18:24:28 -0500
Date: Tue, 6 Nov 2012 15:24:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.de>, Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <axboe@kernel.dk>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v4 3/6] block/genhd.c: apply
 pm_runtime_set_memalloc_noio on block devices
Message-Id: <20121106152427.dfde4c52.akpm@linux-foundation.org>
In-Reply-To: <1351931714-11689-4-git-send-email-ming.lei@canonical.com>
References: <1351931714-11689-1-git-send-email-ming.lei@canonical.com>
	<1351931714-11689-4-git-send-email-ming.lei@canonical.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  3 Nov 2012 16:35:11 +0800
Ming Lei <ming.lei@canonical.com> wrote:

> This patch applyes the introduced pm_runtime_set_memalloc_noio on
> block device so that PM core will teach mm to not allocate memory with
> GFP_IOFS when calling the runtime_resume and runtime_suspend callback
> for block devices and its ancestors.
> 
> ...
>
> @@ -532,6 +533,13 @@ static void register_disk(struct gendisk *disk)
>  			return;
>  		}
>  	}
> +
> +	/* avoid probable deadlock caused by allocating memory with

Again, please fix the comment style.  Take a look at the rest of this file!

> +	 * GFP_KERNEL in runtime_resume callback of its all ancestor
> +	 * deivces

typo

> +	 */

