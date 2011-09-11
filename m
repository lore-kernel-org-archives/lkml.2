Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760260Ab1IKO71 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 10:59:27 -0400
Received: from gate.crashing.org ([63.228.1.57]:38220 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754499Ab1IKO70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 10:59:26 -0400
Subject: Re: [patch v3 14/36] Hexagon: Add signal functions
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linas Vepstas <linas@codeaurora.org>
In-Reply-To: <20110909010916.028280867@codeaurora.org>
References: <20110909010847.294039464@codeaurora.org>
	 <20110909010916.028280867@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 11 Sep 2011 11:59:18 -0300
Message-ID: <1315753158.455.53.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-08 at 20:09 -0500, Richard Kuo wrote:

> +#define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
> +
> +struct sigframe {
> +	unsigned long pad[2]; /* Used to be signal tramp */
> +	struct sigcontext sc;
> +	sigset_t mask;
> +};
> +
> +struct rt_sigframe {
> +	unsigned long pad[2]; /* Used to be signal tramp */
> +	struct siginfo info;
> +	struct ucontext uc;
> +};

Why did you make two types of signal frames ? It's an unnecessary
complication... Dunno if you can still fix that (if you can still
control your ABI that is), but you should look how ppc64 uses the same
frame for RT and non-RT, avoids duplication of bugs :-)

Cheers,
Ben.


