Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab1FCOit (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 10:38:49 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46165 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306Ab1FCOiq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 10:38:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=G2jXnX6ZwJ4j3dkeEtyI9ZZT0nHrOFl1xi2iuECKQ8NQ1TBIJDBDFNF35StXHGIeNX
         CzZiLld/AIKTwc0OAZmD4RK6Y6sPqXTlu1lpgSzfmXK1lVWsbLJ9sbGiVc1vX55GCLxO
         /s2yRLdr+997d0n4WfmaOwueWZA066ajNiAwc=
MIME-Version: 1.0
In-Reply-To: <1307077367-6277-1-git-send-email-eric.miao@linaro.org>
References: <1307077367-6277-1-git-send-email-eric.miao@linaro.org>
From: Eric Miao <eric.miao@linaro.org>
Date: Fri, 3 Jun 2011 22:38:26 +0800
X-Google-Sender-Auth: n4BdMQF9u8bO6lB0qMLDfa0epz4
Message-ID: <BANLkTintqdOe3NBekhdjXT1Y126nk23wbw@mail.gmail.com>
Subject: Re: [PATCH] brd: make brd_make_request() return error code
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Nick Piggin <npiggin@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 3, 2011 at 1:02 PM, Eric Miao <eric.miao@linaro.org> wrote:
> brd_make_request() always returns 0, which doesn't make much sense.
>
> Signed-off-by: Eric Miao <eric.miao@linaro.org>
> ---
>  drivers/block/brd.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/block/brd.c b/drivers/block/brd.c
> index dba1c32..a9587ee 100644
> --- a/drivers/block/brd.c
> +++ b/drivers/block/brd.c
> @@ -360,7 +360,7 @@ static int brd_make_request(struct request_queue *q, struct bio *bio)
>  out:
>        bio_endio(bio, err);
>
> -       return 0;
> +       return err;
>  }
>
>  #ifdef CONFIG_BLK_DEV_XIP
> --
> 1.7.4.1
>
>
