Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab2LSNbY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 08:31:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43364 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221Ab2LSNbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 08:31:17 -0500
Date: Wed, 19 Dec 2012 13:31:07 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] checkpatch: Warn on uapi #includes that #include
 <uapi/...
Message-ID: <20121219133107.GZ8798@dm>
References: <28860.1355870146@warthog.procyon.org.uk>
 <836be70329567778096e6a5b9e898a85238b382c.1355879564.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <836be70329567778096e6a5b9e898a85238b382c.1355879564.git.joe@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 05:30:58PM -0800, Joe Perches wrote:
> Avoid specifying internal uapi #include paths with uapi/...
> as userspace should not use and never see that.
> 
> Neaten message line wrapping above.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> cc: David Howells <dhowells@redhat.com>
> ---
>  scripts/checkpatch.pl |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 054a293..5eab67e 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2238,8 +2238,11 @@ sub process {
>  			my $path = $1;
>  			if ($path =~ m{//}) {
>  				ERROR("MALFORMED_INCLUDE",
> -				      "malformed #include filename\n" .
> -					$herecurr);
> +				      "malformed #include filename\n" . $herecurr);
> +			}
> +			if ($path =~ "^uapi/" && $realfile =~ m@\binclude/uapi/@) {
> +				ERROR("UAPI_INCLUDE",
> +				      "No #include in ...include/uapi/... should use a uapi/ path prefix\n" . $herecurr);
>  			}
>  		}
>  

Looks reasonable indeed.

Acked-by: Andy Whitcroft <apw@canonical.com>

-apw
