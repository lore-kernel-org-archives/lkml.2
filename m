Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237Ab1DZUfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 16:35:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58307 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754901Ab1DZUfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 16:35:45 -0400
Message-ID: <4DB72C9F.50401@suse.cz>
Date: Tue, 26 Apr 2011 22:35:43 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: pefoley2@verizon.net
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] kbuild: don't warn about linux/version.h not including
 itself
References: <4DB4B1F9.5040805@verizon.net>
In-Reply-To: <4DB4B1F9.5040805@verizon.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.4.2011 01:27, Peter Foley wrote:
> This patch makes checkversion.pl not warn that include/linux/version.h
> dosen't include itself.
> 
> Signed-off-by: Peter Foley <pefoley2@verizon.net>
> ---
>  scripts/checkversion.pl |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/checkversion.pl b/scripts/checkversion.pl
> index b444e89..b9150c7 100755
> --- a/scripts/checkversion.pl
> +++ b/scripts/checkversion.pl
> @@ -47,7 +47,7 @@ foreach my $file (@ARGV) {
>      }
>  
>      # Report used version IDs without include?
> -    if ($fUseVersion && ! $iLinuxVersion) {
> +    if ($fUseVersion && ! $iLinuxVersion && $file !~ "include/linux/version.h") {

A more obvious fix would be to check the filename right at the beginning
of the loop and skip to the next iteration if it is version.h. Also, you
should escape the '.' in the regexp.

Michal
