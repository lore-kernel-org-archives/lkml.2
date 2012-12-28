Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938Ab2L1UAZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 15:00:25 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:44760 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754199Ab2L1UAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 15:00:22 -0500
Message-ID: <1356724821.31130.19.camel@joe-AO722>
Subject: Re: [PATCH] get_maintainer.pl: Find maintainers for removed files
From: Joe Perches <joe@perches.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Date: Fri, 28 Dec 2012 12:00:21 -0800
In-Reply-To: <1356722870-18325-1-git-send-email-geert@linux-m68k.org>
References: <1356722870-18325-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-28 at 20:27 +0100, Geert Uytterhoeven wrote:
> For removed files, get_maintainer.pl doesn't find any maintainers (besides
> the default linux-kernel@vger.kernel.org), as it only looks at the "+++"
> lines, which are "/dev/null" for removals.
> Fix this by extending the parsing to the "---" lines.
[]
> diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
[]
> @@ -433,7 +433,7 @@ foreach my $file (@ARGV) {
>  
>  	while (<$patch>) {
>  	    my $patch_line = $_;
> -	    if (m/^\+\+\+\s+(\S+)/) {
> +	    if (m/^\+\+\+\s+(\S+)/ or m/^---\s+(\S+)/) {
>  		my $filename = $1;
>  		$filename =~ s@^[^/]*/@@;
>  		$filename =~ s@\n@@;

OK, but this would now match any keyword in a deleted filename.


