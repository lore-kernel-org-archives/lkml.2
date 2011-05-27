Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729Ab1E0Tdq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 15:33:46 -0400
Received: from mail.perches.com ([173.55.12.10]:2148 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752847Ab1E0Tdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 15:33:44 -0400
Subject: Re: [patch v4] checkpatch: Signature format verification
From: Joe Perches <joe@perches.com>
To: anish singh <anish198519851985@gmail.com>
Cc: Manish Kumar Singh <man.k1983@gmail.com>, davej@redhat.com,
        rostedt@goodmis.org, apw@shadowen.org, akpm@linux-foundation.org,
        vapier@gentoo.org, linux-kernel@vger.kernel.org
In-Reply-To: <BANLkTi=JK+XS2D0exj=unjpjGCsnVncCzQ@mail.gmail.com>
References: <1306006721.1622.18.camel@anish-desktop>
	 <1306059528.2761.3.camel@anish-desktop>
	 <1306164094.2292.25.camel@anish-desktop>
	 <1306519311.1918.12.camel@anish-desktop>
	 <1306520991.31864.9.camel@Joe-Laptop>
	 <BANLkTikfh_ABGomn-Lm9Ugc7MzeRodwiEQ@mail.gmail.com>
	 <1306523288.31864.29.camel@Joe-Laptop>
	 <BANLkTi=JK+XS2D0exj=unjpjGCsnVncCzQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 May 2011 12:33:42 -0700
Message-ID: <1306524822.31864.50.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-05-28 at 00:47 +0530, anish singh wrote:
> On Sat, May 28, 2011 at 12:38 AM, Joe Perches <joe@perches.com> wrote:
>         On Sat, 2011-05-28 at 00:28 +0530, Manish Kumar Singh wrote:
>         >         For the 3rd time, please use this form:
>         >                if ($line =~ /^(\s*)($ValidSignatures)(\s*)(.*)$/i) {
>         >         and if you really want email format validation,
>         >         use a separate function.
>         []
>         > Problem with your way of doing is if anyone misses space
>         between
>         > "sign" & name,
>         > the regular expression
>         (/^(\s*)($ValidSignatures)(\s*)(.*)$/i )
>         > doesn't match
>         That's incorrect.  Try it.

Anish, do you have a response to this?

> I have replaced b/w with "between".
> And as Manish rightly exlained this patch is not meant for 
> email validation.

Yet it does incorrectly anyway to nominally skip
name and find <.*>.  That's the problem.

Look again at the patterns:

+                               if ($line =~ /^\s*$sign(.*)/i) {
+                                       if ($1 !~ /^\s+([a-zA-Z\s\"\.\-\'\,]*.*)/i) {
+                                               WARN("Space required after $sign\n" .
+                                                       $herecurr);
+                                       }

and

+                                       if ($1 !~ /([\sa-zA-Z\"\.\-\'\,]*)\s<.*>/i) {
+                                               WARN("Space required b/w Full Name & Mail-id:\n" .
+                                                       $herecurr);
+                                       }

> I would like to know if anything else is missing?

Correctness.

Keep at it, it'll eventually be good to go.

cheers, Joe

