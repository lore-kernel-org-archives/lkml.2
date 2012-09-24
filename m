Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab2IXMPJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 08:15:09 -0400
Received: from mail-ey0-f194.google.com ([209.85.215.194]:57989 "EHLO
	mail-ey0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557Ab2IXMPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 08:15:06 -0400
X-Greylist: delayed 786 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Sep 2012 08:15:05 EDT
MIME-Version: 1.0
In-Reply-To: <1347902908-19006-1-git-send-email-peter.senna@gmail.com>
References: <1347902908-19006-1-git-send-email-peter.senna@gmail.com>
Date: Mon, 24 Sep 2012 17:31:55 +0530
Message-ID: <CAAnUQp3g6hGo1m6yZG76ifGxpuQRzYBk51ZsaNAVkgYLwMhjZw@mail.gmail.com>
Subject: Re: [PATCH 1/4] drivers/crypto/ux500/cryp/cryp_core.c: fix error
 return code
From: Arun Murthy <arunrmurthy.83@gmail.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: herbert@gondor.hengli.com.au, davem@davemloft.net,
        linus.walleij@linaro.org, andreas.westin@stericsson.com, rjw@sisk.pl,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 10:58 PM, Peter Senna Tschudin
<peter.senna@gmail.com> wrote:
> From: Peter Senna Tschudin <peter.senna@gmail.com>
>
> Convert a nonnegative error return code to a negative one, as returned
> elsewhere in the function.
>
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
>
> // <smpl>
> (
> if@p1 (\(ret < 0\|ret != 0\))
>  { ... return ret; }
> |
> ret@p1 = 0
> )
> ... when != ret = e1
>     when != &ret
> *if(...)
> {
>   ... when != ret = e2
>       when forall
>  return ret;
> }
> // </smpl>
>
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

Reviewed-by: Arun Murthy <arunrmurthy83@gmail.com>
