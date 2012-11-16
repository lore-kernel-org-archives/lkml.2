Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab2KPUGB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 15:06:01 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:2199 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753367Ab2KPUGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 15:06:00 -0500
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
Message-ID: <1353096274.14327.9.camel@lb-tlvb-eilong.il.broadcom.com>
Subject: Re: [PATCH] checkpatch: add double empty line check
From: "Eilon Greenstein" <eilong@broadcom.com>
Reply-to: eilong@broadcom.com
To: "David Rientjes" <rientjes@google.com>, "Joe Perches" <joe@perches.com>
cc: "Andy Whitcroft" <apw@canonical.com>, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Date: Fri, 16 Nov 2012 22:04:34 +0200
In-Reply-To: <alpine.DEB.2.00.1211161154280.2788@chino.kir.corp.google.com>
References: <1353094919.14327.4.camel@lb-tlvb-eilong.il.broadcom.com>
 <alpine.DEB.2.00.1211161154280.2788@chino.kir.corp.google.com>
Organization: Broadcom
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-Version: 1.0
X-WSS-ID: 7CB843A51QK3683694-04-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-16 at 11:55 -0800, David Rientjes wrote:
> On Fri, 16 Nov 2012, Eilon Greenstein wrote:
> 
> > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> > index 21a9f5d..7a9c153 100755
> > --- a/scripts/checkpatch.pl
> > +++ b/scripts/checkpatch.pl
> > @@ -3579,6 +3579,13 @@ sub process {
> >  			WARN("EXPORTED_WORLD_WRITABLE",
> >  			     "Exporting world writable files is usually an error. Consider more restrictive permissions.\n" . $herecurr);
> >  		}
> > +
> > +# check for double empty lines
> > +		if ($line =~ /^\+\s*$/ &&
> > +		    ($prevline =~ /^\+?\s*$/ || $rawlines[$linenr] =~ /^\s*$/)) {
> > +			WARN("DOUBLE_EMPTY_LINE",
> > +			     "One empty line should be sufficient. Consider removing this one.\n" . $herecurr);
> > +		}
> >  	}
> >  
> >  	# If we have no input at all, then there is nothing to report on
> 
> This is fairly common in all the acpi code where variables declared in a 
> function are separated from the code in a function.
> 

Indeed, I see that you do use it in some functions.

Maybe we can limit it only to the networking tree (similar to the
networking comments style) or if the ACPI is the exception, we can apply
to all but ACPI.


