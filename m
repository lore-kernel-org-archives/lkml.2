Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933719Ab1CXWC2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 18:02:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:9302 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755846Ab1CXWCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 18:02:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,239,1299484800"; 
   d="scan'208";a="724820985"
Date: Thu, 24 Mar 2011 15:02:24 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC] checkpatch: add option to change warning return value.
Message-ID: <20110324220224.GA4604@xanatos>
References: <20110322231310.GA7338@xanatos>
 <20110322232246.GA7450@xanatos>
 <20110323014117.GA15728@home.goodmis.org>
 <20110324154010.GA863@xanatos>
 <1300991029.14261.148.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300991029.14261.148.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 02:23:49PM -0400, Steven Rostedt wrote:
> On Thu, 2011-03-24 at 08:40 -0700, Sarah Sharp wrote:
> > On Tue, Mar 22, 2011 at 09:41:17PM -0400, Steven Rostedt wrote:
> > > On Tue, Mar 22, 2011 at 04:22:46PM -0700, Sarah Sharp wrote:
> > > > > @@ -1096,6 +1099,9 @@ sub report {
> > > > >  
> > > > >  	push(our @report, $line);
> > > > >  
> > > > > +	if ($lazy == 1) {
> > > > > +		return 0;
> > > > > +	}
> > > > >  	return 1;
> > > > >  }
> > > > >  sub report_dump {
> > > 
> > > Instead of this hunk, have:
> > > 
> > > 
> > > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> > > index 58848e3..54ec3d9 100755
> > > --- a/scripts/checkpatch.pl
> > > +++ b/scripts/checkpatch.pl
> > > @@ -316,7 +316,7 @@ for my $filename (@ARGV) {
> > >  	}
> > >  	close($FILE);
> > >  	if (!process($filename)) {
> > > -		$exit = 1;
> > > +		$exit = 1 if (!$lazy);
> > >  	}
> > >  	@rawlines = ();
> > >  	@lines = ();
> > 
> > Hmm, but isn't that going to skip returning an exit value if there's an
> > error as well?  I really do want it to fail if there's an error, just
> > not if there's a warning.
> 
> Ah, I was a bit confused as you had report return 0, which is used by
> both errors and warnings.
> 
> Would you want something like this:
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 58848e3..40cbc2f 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -1109,7 +1109,7 @@ sub ERROR {
>  }
>  sub WARN {
>  	if (report("WARNING: $_[0]\n")) {
> -		our $clean = 0;
> +		our $clean = 0 if (!$lazy);
>  		our $cnt_warn++;
>  	}
>  }

Yes, that's basically what I did in the second revision of the patch,
although I didn't have enough perl skillz to know about the if (!$lazy)
syntax.

Sarah Sharp
