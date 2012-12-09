Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934277Ab2LIQya (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 11:54:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44726 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756731Ab2LIQy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 11:54:29 -0500
Date: Sun, 9 Dec 2012 17:54:25 +0100
From: Michal Marek <mmarek@suse.cz>
To: pefoley2@verizon.net, David Howells <dhowells@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 2/5] kbuild: silence rule for extra_certificates
Message-ID: <20121209165425.GA29331@pobox.suse.cz>
References: <1353269117-39917-1-git-send-email-pefoley2@verizon.net> <1353269117-39917-2-git-send-email-pefoley2@verizon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353269117-39917-2-git-send-email-pefoley2@verizon.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added David and Rusty.

On Sun, Nov 18, 2012 at 03:05:14PM -0500, pefoley2@verizon.net wrote:
> From: Peter Foley <pefoley2@verizon.net>
> 
> Silence the touch extra_certificates command
> 
> Signed-off-by: Peter Foley <pefoley2@verizon.net>

I think we should tell the user that the default empty extra
certificates list is being used, in case the user used a wrong filename
or similar. How about this?

Subject: MODSIGN: Fix kbuild output when using default extra_certificates

Signed-off-by: Michal Marek <mmarek@suse.cz>

diff --git a/kernel/Makefile b/kernel/Makefile
index 0dfeca4..8c708e4 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -136,8 +136,12 @@ ifeq ($(CONFIG_MODULE_SIG),y)
 #
 # Pull the signing certificate and any extra certificates into the kernel
 #
+
+quiet_cmd_touch = TOUCH   $@
+      cmd_touch = touch   $@
+
 extra_certificates:
-	touch $@
+	$(call cmd,touch)
 
 kernel/modsign_pubkey.o: signing_key.x509 extra_certificates
 
But I don't insist on the above, feel free to hide the command
completely.

Michal

> ---
>  kernel/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/Makefile b/kernel/Makefile
> index 86e3285..18a0b61 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -137,7 +137,7 @@ ifeq ($(CONFIG_MODULE_SIG),y)
>  # Pull the signing certificate and any extra certificates into the kernel
>  #
>  extra_certificates:
> -	touch $@
> +	@touch $@
>  
>  kernel/modsign_pubkey.o: signing_key.x509 extra_certificates
>  
> -- 
> 1.8.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
