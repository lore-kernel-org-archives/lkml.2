Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427Ab2GYSPt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 14:15:49 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:59680 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752295Ab2GYSPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 14:15:48 -0400
Message-ID: <50103793.8000600@xenotime.net>
Date: Wed, 25 Jul 2012 11:14:43 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Dan Luedtke <mail@danrl.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/kernel-doc: added support for html5
References: <1343223488-1332-1-git-send-email-mail@danrl.de>
In-Reply-To: <1343223488-1332-1-git-send-email-mail@danrl.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2012 06:38 AM, Dan Luedtke wrote:

> New output option html5 writes validating HTML5 and adds

> CSS classes ready to be selected by third-party stylesheets.
> 
> Signed-off-by: Dan Luedtke <mail@danrl.de>
> ---
>  scripts/kernel-doc |  255 ++++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 249 insertions(+), 6 deletions(-)
> 
> diff --git a/scripts/kernel-doc b/scripts/kernel-doc
> index 9b0c0b8..f85b278 100755
> --- a/scripts/kernel-doc
> +++ b/scripts/kernel-doc
> @@ -182,6 +189,14 @@ my $local_lt = "\\\\\\\\lt:";
>  my $local_gt = "\\\\\\\\gt:";
>  my $blankline_html = $local_lt . "p" . $local_gt;	# was "<p>"
>  
> +# modern html


Just say "html5" or "html version 5".
A few years from now it won't be modern.

> +my %highlights_html5 = ( $type_constant, "<span class=\"const\">\$1</span>",
> +			$type_func, "<span class=\"func\">\$1</span>",
> +			$type_struct_xml, "<span class=\"struct\">\$1</span>",
> +			$type_env, "<span class=\"env\">\$1</span>",
> +			$type_param, "<span class=\"param\">\$1</span>" );
> +my $blankline_html5 = $local_lt . "br /" . $local_gt;
> +
>  # XML, docbook format
>  my %highlights_xml = ( "([^=])\\\"([^\\\"<]+)\\\"", "\$1<quote>\$2</quote>",
>  			$type_constant, "<constant>\$1</constant>",



Have you tested typedef, enum, DOC:, etc.?
The example web page that you posted does not use that AFAICT.


Otherwise it looks OK to me.

Thanks,
-- 
~Randy
