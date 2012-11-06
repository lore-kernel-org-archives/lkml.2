Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab2KFXg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 18:36:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40080 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab2KFXg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 18:36:27 -0500
Date: Tue, 6 Nov 2012 15:36:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>, Adil Mujeeb <mujeeb.adil@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 3/3] checkpatch: Emit an warning when floating point
 values are used
Message-Id: <20121106153625.c48ba1f1.akpm@linux-foundation.org>
In-Reply-To: <359a78054bc0dfaedede95222781b4177d3c33ce.1351736873.git.joe@perches.com>
References: <cover.1351736873.git.joe@perches.com>
	<359a78054bc0dfaedede95222781b4177d3c33ce.1351736873.git.joe@perches.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  1 Nov 2012 00:12:18 -0700
Joe Perches <joe@perches.com> wrote:

> Linux kernel doesn't like floating point, say so.
> 
> ...
>
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2332,6 +2332,13 @@ sub process {
>  			     "do not add new typedefs\n" . $herecurr);
>  		}
>  
> +# check for floating point constants
> +
> +		if ($line =~ /\b$Float\b/) {
> +			WARN("KERNEL_FLOAT",
> +			     "Floating point is not supported in linux kernel source\n" . $herecurr);
> +		}
> +
>  # * goes on variable not on type
>  		# (char*[ const])
>  		while ($line =~ m{(\($NonptrType(\s*(?:$Modifier\b\s*|\*\s*)+)\))}g) {

The earlier review comments were not addressed.

In particular, I don't see a problem with people doing

	int foo = 1.1 * 2.2;
