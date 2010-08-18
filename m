Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab0HRVcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 17:32:18 -0400
Received: from mail.perches.com ([173.55.12.10]:1175 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745Ab0HRVcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 17:32:15 -0400
Subject: Re: add memset checks to checkpatch.pl
From: Joe Perches <joe@perches.com>
To: Dave Jones <davej@redhat.com>
Cc: apw@canonical.com, Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20100818204016.GA29640@redhat.com>
References: <20100818204016.GA29640@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Aug 2010 14:32:13 -0700
Message-ID: <1282167133.6724.165.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-18 at 16:40 -0400, Dave Jones wrote:
> Occasionally someone goofs the argument order to memset.
> This patch makes checkpatch catch those.
> 
> I made memset with size of 0 an error, because it's never correct,
> whereas memset with a size of 1 isn't technically an incorrect
> thing to do so I left it as a warning. It may still be better to replace
> it with a single variable assignment in the false positive cases.

Maybe something like allows more flexible checking?

	if ($line =~ /\bmemset\s*\(\s*($Lval)\s*,\s*($Lval)\s*,\s*($Lval)\s*\)/) {
		my $memset_addr = $1;
		my $memset_val = $2;
		my $memset_size = $3;
		if ($memset_size =~ /(0x|)0$/i) {
			ERROR("memset uses second argument as constant byte value, not third.\n" . $herecurr);
		elsif ($memset_size =~ /(0x|)1/i) {
			WARN("single byte memset is suspicious. Swapped 2nd/3rd argument?\n" . $herecurr);
		}
	}


