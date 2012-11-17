Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092Ab2KQTAr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 14:00:47 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:45888 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752031Ab2KQTAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 14:00:46 -0500
Message-ID: <1353178846.15959.2.camel@joe-AO722>
Subject: Re: [PATCH v3] checkpatch: debugfs_remove() can take NULL
From: Joe Perches <joe@perches.com>
To: Constantine Shulyupin <const@MakeLinux.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        Andy Whitcroft <apw@canonical.com>
Date: Sat, 17 Nov 2012 11:00:46 -0800
In-Reply-To: <1353178462-3868-1-git-send-email-const@MakeLinux.com>
References: <1353178462-3868-1-git-send-email-const@MakeLinux.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-11-17 at 20:54 +0200, Constantine Shulyupin wrote:
> From: Constantine Shulyupin <const@MakeLinux.com>

Hi Constantine.

> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> +# check for needless debugfs_remove() and debugfs_remove_recursive*() checks
> +			if ($line =~ /\b(debugfs_remove(?:_recursive)?)$expr/) {
> +				WARN("NEEDLESS_DEBUGFS_REMOVE",
> +				     "$1(NULL) is safe this check is probably not required\n" . $hereprev);
> +			}

OK,

> +# check for needless debugfs_remove_recursive() and debugfs_remove_recursive*() checks
> +			if ($line =~ /\b(debugfs_remove_recursive(?:_recursive)?)$expr/) {
> +				WARN("NEEDLESS_DEBUGFS_REMOVE_RECURSIVE",
> +				     "$1(NULL) is safe this check is probably not required\n" . $hereprev);
> +			}

You don't need thus second block.
The first check finds both
	debugfs_remove(foo)
and
	debugfs_remove_recursive(bar)

The second one is redundant

