Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab1FUKRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 06:17:31 -0400
Received: from rere.qmqm.pl ([89.167.52.164]:41001 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756039Ab1FUKR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 06:17:28 -0400
Date: Tue, 21 Jun 2011 12:17:25 +0200
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: James Hogan <james@albanarts.com>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: Re: [PATCH] cb710: fix #ifdef HAVE_EFFICIENT_UNALIGNED_ACCESS
Message-ID: <20110621101725.GA670@rere.qmqm.pl>
References: <BANLkTikMc1WfJMJ2NeBr1E62dGjCj1Cd_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTikMc1WfJMJ2NeBr1E62dGjCj1Cd_w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 10:55:34AM +0100, James Hogan wrote:
> HAVE_EFFICIENT_UNALIGNED_ACCESS is a config option, therefore it needs
> the CONFIG_ before it when used by the preprocessor.
> 
> Signed-off-by: James Hogan <james@albanarts.com>
> ---
>  drivers/misc/cb710/sgbuf2.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/misc/cb710/sgbuf2.c b/drivers/misc/cb710/sgbuf2.c
> index d019746..2a40d0e 100644
> --- a/drivers/misc/cb710/sgbuf2.c
> +++ b/drivers/misc/cb710/sgbuf2.c
> @@ -47,7 +47,7 @@ static uint32_t sg_dwiter_read_buffer(struct
> sg_mapping_iter *miter)
> 
>  static inline bool needs_unaligned_copy(const void *ptr)
>  {
> -#ifdef HAVE_EFFICIENT_UNALIGNED_ACCESS
> +#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
>  	return false;
>  #else
>  	return ((ptr - NULL) & 3) != 0;

Acked-by: Micha³ Miros³aw <mirq-linux@rere.qmqm.pl>

[Cc: linux-mmc]
