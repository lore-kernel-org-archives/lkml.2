Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252Ab0HRV6D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 17:58:03 -0400
Received: from mail.perches.com ([173.55.12.10]:1179 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150Ab0HRV6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 17:58:01 -0400
Subject: Re: add memset checks to checkpatch.pl
From: Joe Perches <joe@perches.com>
To: Dave Jones <davej@redhat.com>
Cc: apw@canonical.com, Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20100818214818.GA31094@redhat.com>
References: <20100818204016.GA29640@redhat.com>
	 <1282167133.6724.165.camel@Joe-Laptop>  <20100818214818.GA31094@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Aug 2010 14:57:59 -0700
Message-ID: <1282168679.6724.174.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-18 at 17:48 -0400, Dave Jones wrote:
> On Wed, Aug 18, 2010 at 02:32:13PM -0700, Joe Perches wrote:
>  > On Wed, 2010-08-18 at 16:40 -0400, Dave Jones wrote:
>  > > Occasionally someone goofs the argument order to memset.
>  > 	if ($line =~ /\bmemset\s*\(\s*($Lval)\s*,\s*($Lval)\s*,\s*($Lval)\s*\)/) {
>  > 		my $memset_addr = $1;
>  > 		my $memset_val = $2;
>  > 		my $memset_size = $3;
>  > 		if ($memset_size =~ /(0x|)0$/i) {
>  > 			ERROR("memset uses second argument as constant byte value, not third.\n" . $herecurr);
>  > 		elsif ($memset_size =~ /(0x|)1/i) {
>  > 			WARN("single byte memset is suspicious. Swapped 2nd/3rd argument?\n" . $herecurr);
>  > 		}
>  > 	}
> I'm all for improving my shoddy perl where possible, but this doesn't seem to actually
> catch any of the test cases I wrote.  (it's also missing a } )

I intend never to be a perl monk.

I notice the missing { before the elsif after I sent it.
Oh well.

I just typed it in the emailer, so it's not tested at all.
Also it's missing a $ after 1 in the second $memset_size test.

What are your test cases anyway?

Likely $Lval isn't matching things like
sizeof(*foo) so this isn't checked:

	memset(foo, bar, sizeof(*foo));

Maybe Andy has a better idea?

