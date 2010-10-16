Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab0JPR3d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 13:29:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:53926 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094Ab0JPR33 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 13:29:29 -0400
Subject: Re: [tip:perf/core] x86, NMI: Rewrite NMI handler
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@redhat.com, hpa@zytor.com, ying.huang@intel.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, dzickus@redhat.com,
        mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-e21f3e4957f4a55f546873605a5caa59556bb144@git.kernel.org>
References: <1287195738-3136-4-git-send-email-dzickus@redhat.com>
	 <tip-e21f3e4957f4a55f546873605a5caa59556bb144@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 16 Oct 2010 19:29:17 +0200
Message-ID: <1287250157.1998.124.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-10-16 at 16:36 +0000, tip-bot for Huang Ying wrote:
> Commit-ID:  e21f3e4957f4a55f546873605a5caa59556bb144
> Gitweb:     http://git.kernel.org/tip/e21f3e4957f4a55f546873605a5caa59556bb144
> Author:     Huang Ying <ying.huang@intel.com>
> AuthorDate: Fri, 15 Oct 2010 22:22:16 -0400
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Sat, 16 Oct 2010 15:01:27 +0200
> 
> x86, NMI: Rewrite NMI handler
> 
> The original NMI handler is quite outdated in many aspects. This
> patch tries to fix it.
> 
> The order to process the NMI sources are changed as follow:
> 
>  notify_die(DIE_NMI_IPI);
>  notify_die(DIE_NMI);
>  /* process io port 0x61 */
>  nmi_watchdog_touch();
>  unknown_nmi();

NACK!

I object to the DIE_NMI_IPI existance..
