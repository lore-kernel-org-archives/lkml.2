Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811Ab0GNNOw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 09:14:52 -0400
Received: from adelie.canonical.com ([91.189.90.139]:34118 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818Ab0GNNOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 09:14:51 -0400
Date: Wed, 14 Jul 2010 14:14:47 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Joe Perches <joe@perches.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Possible false positive from checkpatch.pl
Message-ID: <20100714131447.GC20746@shadowen.org>
References: <4C3B5660.8020405@lwfinger.net>
 <1278959315.1501.261.camel@Joe-Laptop.home>
 <4C3B608B.9010501@lwfinger.net>
 <1278961381.1501.284.camel@Joe-Laptop.home>
 <4C3B6F03.8060708@lwfinger.net>
 <1278964147.1501.291.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278964147.1501.291.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 12, 2010 at 12:49:07PM -0700, Joe Perches wrote:
> On Mon, 2010-07-12 at 14:37 -0500, Larry Finger wrote:
> > On 07/12/2010 02:03 PM, Joe Perches wrote:
> > > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> > > index bd88f11..7e8a3f4 100755
> > > --- a/scripts/checkpatch.pl
> > > +++ b/scripts/checkpatch.pl
> > > @@ -2394,8 +2394,10 @@ sub process {
> > >   			}x;
> > >   			#print "REST<$rest>  dstat<$dstat>\n";
> > >   			if ($rest ne '') {
> > > -				if ($rest !~ /while\s*\(/&&
> > > -				    $dstat !~ /$exceptions/)
> > > +				if ($rest eq ",") {
> > > +					ERROR("Macros should not end with a trailing comma\n" . "$here\n$ctx\n");
> > > +				} elsif ($rest !~ /while\s*\(/&&
> > > +					 $dstat !~ /$exceptions/)
> > >   				{
> > >   					ERROR("Macros with multiple statements should be enclosed in a do - while loop\n" . "$here\n$ctx\n");
> > >   			}
> > 
> > That looks good. At least it makes clear what is wrong.
> > Should it be an error, or just a warning?
> 
> I don't much care.
> 
> If Andy wants to do anything, let him decide.
> 
> Perhaps the new test should be
> 	if ($rest =~ /\s*,\s*$/)

I am not sure these are even invalid are they?  Macro abuse of this sort
is always going to throw up exceptions.  Hrmm.

-apw
