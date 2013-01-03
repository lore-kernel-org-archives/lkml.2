Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254Ab3ACKIZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 05:08:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59610 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093Ab3ACKIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 05:08:23 -0500
Date: Thu, 3 Jan 2013 10:08:08 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Lance Ortiz <lance.ortiz@hp.com>, bhelgaas@google.com,
        lance_ortiz@hotmail.com, jiang.liu@huawei.com, tony.luck@intel.com,
        bp@alien8.de, rostedt@goodmis.org, mchehab@redhat.com,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: prefer dev_<level>( to
 dev_printk(KERN_<LEVEL>
Message-ID: <20130103100808.GG2649@dm>
References: <20130102232730.5706.82243.stgit@grignak.americas.hpqcorp.net>
 <20130102232743.5706.63153.stgit@grignak.americas.hpqcorp.net>
 <1357171594.25181.19.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357171594.25181.19.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2013 at 04:06:34PM -0800, Joe Perches wrote:
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
>  			     "Prefer pr_warn(... to pr_warning(...\n" . $herecurr);
>  		}
>  
> +		if ($line =~ /\bdev_printk\s*\(\s*KERN_([A-Z]+)/) {
> +			my $orig = $1;
> +			my $level = lc($orig);
> +			$level = "warn" if ($level eq "warning");
> +			my $level2 = $level;
> +			$level2 = "dbg" if ($level eq "debug");

Is there some sublty I am not seeing here such that level2 is necessary?
As far as I can see the two above could be the below to the same effect?

			$level2= "dbg" if ($level eq "debug");

(With the obvious change to the print of course)

-apw
