Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039Ab2IELVx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 07:21:53 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:43478 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab2IELVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 07:21:52 -0400
MIME-Version: 1.0
In-Reply-To: <7f59aa30d3af02ae522dc38105e51107e34826f2.1306455946.git.joe@perches.com>
References: <20110525165345.5f775c7b.akpm@linux-foundation.org>
	<7f59aa30d3af02ae522dc38105e51107e34826f2.1306455946.git.joe@perches.com>
Date: Wed, 5 Sep 2012 13:21:50 +0200
Message-ID: <CAOoYnzLViwqp11Tw1zf0C+qhc+AtzefNLzZEbC2oUPkWPV5zqQ@mail.gmail.com>
Subject: Re: [PATCH v2] checkpatch: Suggest using min_t or max_t
From: Philippe De Muyter <philippe.demuyter@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/27/11, Joe Perches <joe@perches.com> wrote:
> A common issue with min() or max() is using a cast on
> one or both of the arguments when using min_t/max_t could
> be better.
>
> Add cast detection to uses of min/max and suggest an
> appropriate use of min_t or max_t instead.
>
> Caveat:  This only works for min() or max() on a single line.
>          It does not find min() or max() split across multiple lines.
>
> This does find:
> 	min((u32)foo, bar);
> But it does not find:
> 	max((unsigned long)foo,
> 	    bar);
>
> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>
> v2: Make $match_balanced_parentheses work in perl 5.8

Has this been applied  ?

v3.3 version of checkpatch.pl works for me, but v3.4, v3.5 & v3.6rc2 say:
Nested quantifiers in regex; marked by <-- HERE in m/(\((?:[^\(\)]++
<-- HERE |(?-1))*\))/ at scripts/checkpatch.pl line 340.

and my perl is :

        perl --version

        This is perl, v5.8.8 built for i586-linux-thread-multi

Philippe
