Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598Ab1IIINB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 04:13:01 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:56202 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758574Ab1IIIM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 04:12:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linas Vepstas <linas@codeaurora.org>
Subject: Re: [patch v3 14/36] Hexagon: Add signal functions
Date: Fri, 09 Sep 2011 10:12:38 +0200
Message-ID: <3380882.JqAqX4juos@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <20110909010916.028280867@codeaurora.org>
References: <20110909010847.294039464@codeaurora.org> <20110909010916.028280867@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:hx5fr0x6l6jO5+hAUXWP/U+2HJcrC9+TPyP72ULUYYe
 3sRiqlnFFC9sWFVNxBneiasFZx+VI6Cm678LwUMIpNMRYDI4Br
 IvR62KQmabtrwbEcMoASE/ydVREk7bwmLzNPJT7H5uDuPJi34w
 +aCf49IQHofcQQ9nu3cPlbNNaKFIBtaepy2sZRrGfkyF8fUpin
 RkcUM7btw2F1fMzg78HBVUJH92FmMISzPMJ5ZXaMptuHCUckwp
 9d65KKRUpOfv0e4wP9siqQgH0InFcNLdwff14f6o1zzetskY9y
 vwzBuEsvFetIGUzQraKmpJFkm1gOekZQxEt7/1rtC/Ta/djG5i
 CP8A4uGNbyhYGXY/YuRk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 September 2011 20:09:01 Richard Kuo wrote:
> +/*
> + * Signal context structure - contains all info to do with the state
> + * before the signal handler was invoked.
> + */
> +struct sigcontext {
> +       struct pt_regs sc_regs;
> +};

I've recently discussed this with Martin Schwidefsky for an unrelated reason,
but I think now that you should define the sigcontext independent of pt_regs.
The pt_regs should really be internal 

> +struct sigframe {
> +       unsigned long pad[2]; /* Used to be signal tramp */
> +       struct sigcontext sc;
> +       sigset_t mask;
> +};
> +
> +struct rt_sigframe {
> +       unsigned long pad[2]; /* Used to be signal tramp */
> +       struct siginfo info;
> +       struct ucontext uc;
> +};

I hadn't noticed this earlier, but I think you can remove the struct sigframe
definition. There should be absolutely no need to have both sigframe and
rt_sigframe.

	Arnd
