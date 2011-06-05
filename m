Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647Ab1FEJfH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 05:35:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43099 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754867Ab1FEJfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 05:35:06 -0400
Date: Sun, 5 Jun 2011 11:34:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Unhide DEBUG_BUGVERBOSE when EXPERT=y, even if
 DEBUG_KERNEL=n
Message-ID: <20110605093445.GA19927@elte.hu>
References: <20110605083230.GA18260@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110605083230.GA18260@leaf>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Josh Triplett <josh@joshtriplett.org> wrote:

>  config DEBUG_BUGVERBOSE
> -	bool "Verbose BUG() reporting (adds 70K)" if DEBUG_KERNEL && EXPERT
> +	bool "Verbose BUG() reporting (adds 70K)" if DEBUG_KERNEL || EXPERT

Well, DEBUG_KERNEL really means two things:

  - make more debugging options available
  - allow the *disabling* of existing (default-enabled) debug options

So i think the right solution would be to select DEBUG_KERNEL if 
EXPERT is enabled - this would simplify things and would allow the 
removal of a lot of EXPERT conditions from the debug options.

Ok?

Thanks,

	Ingo
