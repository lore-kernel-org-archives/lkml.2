Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab1JHNn5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 09:43:57 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51407 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912Ab1JHNny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 09:43:54 -0400
Date: Sat, 8 Oct 2011 15:43:48 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Mike Frysinger <vapier@gentoo.org>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, David Miller <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 08/11] nohz: Allow rcu extended quiescent state handling
 seperately from tick stop
Message-ID: <20111008134344.GA479@somewhere.redhat.com>
References: <1318004530-705-1-git-send-email-fweisbec@gmail.com>
 <1318004530-705-9-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318004530-705-9-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 07, 2011 at 06:22:07PM +0200, Frederic Weisbecker wrote:
> diff --git a/arch/powerpc/platforms/iseries/setup.c b/arch/powerpc/platforms/iseries/setup.c
> index e2f5fad..350a7fb 100644
> --- a/arch/powerpc/platforms/iseries/setup.c
> +++ b/arch/powerpc/platforms/iseries/setup.c
> @@ -562,7 +562,7 @@ static void yield_shared_processor(void)
>  static void iseries_shared_idle(void)
>  {
>  	while (1) {
> -		tick_nohz_idle_enter();
> +		tick_nohz_idle_enter_norcu_nohz();

Ah too much nohz there. Seems that I skidded while walking
with my sed.

I'm sending you an updated version of that patch.
