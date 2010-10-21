Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605Ab0JUJMH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 05:12:07 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61835 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab0JUJMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 05:12:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YuOtaCo8zNXAF4MWC6Ji0VMOpS87Y2oZQEIwxOzBeuW43UFN0MvVtTCq9f8gmPEpGX
         1VlACi75In3fnmQ3XoWToELKGAeYz6T4Jr8YlmjwxGXbEXRAhLMg332sGhlHL83dXqdk
         8zme/8CuFCfshPfq81sgNOyG3J1zfJ++6DleQ=
Date: Thu, 21 Oct 2010 17:16:42 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Nicolas Kaiser <nikai@nikai.net>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jens Axboe <jaxboe@fusionio.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: return error on error condition
Message-ID: <20101021091642.GD5329@cr0.nay.redhat.com>
References: <20101020165047.09150171@absol.kitzblitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101020165047.09150171@absol.kitzblitz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 04:50:47PM +0200, Nicolas Kaiser wrote:
>It's intended to return an error, right?
>
>Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
>---
> fs/pipe.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
>diff --git a/fs/pipe.c b/fs/pipe.c
>index 279eef9..37eb1eb 100644
>--- a/fs/pipe.c
>+++ b/fs/pipe.c
>@@ -382,7 +382,7 @@ pipe_read(struct kiocb *iocb, const struct iovec *_iov,
> 			error = ops->confirm(pipe, buf);
> 			if (error) {
> 				if (!ret)
>-					error = ret;
>+					ret = error;
> 				break;
> 			}
> 

Wow, I think you are right. :)
