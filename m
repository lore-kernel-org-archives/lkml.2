Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315Ab1E0SRB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 14:17:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:57469 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920Ab1E0SRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 14:17:00 -0400
X-Authority-Analysis: v=1.1 cv=u/eXSd3k4P+OuNmbl5aZU3ellt6eTxbOnGssQLT4hSY= c=1 sm=0 a=kJ--3F4o5PMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=F0thtKX3YZnHEdhDmaoA:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [patch v4] checkpatch: Signature format verification
From: Steven Rostedt <rostedt@goodmis.org>
To: anish <anish198519851985@gmail.com>
Cc: joe@perches.com, davej@redhat.com, apw@shadowen.org,
        akpm@linux-foundation.org, vapier@gentoo.org,
        linux-kernel@vger.kernel.org, man.k1983@gmail.com
In-Reply-To: <1306519311.1918.12.camel@anish-desktop>
References: <1306006721.1622.18.camel@anish-desktop>
	 <1306059528.2761.3.camel@anish-desktop>
	 <1306164094.2292.25.camel@anish-desktop>
	 <1306519311.1918.12.camel@anish-desktop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 27 May 2011 14:16:57 -0400
Message-ID: <1306520217.3857.31.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-27 at 23:31 +0530, anish wrote:
> From: anish kumar <anish198519851985@gmail.com>
> 

> +		my ($sign,$loop_brk);
> +		my @signs = ("Reviewed-by:","Acked-by:","Signed-off-by:","Tested-by:");
> +		foreach $sign (@signs) {
> +			$loop_brk=0;
> +			if ($line =~ /^\s*$sign/i) {
> +				# This is a signoff, if ugly, so do not double report.
> +				$signoff++;
> +				$loop_brk++;
> +				if (!($line =~ /^\s*$sign/)) {
> +					WARN("$sign is the preferred form\n" .
> +						$herecurr);
> +				}
> +				if ($line =~ /^\s*$sign(.*)/i) {
> +					if ($1 !~ /^\s+([a-zA-Z\s\"\.\-\'\,]*.*)/i) {
> +						WARN("Space required after $sign\n" .
> +							$herecurr);
> +					}
> +					if ($1 !~ /([\sa-zA-Z\"\.\-\'\,]*)\s<.*>/i) {
> +						WARN("Space required b/w Full Name & Mail-id:\n" .

What's "b/w" black and white?

Also do we check for <>. As the above will trigger for missing <> and
give a warning about spaces.

I once had my quilt mail send crap to LKML because one of the Cc's in a
patch I pulled was missing the ending ">".

-- Steve

> +							$herecurr);
> +					}
> +				}
>  			}
> +			last if ($loop_brk == 1);
>  		}
> -
>  # Check for wrappage within a valid hunk of the file
>  		if ($realcnt != 0 && $line !~ m{^(?:\+|-| |\\ No newline|$)}) {
>  			ERROR("patch seems to be corrupt (line wrapped?)\n" .


