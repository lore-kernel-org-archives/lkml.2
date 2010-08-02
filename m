Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab0HBQKp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 12:10:45 -0400
Received: from sh.osrg.net ([192.16.179.4]:43700 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753991Ab0HBQKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 12:10:42 -0400
Date: Tue, 3 Aug 2010 01:10:25 +0900
To: tao.ma@oracle.com
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH] ide: Use kzalloc in idedisk_prepare_flush.
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1280740951-13487-1-git-send-email-tao.ma@oracle.com>
References: <1280740951-13487-1-git-send-email-tao.ma@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100803010903I.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 03 Aug 2010 01:10:25 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  2 Aug 2010 17:22:31 +0800
Tao Ma <tao.ma@oracle.com> wrote:

> Signed-off-by: Tao Ma <tao.ma@oracle.com>
> ---
>  drivers/ide/ide-disk.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
> index 33d6503..127a5a2 100644
> --- a/drivers/ide/ide-disk.c
> +++ b/drivers/ide/ide-disk.c
> @@ -430,12 +430,11 @@ static void ide_disk_unlock_native_capacity(ide_drive_t *drive)
>  static void idedisk_prepare_flush(struct request_queue *q, struct request *rq)
>  {
>  	ide_drive_t *drive = q->queuedata;
> -	struct ide_cmd *cmd = kmalloc(sizeof(*cmd), GFP_ATOMIC);
> +	struct ide_cmd *cmd = kzalloc(sizeof(*cmd), GFP_ATOMIC);
>  
>  	/* FIXME: map struct ide_taskfile on rq->cmd[] */
>  	BUG_ON(cmd == NULL);
>  
> -	memset(cmd, 0, sizeof(*cmd));

This change conflicts with the change in linux-next (came from Jens'
tree).
