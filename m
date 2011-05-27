Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab1E0SSu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 14:18:50 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:33697 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753034Ab1E0SSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 14:18:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Dm3QdIgoT65E75ALyI6sgp/79QUOrR+NAzzMqzQsoerEiHOvUAYjvTusc0Qa8/Wxv4XYfgQ90Ijysygq991FpPg8jxQTiEalARN5agyCPoe+uon6Zox9Ut5ZjChTWSlb;
Date: Fri, 27 May 2011 11:18:46 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: anish <anish198519851985@gmail.com>, joe@perches.com, davej@redhat.com,
        apw@shadowen.org, akpm@linux-foundation.org, vapier@gentoo.org,
        linux-kernel@vger.kernel.org, man.k1983@gmail.com
Subject: Re: [patch v4] checkpatch: Signature format verification
Message-Id: <20110527111846.eb41d093.rdunlap@xenotime.net>
In-Reply-To: <1306520217.3857.31.camel@gandalf.stny.rr.com>
References: <1306006721.1622.18.camel@anish-desktop>
	<1306059528.2761.3.camel@anish-desktop>
	<1306164094.2292.25.camel@anish-desktop>
	<1306519311.1918.12.camel@anish-desktop>
	<1306520217.3857.31.camel@gandalf.stny.rr.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 May 2011 14:16:57 -0400 Steven Rostedt wrote:

> On Fri, 2011-05-27 at 23:31 +0530, anish wrote:
> > From: anish kumar <anish198519851985@gmail.com>
> > 
> 
> > +		my ($sign,$loop_brk);
> > +		my @signs = ("Reviewed-by:","Acked-by:","Signed-off-by:","Tested-by:");
> > +		foreach $sign (@signs) {
> > +			$loop_brk=0;
> > +			if ($line =~ /^\s*$sign/i) {
> > +				# This is a signoff, if ugly, so do not double report.
> > +				$signoff++;
> > +				$loop_brk++;
> > +				if (!($line =~ /^\s*$sign/)) {
> > +					WARN("$sign is the preferred form\n" .
> > +						$herecurr);
> > +				}
> > +				if ($line =~ /^\s*$sign(.*)/i) {
> > +					if ($1 !~ /^\s+([a-zA-Z\s\"\.\-\'\,]*.*)/i) {
> > +						WARN("Space required after $sign\n" .
> > +							$herecurr);
> > +					}
> > +					if ($1 !~ /([\sa-zA-Z\"\.\-\'\,]*)\s<.*>/i) {
> > +						WARN("Space required b/w Full Name & Mail-id:\n" .
> 
> What's "b/w" black and white?

I _think_ that it's "between", but I already requested that it
be changed.  It's not good.  :(


> Also do we check for <>. As the above will trigger for missing <> and
> give a warning about spaces.
> 
> I once had my quilt mail send crap to LKML because one of the Cc's in a
> patch I pulled was missing the ending ">".
> 
> -- Steve
> 
> > +							$herecurr);
> > +					}
> > +				}
> >  			}
> > +			last if ($loop_brk == 1);
> >  		}
> > -
> >  # Check for wrappage within a valid hunk of the file
> >  		if ($realcnt != 0 && $line !~ m{^(?:\+|-| |\\ No newline|$)}) {
> >  			ERROR("patch seems to be corrupt (line wrapped?)\n" .


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
