Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873Ab2B0WTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 17:19:34 -0500
Received: from lulu.zabbo.net ([69.168.54.52]:58481 "EHLO lulu.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754116Ab2B0WTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 17:19:33 -0500
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Feb 2012 17:19:33 EST
Message-ID: <4F4C0002.8090207@zabbo.net>
Date: Mon, 27 Feb 2012 17:13:22 -0500
From: Zach Brown <zab@zabbo.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Dave Kleikamp <dave.kleikamp@oracle.com>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 16/22] aio: add aio support for iov_iter arguments
References: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com> <1330377576-3659-17-git-send-email-dave.kleikamp@oracle.com>
In-Reply-To: <1330377576-3659-17-git-send-email-dave.kleikamp@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Only kernel callers can provide an iov_iter so it doesn't make a lot of
> sense to expose the IOCB_CMD values for this as part of the user space
> ABI.
>
> But kernel callers should also be able to perform the usual aio
> operations which suggests using the the existing operation namespace and
> support code.

> --- a/include/linux/aio_abi.h
> +++ b/include/linux/aio_abi.h
> @@ -44,6 +44,8 @@ enum {
>   	IOCB_CMD_NOOP = 6,
>   	IOCB_CMD_PREADV = 7,
>   	IOCB_CMD_PWRITEV = 8,
> +	IOCB_CMD_READ_ITER = 9,
> +	IOCB_CMD_WRITE_ITER = 10,
>   };

Bleh, yeah, I was never very satisfied with this.  It still feels pretty
gross to be using _CMD_ definitions for these in-kernel iocbs.  We'll
need to be verifying that these don't come from userspace iocbs forever
more.

I wonder if we can come up with something that feels less clumsy.

- z
