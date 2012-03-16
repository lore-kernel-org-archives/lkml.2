Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945964Ab2CPXcD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:32:03 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:42233 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1032143Ab2CPXbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:31:49 -0400
Message-ID: <1331940707.12813.10.camel@joe2Laptop>
Subject: Re: [PATCH] checkpatch.pl: Check for functions without a real
 prototype
From: Joe Perches <joe@perches.com>
To: Richard Weinberger <richard@nod.at>
Cc: apw@canonical.com, linux-kernel@vger.kernel.org, hpa@zytor.com
Date: Fri, 16 Mar 2012 16:31:47 -0700
In-Reply-To: <1331939074-26865-1-git-send-email-richard@nod.at>
References: <4F63AF10.9030101@zytor.com>
	 <1331939074-26865-1-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-03-17 at 00:04 +0100, Richard Weinberger wrote:
> Functions like this one are evil:
> void foo()
> {
> 	...
> }
[]
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> @@ -2304,6 +2304,19 @@ sub process {
[]
> +		if ($line=~/$Type\s*$Ident\(\)/) {

Perhaps this should be:
		if ($line =~ /(\b$Type\s+$Ident)\s*\(\s*\)/) {

> +			ERROR("FUNCTION_NO_PROTOTYPE",
> +"Function without a real prototype\n" . $herecurr .

Sensible, but maybe:
"Bad function definition - $1() should probably be $1(void)\n"

> +"Thou shalt not, in the language of C, under any circumstances, on the
> +pain of death, declare or define a function with an empty set of
> +parentheses, for though in the language of C++ it meaneth the same as
> +(void), in C it meaneth (...) which is of meaningless as there be no
> +anchor argument by which the types of the varadic arguments can be
> +expressed, and which misleadeth the compiler into allowing unsavory code
> +and in some cases generate really ugly stuff for varadic handling.
> +	-hpa\n");

Humorous once, painful in twice, annoying after.

cheers,  Joe

