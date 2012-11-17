Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab2KQAu4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 19:50:56 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:40454 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753864Ab2KQAuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 19:50:55 -0500
Message-ID: <1353113454.2512.21.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: add double empty line check
From: Joe Perches <joe@perches.com>
To: eilong@broadcom.com
Cc: David Rientjes <rientjes@google.com>, Andy Whitcroft <apw@canonical.com>,
        linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Date: Fri, 16 Nov 2012 16:50:54 -0800
In-Reply-To: <1353096274.14327.9.camel@lb-tlvb-eilong.il.broadcom.com>
References: <1353094919.14327.4.camel@lb-tlvb-eilong.il.broadcom.com>
	 <alpine.DEB.2.00.1211161154280.2788@chino.kir.corp.google.com>
	 <1353096274.14327.9.camel@lb-tlvb-eilong.il.broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-16 at 22:04 +0200, Eilon Greenstein wrote:
> On Fri, 2012-11-16 at 11:55 -0800, David Rientjes wrote:
> > On Fri, 16 Nov 2012, Eilon Greenstein wrote:
> > 
> > > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> > > index 21a9f5d..7a9c153 100755
> > > --- a/scripts/checkpatch.pl
> > > +++ b/scripts/checkpatch.pl
> > > @@ -3579,6 +3579,13 @@ sub process {
> > >  			WARN("EXPORTED_WORLD_WRITABLE",
> > >  			     "Exporting world writable files is usually an error. Consider more restrictive permissions.\n" . $herecurr);
> > >  		}
> > > +
> > > +# check for double empty lines
> > > +		if ($line =~ /^\+\s*$/ &&
> > > +		    ($prevline =~ /^\+?\s*$/ || $rawlines[$linenr] =~ /^\s*$/)) {
> > > +			WARN("DOUBLE_EMPTY_LINE",
> > > +			     "One empty line should be sufficient. Consider removing this one.\n" . $herecurr);
> > > +		}
> > >  	}
> > >  
> > >  	# If we have no input at all, then there is nothing to report on
> > 
> > This is fairly common in all the acpi code where variables declared in a 
> > function are separated from the code in a function.
> > 
> 
> Indeed, I see that you do use it in some functions.
> 
> Maybe we can limit it only to the networking tree (similar to the
> networking comments style) or if the ACPI is the exception, we can apply
> to all but ACPI.

I'm not sure this should be done.
Double line spacing has some utility and
is pretty common.

Perhaps make this a --strict/CHK option
and also perhaps make sure this isn't
emitted on consecutive lines.


