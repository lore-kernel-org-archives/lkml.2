Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932788Ab1CIQrc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 11:47:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932371Ab1CIQra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 11:47:30 -0500
Date: Wed, 9 Mar 2011 09:46:58 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
        hch@infradead.org
Subject: Re: [PATCH 10/16] ub: Convert to bdops->check_events()
Message-ID: <20110309094658.29c7fa54@lembas.zaitcev.lan>
In-Reply-To: <1299662016-7721-11-git-send-email-tj@kernel.org>
References: <1299662016-7721-1-git-send-email-tj@kernel.org>
	<1299662016-7721-11-git-send-email-tj@kernel.org>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  9 Mar 2011 10:13:30 +0100
Tejun Heo <tj@kernel.org> wrote:

> +++ b/drivers/block/ub.c
> @@ -1788,7 +1788,8 @@ static int ub_bd_revalidate(struct gendisk *disk)
>   *
>   * The return code is bool!
>   */
> -static int ub_bd_media_changed(struct gendisk *disk)
> +static unsigned int ub_bd_check_events(struct gendisk *disk,
> +				       unsigned int clearing)

> -	return lun->changed;
> +	return lun->changed ? DISK_EVENT_MEDIA_CHANGE : 0;
>  }

Return code is not so bool anymore. The comment meant that usually
"int" means "return 0 on success, -1 on failure, maybe some integer
for a tricky condition" but not here. I'll have the comment fixed up,
or if you want you do it.

-- Pete
