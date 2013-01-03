Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab3ACAfI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 19:35:08 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:58062 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023Ab3ACAfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 19:35:04 -0500
MIME-Version: 1.0
In-Reply-To: <1357171594.25181.19.camel@joe-AO722>
References: <20130102232730.5706.82243.stgit@grignak.americas.hpqcorp.net>
 <20130102232743.5706.63153.stgit@grignak.americas.hpqcorp.net> <1357171594.25181.19.camel@joe-AO722>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 2 Jan 2013 18:34:41 -0600
Message-ID: <CAErSpo51SUYBOj89RM7SSBPEEGW6dddjWUX53u0srZS_eqkbSA@mail.gmail.com>
Subject: Re: [PATCH] checkpatch: prefer dev_<level>( to dev_printk(KERN_<LEVEL>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>, Lance Ortiz <lance.ortiz@hp.com>,
        lance_ortiz@hotmail.com, jiang.liu@huawei.com, tony.luck@intel.com,
        bp@alien8.de, rostedt@goodmis.org, mchehab@redhat.com,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 2, 2013 at 6:06 PM, Joe Perches <joe@perches.com> wrote:
> Add YA check to printk style.
>
> dev_<level> uses are functions and generate smaller
> object code than dev_printk(KERN_<LEVEL>.
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  scripts/checkpatch.pl | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 4d2c7df..f50b32d 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2430,6 +2430,16 @@ sub process {
>                              "Prefer pr_warn(... to pr_warning(...\n" . $herecurr);
>                 }
>
> +               if ($line =~ /\bdev_printk\s*\(\s*KERN_([A-Z]+)/) {
> +                       my $orig = $1;
> +                       my $level = lc($orig);
> +                       $level = "warn" if ($level eq "warning");
> +                       my $level2 = $level;
> +                       $level2 = "dbg" if ($level eq "debug");
> +                       WARN("PREFER_DEV_LEVEL",
> +                            "Prefer dev_$level2(... to dev_printk(KERN_$orig, ...\n" . $herecurr);

This suggests dev_dbg() instead of dev_printk(KERN_DEBUG), doesn't it?
 Those aren't equivalent (dev_printk() always does the printk, but in
many cases dev_dbg() does not, depending on CONFIG_DEBUG,
CONFIG_DYNAMIC_DEBUG, etc.)

> +               }
> +
>  # function brace can't be on same line, except for #defines of do while,
>  # or if closed on same line
>                 if (($line=~/$Type\s*$Ident\(.*\).*\s{/) and
>
>
