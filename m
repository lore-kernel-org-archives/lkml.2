Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab2BIHhs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 02:37:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44177 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002Ab2BIHhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 02:37:47 -0500
Date: Thu, 9 Feb 2012 08:37:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung@gmail.com>, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        paulus@samba.org, tglx@linutronix.de
Subject: Re: [PATCH] perf tools: Allow multiple threads or processes in
 record, stat, top
Message-ID: <20120209073727.GA18152@elte.hu>
References: <1328718772-16688-1-git-send-email-dsahern@gmail.com>
 <4F331F14.5070100@gmail.com>
 <4F3334F7.70809@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F3334F7.70809@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> > I was trying to remove ctype.h, you might use util.h here.
> 
> Right, knew that. But, in this case I am adding a call to 
> isdigit which means a direct dependency on ctype.h. I would 
> prefer a direct relationship versus an indirect via util.h

Please just remove ctype.h *altogether* from perf, it's just an 
insane header.

Have a look at how Git solves these types of problems, it 
defines sane string functions in git-compat-util.h:

/* Sane ctype - no locale, and works with signed chars */
#undef isascii
#undef isspace
#undef isdigit
#undef isalpha
#undef isalnum
#undef tolower
#undef toupper
extern unsigned char sane_ctype[256];
#define GIT_SPACE 0x01
#define GIT_DIGIT 0x02
#define GIT_ALPHA 0x04
#define GIT_GLOB_SPECIAL 0x08
#define GIT_REGEX_SPECIAL 0x10

Thanks,

	Ingo
