Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab1C2H1P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 03:27:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59319 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120Ab1C2H1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 03:27:13 -0400
Date: Tue, 29 Mar 2011 09:27:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Maksym Planeta <mcsim.planeta@gmail.com>, mingo@redhat.com,
        kernel-janitors@vger.kernel.org, namhyung@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86: page: get_order() optimization
Message-ID: <20110329072701.GJ27398@elte.hu>
References: <1301215556-8898-1-git-send-email-mcsim.planeta@gmail.com>
 <4D90E5ED.3080604@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D90E5ED.3080604@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 03/27/2011 01:45 AM, Maksym Planeta wrote:
> > For x86 architecture get_order function can be optimized due to
> > assembler instruction bsr.
> > 
> > This is second version of patch where for constants gcc precompute the
> > result.
> > 
> > Signed-off-by: Maksym Planeta <mcsim.planeta@gmail.com>
> 
> gcc 4.x has an intrinsic, __builtin_clz(), which does the opposite of
> the bsr instruction; specifically:
> 
> 	__builtin_clz(x) ^ 31
> 
> ... generates a bsrl instruction if x is variable.  This tends to
> generate much better code than any assembly hacks.

Indeed, that should work better and should be tried - and it can probably 
propagate the flags result sensibly (which GCC's asm() cannot, unfortunately).

Thanks,

	Ingo
