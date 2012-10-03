Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965360Ab2JCQZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 12:25:48 -0400
Received: from mail.vyatta.com ([76.74.103.46]:35525 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964943Ab2JCQZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 12:25:45 -0400
Date: Wed, 3 Oct 2012 09:25:08 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: mlindner@marvell.com, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/20] drivers/net/ethernet/marvell/skge.c: fix error
 return code
Message-ID: <20121003092508.6a7da662@nehalam.linuxnetplumber.net>
In-Reply-To: <1349281090-10013-20-git-send-email-peter.senna@gmail.com>
References: <1349281090-10013-20-git-send-email-peter.senna@gmail.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  3 Oct 2012 18:18:10 +0200
Peter Senna Tschudin <peter.senna@gmail.com> wrote:

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
> 

Thanks for looking into these kind of problems. The contents
of the patch are correct, but the automated commit message is useless.
You shouldn't just blindly say what the automated
script was looking for, you should describe what the bug is so that evaluators
can decide what the impact is and if it should be backported to stable
and vendor kernels.

Please resubmit the patchs with a reasonable analysis in the commit message.
Something like:

  There is a bug in skge driver. If alloc_etherdev() fails, then
  skge_devinit() will return NULL, and the skge_probe function incorrectly
  returns success 0. It should return -ENOMEM instead.


