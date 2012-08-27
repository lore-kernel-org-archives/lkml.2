Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab2H0P4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 11:56:16 -0400
Received: from novprvoes0310.provo.novell.com ([137.65.248.74]:56729 "EHLO
	novprvoes0310.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752953Ab2H0P4P convert rfc822-to-8bit
	(ORCPT <rfc822;groupwise-linux-kernel@vger.kernel.org:10:1>);
	Mon, 27 Aug 2012 11:56:15 -0400
Message-Id: <503B443C0200007E000C4817@novprvoes0310.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Mon, 27 Aug 2012 09:54:25 -0600
From: "Jeff Mahoney" <jeffm@suse.com>
To: "Jeff Mahoney" <jeffm@suse.com>
Cc: <rmk@arm.linux.org.uk>, <mturquette@linaro.org>,
        <gregkh@linuxfoundation.org>, <andrew@lunn.ch>,
        <w.sang@pengutronix.de>, <jgarzik@redhat.com>,
        <sshtylyov@ru.mvista.com>, <bhupesh.sharma@st.com>,
        <peppe.cavallaro@st.com>, <viresh.kumar@st.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk.h: Fix shim ifdef guard (HAVE_CLK ->
 COMMON_CLK)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ugh. Ignore this one. I tested a build but just started getting build failures on different configs. I'll look into why later this afternoon.

-Jeff

--
Jeff Mahoney
(apologies for the top post -- from my mobile)

On Aug 27, 2012, at 11:27 AM, "Jeff Mahoney<jeffm@suse.com>" <jeffm@suse.com> wrote:

> Commit 93abe8e4 (clk: add non HAVE_CLK routines) added shims for
> the clk code but HAVE_CLK isn't enough. It's possible to have the
> clk support but not enable it. We end up with full prototypes for code
> that is never built - causing module linking to fail later.
> 
> This patch changes the guard to use COMMON_CLK, which actually guards
> the code.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
> include/linux/clk.h |    4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- a/include/linux/clk.h
> +++ b/include/linux/clk.h
> @@ -120,7 +120,7 @@ static inline void clk_unprepare(struct
> }
> #endif
> 
> -#ifdef CONFIG_HAVE_CLK
> +#ifdef CONFIG_COMMON_CLK
> /**
>  * clk_get - lookup and obtain a reference to a clock producer.
>  * @dev: device for clock "consumer"
> @@ -276,7 +276,7 @@ struct clk *clk_get_parent(struct clk *c
>  */
> struct clk *clk_get_sys(const char *dev_id, const char *con_id);
> 
> -#else /* !CONFIG_HAVE_CLK */
> +#else /* !CONFIG_COMMON_CLK */
> 
> static inline struct clk *clk_get(struct device *dev, const char *id)
> {
> 
> 
> -- 
> Jeff Mahoney
> SUSE Labs

