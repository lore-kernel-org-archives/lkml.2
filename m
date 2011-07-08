Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab1GHXBv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 19:01:51 -0400
Received: from mail.perches.com ([173.55.12.10]:3675 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512Ab1GHXBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 19:01:50 -0400
Subject: Re: [PATCH] checkpatch: suggest spaces around binary operators in
 strict mode
From: Joe Perches <joe@perches.com>
To: Pavel Roskin <proski@gnu.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20110708214159.7559.25740.stgit@mj.roinet.com>
References: <20110708214159.7559.25740.stgit@mj.roinet.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Jul 2011 16:01:48 -0700
Message-ID: <1310166108.2042.6.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-08 at 17:41 -0400, Pavel Roskin wrote:
> Signed-off-by: Pavel Roskin <proski@gnu.org>
> ---
>  scripts/checkpatch.pl |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index b0aa2c6..9431ada 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2167,6 +2167,8 @@ sub process {
>  					if ($ctx =~ /Wx[^WCE]|[^WCE]xW/) {
>  						ERROR("need consistent spacing around '$op' $at\n" .
>  							$hereptr);
> +					} elsif ($ctx =~ /[^WCE]x[^WCE]/) {
> +						CHK("spaces suggested around '$op' $at\n" . $hereptr);

Hey Pavel.

This should probably not be an elsif but
a standalone test.

Also, there's an upcoming patch in mm that
classifies all output ERROR/WARN/CHK types.

This one should be "SPACING".

https://lkml.org/lkml/2011/6/21/256

http://userweb.kernel.org/~akpm/mmotm/broken-out/checkpatchpl-add-ability-to-ignore-various-messages.patch


