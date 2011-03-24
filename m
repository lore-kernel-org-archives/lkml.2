Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932693Ab1CXPkS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 11:40:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:28238 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756912Ab1CXPkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 11:40:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,237,1299484800"; 
   d="scan'208";a="724670879"
Date: Thu, 24 Mar 2011 08:40:10 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC] checkpatch: add option to change warning return value.
Message-ID: <20110324154010.GA863@xanatos>
References: <20110322231310.GA7338@xanatos>
 <20110322232246.GA7450@xanatos>
 <20110323014117.GA15728@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110323014117.GA15728@home.goodmis.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 09:41:17PM -0400, Steven Rostedt wrote:
> On Tue, Mar 22, 2011 at 04:22:46PM -0700, Sarah Sharp wrote:
> > > @@ -1096,6 +1099,9 @@ sub report {
> > >  
> > >  	push(our @report, $line);
> > >  
> > > +	if ($lazy == 1) {
> > > +		return 0;
> > > +	}
> > >  	return 1;
> > >  }
> > >  sub report_dump {
> 
> Instead of this hunk, have:
> 
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 58848e3..54ec3d9 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -316,7 +316,7 @@ for my $filename (@ARGV) {
>  	}
>  	close($FILE);
>  	if (!process($filename)) {
> -		$exit = 1;
> +		$exit = 1 if (!$lazy);
>  	}
>  	@rawlines = ();
>  	@lines = ();

Hmm, but isn't that going to skip returning an exit value if there's an
error as well?  I really do want it to fail if there's an error, just
not if there's a warning.

Sarah Sharp
