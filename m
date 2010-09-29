Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751249Ab0I2E0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 00:26:42 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:52818 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab0I2E0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 00:26:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=M0RiAzuDEFhFAJqE2vv+lRFb/5/6xRKynKeUJrP53Vv8n6tJruiIjNl4/grc6rhtK+
         XY+UPLbKvX+xgcjJHiDT9PW+nTfn80ILw/7Npo6YWMuXu36jFgYb6BYh7cundi2uoh9V
         QL6v7N9ufYx/niXQBlH43QxDSnu3a3ZwSAguc=
Date: Wed, 29 Sep 2010 12:31:12 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] namespace.pl: fix source tree name mangling
Message-ID: <20100929043112.GB5169@cr0.nay.redhat.com>
References: <20100928084400.997539242@vyatta.com>
 <20100928084528.884369764@vyatta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100928084528.884369764@vyatta.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 05:44:02PM +0900, Stephen Hemminger wrote:
>The current namespace.pl script does not find source files correctly.
>The problem is that the current directory is not the base of the kernel
>tree at the point where it calls objdump.
>
>Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
>
>--- a/scripts/namespace.pl	2010-09-27 17:53:29.919433444 +0900
>+++ b/scripts/namespace.pl	2010-09-28 09:24:36.891552993 +0900
>@@ -167,8 +167,10 @@ sub do_nm
> 		printf STDERR "$fullname is not an object file\n";
> 		return;
> 	}
>-	($source = $fullname) =~ s/\.o$//;
>-	if (-e "$objtree$source.c" || -e "$objtree$source.S") {
>+	$fullname =~ s/\.o$//;
>+	$source = $basename;
>+	$source =~ s/\.o$//;

With your patch applied, $source will be the basename of
an obj path with .o stripped.

>+	if (-e "$objtree$fullname.c" || -e "$objtree$fullname.S") {
> 		$source = "$objtree$source";
> 	} else {
> 		$source = "$srctree$source";
>

So here we will get a non-exist path stored in $source.

Are you serious? What problem did you meet? I see no problem
with the original code here.

Thanks.

