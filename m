Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758541Ab2CVQWk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 12:22:40 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:49594 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836Ab2CVQWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 12:22:39 -0400
Message-ID: <4F6B51C9.6010904@suse.cz>
Date: Thu, 22 Mar 2012 17:22:33 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120320 Thunderbird/13.0a2
MIME-Version: 1.0
To: Phil Carmody <ext-phil.2.carmody@nokia.com>
CC: apw@canonical.com, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] checkpatch.pl: thou shalt not use () or (...) in
 function declarations
References: <1332430038-21057-1-git-send-email-ext-phil.2.carmody@nokia.com>
In-Reply-To: <1332430038-21057-1-git-send-email-ext-phil.2.carmody@nokia.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2012 04:27 PM, Phil Carmody wrote:
> After HPA's wonderful lkml post, referenced, it seems worth trying to
> detect this robomatically.
> 
> Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
> ---
>  scripts/checkpatch.pl |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index a3b9782..3993011 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -1881,6 +1881,10 @@ sub process {
>  				substr($ctx, 0, $name_len + 1, '');
>  				$ctx =~ s/\)[^\)]*$//;
>  
> +				if ($ctx =~ /^\s*(?:\.\.\.)?\s*$/) {
> +					# HPA explains why: http://lwn.net/Articles/487493/
> +					ERROR("(...) and () are not sufficiently informative function declarations\n$hereline");
> +				}

That explanation is not fully correct. C99 explicitly says (6.7.5.3.14):
An identifier list declares only the identifiers of the parameters of
the function. An empty list in a function declarator that is part of a
definition of that function specifies that the function has no
parameters. The empty list in a function declarator that is not part of
a definition of that function specifies that no information about the
number or types of the parameters is supplied.

So what you are trying to force here holds only for (forward)
declarations. Not for functions with definitions (bodies). Is checkpatch
capable to differ between those?

thanks,
-- js suse labs

