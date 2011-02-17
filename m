Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264Ab1BQRLx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 12:11:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35031 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757132Ab1BQRLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 12:11:48 -0500
Date: Thu, 17 Feb 2011 18:11:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michal Marek <mmarek@suse.cz>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: linux-next: build failure after merge of the tip tree
Message-ID: <20110217171131.GA17058@elte.hu>
References: <20110131154259.dca1f7e6.sfr@canb.auug.org.au>
 <20110217144743.2db26b27.sfr@canb.auug.org.au>
 <4D5D201A.8090304@suse.cz>
 <20110217150200.GA32177@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110217150200.GA32177@sepie.suse.cz>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Michal Marek <mmarek@suse.cz> wrote:

> @@ -340,9 +342,16 @@ static void parse_dep_file(void *map, size_t len)
>  		if (strrcmp(s, "include/generated/autoconf.h") &&
>  		    strrcmp(s, "arch/um/include/uml-config.h") &&
>  		    strrcmp(s, ".ver")) {
> -			printf("  %s \\\n", s);
> +			/* Do not output the first dependency (the
> +			 * source file), so that kbuild is not confused
> +			 * if a .c file is rewritten into .S or vice
> +			 * versa.
> +			 */

Just a really minor nitpick, please use the standard comment style:

  /*
   * Comment .....
   * ...... goes here.
   */

specified in Documentation/CodingStyle.

Thanks,

	Ingo
