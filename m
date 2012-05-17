Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089Ab2EQUyK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 16:54:10 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:56677 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756528Ab2EQUyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 16:54:09 -0400
Message-ID: <1337288048.17726.64.camel@joe2Laptop>
Subject: Re: [PATCH 1/1] checkpatch: don't fake typedefs with #define
From: Joe Perches <joe@perches.com>
To: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: linux-kernel@vger.kernel.org, apw@canonical.com
Date: Thu, 17 May 2012 13:54:08 -0700
In-Reply-To: <1337259132-28774-1-git-send-email-ext-phil.2.carmody@nokia.com>
References: <1337259132-28774-1-git-send-email-ext-phil.2.carmody@nokia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-17 at 15:52 +0300, Phil Carmody wrote:
> People seemed to be taking the "no typedefs" rule too literally,
> and were using #define to abide by the letter rather than the
> spirit of the law. E.g. #define FOO_t struct _FOO_t
> 
> Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
> ---
>  scripts/checkpatch.pl |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index faea0ec..7dc41c5 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2299,6 +2299,12 @@ sub process {
>  			     "do not add new typedefs\n" . $herecurr);
>  		}
>  
> +# check for deliberate avoidance of the above anti-typedef rule
> +		if ($line =~ /#\s*define\s+$Ident\s+$Type\b/) {
> +			WARN("NEW_TYPEDEFS",
> +			     "do not fake typedefs using #define\n" . $herecurr);
> +		}
> +

I think the false positive rate is pretty high.
I used this and don't see too many I'd remove.

$ git grep -E "#\s*define\s+\w+\s+(struct|unsigned|char|short|int|long|const)\b"

Got an example you want this to find?


