Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232Ab2KTOnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 09:43:50 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:32835 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752888Ab2KTOns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 09:43:48 -0500
Message-ID: <1353422629.11235.10.camel@joe-AO722>
Subject: Re: [PATCH v4] checkpatch: debugfs_remove() can take NULL
From: Joe Perches <joe@perches.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: Constantine Shulyupin <const@MakeLinux.com>, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Date: Tue, 20 Nov 2012 06:43:49 -0800
In-Reply-To: <20121120142906.GD7955@dm>
References: <1353190818-10070-1-git-send-email-const@MakeLinux.com>
	 <20121120142906.GD7955@dm>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-11-20 at 14:29 +0000, Andy Whitcroft wrote:

> This all looks sensible, though we still have three blocks doing the
> same thing.  How about we standardise this check into a single check,
> generating the capacity from the matched name.
[]
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> +			if ($line =~ /\b(kfree|usb_free_urb|debugfs_remove(?:_recursive)?)$expr/) {
> +				my $func = $1;
> +				my $func_capacity = "NEEDLESS_$1";
> +
> +				$func_capacity =~ s/(.$)/\U$1\E/;
> +
> +				WARN($func_capacity,
> +				     "$func(NULL) is safe this check is probably not required\n" . $hereprev);

Perhaps just
				WARN("NEEDLESS_IF",
...


