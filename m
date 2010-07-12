Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351Ab0GLTtL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 15:49:11 -0400
Received: from mail.perches.com ([173.55.12.10]:1711 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752119Ab0GLTtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 15:49:10 -0400
Subject: Re: Possible false positive from checkpatch.pl
From: Joe Perches <joe@perches.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4C3B6F03.8060708@lwfinger.net>
References: <4C3B5660.8020405@lwfinger.net>
	 <1278959315.1501.261.camel@Joe-Laptop.home> <4C3B608B.9010501@lwfinger.net>
	 <1278961381.1501.284.camel@Joe-Laptop.home> <4C3B6F03.8060708@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Jul 2010 12:49:07 -0700
Message-ID: <1278964147.1501.291.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-07-12 at 14:37 -0500, Larry Finger wrote:
> On 07/12/2010 02:03 PM, Joe Perches wrote:
> > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> > index bd88f11..7e8a3f4 100755
> > --- a/scripts/checkpatch.pl
> > +++ b/scripts/checkpatch.pl
> > @@ -2394,8 +2394,10 @@ sub process {
> >   			}x;
> >   			#print "REST<$rest>  dstat<$dstat>\n";
> >   			if ($rest ne '') {
> > -				if ($rest !~ /while\s*\(/&&
> > -				    $dstat !~ /$exceptions/)
> > +				if ($rest eq ",") {
> > +					ERROR("Macros should not end with a trailing comma\n" . "$here\n$ctx\n");
> > +				} elsif ($rest !~ /while\s*\(/&&
> > +					 $dstat !~ /$exceptions/)
> >   				{
> >   					ERROR("Macros with multiple statements should be enclosed in a do - while loop\n" . "$here\n$ctx\n");
> >   			}
> 
> That looks good. At least it makes clear what is wrong.
> Should it be an error, or just a warning?

I don't much care.

If Andy wants to do anything, let him decide.

Perhaps the new test should be
	if ($rest =~ /\s*,\s*$/)

cheers, Joe

