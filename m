Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758710Ab1D2NrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 09:47:21 -0400
Received: from cantor.suse.de ([195.135.220.2]:43776 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241Ab1D2NrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 09:47:20 -0400
Date: Fri, 29 Apr 2011 15:47:18 +0200
From: Michal Marek <mmarek@suse.cz>
To: Peter Foley <pefoley2@verizon.net>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH V2] kbuild: don't warn about include/linux/version.h not
 including itself
Message-ID: <20110429134718.GE1619@sepie.suse.cz>
References: <4DB7504C.6060507@verizon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DB7504C.6060507@verizon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 07:07:56PM -0400, Peter Foley wrote:
> This patch makes checkversion.pl not warn that include/linux/version.h
> dosen't include itself.
> 
> Signed-off-by: Peter Foley <pefoley2@verizon.net>
> ---
>  scripts/checkversion.pl |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/scripts/checkversion.pl b/scripts/checkversion.pl
> index b444e89..cf4b1dc 100755
> --- a/scripts/checkversion.pl
> +++ b/scripts/checkversion.pl
> @@ -12,6 +12,8 @@ $| = 1;
>  my $debugging;
>  
>  foreach my $file (@ARGV) {
> +    if($file !~ "include/linux/version\.h")
> +    {
>      # Open this file.

Enclosing the block in another pair of {...} is ugly, I changed it to


diff --git a/scripts/checkversion.pl b/scripts/checkversion.pl
index b444e89..5e490a8 100755
--- a/scripts/checkversion.pl
+++ b/scripts/checkversion.pl
@@ -12,6 +12,7 @@ $| = 1;
 my $debugging;
 
 foreach my $file (@ARGV) {
+    next if $file =~ "include/linux/version\.h";
     # Open this file.
     open( my $f, '<', $file )
       or die "Can't open $file: $!\n";

and pushed to kbuild-2.6.git#misc.

Michal
