Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab2KPTzI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 14:55:08 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57618 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab2KPTzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 14:55:06 -0500
Date: Fri, 16 Nov 2012 11:55:04 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Eilon Greenstein <eilong@broadcom.com>
cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] checkpatch: add double empty line check
In-Reply-To: <1353094919.14327.4.camel@lb-tlvb-eilong.il.broadcom.com>
Message-ID: <alpine.DEB.2.00.1211161154280.2788@chino.kir.corp.google.com>
References: <1353094919.14327.4.camel@lb-tlvb-eilong.il.broadcom.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Nov 2012, Eilon Greenstein wrote:

> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 21a9f5d..7a9c153 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -3579,6 +3579,13 @@ sub process {
>  			WARN("EXPORTED_WORLD_WRITABLE",
>  			     "Exporting world writable files is usually an error. Consider more restrictive permissions.\n" . $herecurr);
>  		}
> +
> +# check for double empty lines
> +		if ($line =~ /^\+\s*$/ &&
> +		    ($prevline =~ /^\+?\s*$/ || $rawlines[$linenr] =~ /^\s*$/)) {
> +			WARN("DOUBLE_EMPTY_LINE",
> +			     "One empty line should be sufficient. Consider removing this one.\n" . $herecurr);
> +		}
>  	}
>  
>  	# If we have no input at all, then there is nothing to report on

This is fairly common in all the acpi code where variables declared in a 
function are separated from the code in a function.
