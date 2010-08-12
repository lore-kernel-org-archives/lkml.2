Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761057Ab0HLW6e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 18:58:34 -0400
Received: from cantor.suse.de ([195.135.220.2]:40223 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489Ab0HLW6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 18:58:32 -0400
Date: Fri, 13 Aug 2010 00:56:13 +0200
From: Michal Marek <mmarek@suse.cz>
To: Milton Miller <miltonm@bga.com>
Cc: gentoo@mgorny.alt.pl, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] setlocalversion: fix version for untaged nontip
 mercurial revs
Message-ID: <20100812225613.GB19690@sepie.suse.cz>
References: <fix-hg-id-resend1@mdm.bga.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fix-hg-id-resend1@mdm.bga.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 10:19:38AM -0500, Milton Miller wrote:
> The manpage for cut says it will return all lines without the delimiter
> unless -s is specified.
> 
> When I backed up my mecurial tree to generate modules, I found that the
> scm part of localversion was turning up blank.
> 
> Signed-off-by: Milton Miller <miltonm@bga.com>
> Cc: Michal Marek <mmarek@suse.cz>
> Cc: "Michał Górny" <gentoo@mgorny.alt.pl>
> 
> ---
> This version is against linux next-20100721.  The diff against 35-rc
> would be shifted left one tab stop and have different line numbers, should
> this be sent to stable.
> 
> Resend without 8-bit characters (maintainers name) in header
> Added linux-kbuild@vger.kernel.org which get-maintainer did not
> 
> diff --git a/scripts/setlocalversion b/scripts/setlocalversion
> index a7b9f76..872312f 100755
> --- a/scripts/setlocalversion
> +++ b/scripts/setlocalversion
> @@ -86,7 +86,7 @@ scm_version()
>  
>  	# Check for mercurial and a mercurial repo.
>  	if hgid=`hg id 2>/dev/null`; then
> -		tag=`printf '%s' "$hgid" | cut -d' ' -f2`
> +		tag=`printf '%s' "$hgid" | cut -s -d' ' -f2`
>  
>  		# Do we have an untagged version?
>  		if [ -z "$tag" -o "$tag" = tip ]; then

Sorry, I somehow missed this patch. I applied it now.

Michal
