Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777Ab0HSP5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 11:57:22 -0400
Received: from xenotime.net ([72.52.115.56]:41616 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751445Ab0HSP5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 11:57:20 -0400
Date: Thu, 19 Aug 2010 08:57:10 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel-doc: be case insensitive when removing
 attributes
Message-Id: <20100819085710.fe790810.rdunlap@xenotime.net>
In-Reply-To: <1282227222.4507.8.camel@jlt3.sipsolutions.net>
References: <1282227222.4507.8.camel@jlt3.sipsolutions.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Aug 2010 16:13:42 +0200 Johannes Berg wrote:

> From: Johannes Berg <johannes.berg@intel.com>
> 
> There are valid attributes that could have upper
> case letters, but we still want to remove, like
> for example
> 	__attribute__((aligned(NETDEV_ALIGN)))
> as encountered in the wireless code.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
> I thought we did this before? Bit confused now :)

I have a similar patch, without patch description & signoff,
so maybe it was from irc.  Oh, and it's in a different script location.

@@ -1426,6 +1426,7 @@ sub dump_struct($$) {
 	$members =~ s/kmemcheck_bitfield_.*?;//gos;
 	# strip attributes
 	$members =~ s/__aligned\s*\(\d+\)//gos;
+	$members =~ s/__attribute__\s*\(\([a-zA-Z,_()\s\*]*\)\)//gos;


If yours (below) does what is needed, that's fine with me.

>  scripts/kernel-doc |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- wireless-testing.orig/scripts/kernel-doc	2010-08-19 16:11:40.000000000 +0200
> +++ wireless-testing/scripts/kernel-doc	2010-08-19 16:11:45.000000000 +0200
> @@ -1679,7 +1679,7 @@ sub check_sections($$$$$$) {
>  		foreach $px (0 .. $#prms) {
>  			$prm_clean = $prms[$px];
>  			$prm_clean =~ s/\[.*\]//;
> -			$prm_clean =~ s/__attribute__\s*\(\([a-z,_\*\s\(\)]*\)\)//;
> +			$prm_clean =~ s/__attribute__\s*\(\([a-z,_\*\s\(\)]*\)\)//i;
>  			# ignore array size in a parameter string;
>  			# however, the original param string may contain
>  			# spaces, e.g.:  addr[6 + 2]
> 
> 
> --


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
