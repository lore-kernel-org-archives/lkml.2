Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab2IQJTA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 05:19:00 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:38199 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755342Ab2IQJS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 05:18:58 -0400
MIME-Version: 1.0
In-Reply-To: <1347869728-2696-1-git-send-email-peter.senna@gmail.com>
References: <1347869728-2696-1-git-send-email-peter.senna@gmail.com>
Date: Mon, 17 Sep 2012 10:18:56 +0100
Message-ID: <CAFbHwiT13SYbaeKiboXrESoSW40bJx1ogKQwCoc+RnsctUbbfw@mail.gmail.com>
Subject: Re: [PATCH 1/4] drivers/mmc/host/dw_mmc.c: fix error return code
From: Will Newton <will.newton@gmail.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: cjb@laptop.org, tgih.jun@samsung.com, jh80.chung@samsung.com,
        kyungmin.park@samsung.com, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 9:15 AM, Peter Senna Tschudin
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

Acked-by: Will Newton <will.newton@imgtec.com>
