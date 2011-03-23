Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab1CWBlX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 21:41:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50994 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983Ab1CWBlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 21:41:19 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=XYJHFtupD_QA:10 a=PRQypbUqLZAA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=rBqKXwtHASNTJJrN6uUA:9 a=SctjXO98_HmxAHDNPc8_89dpD74A:4 a=CjuIK1q_8ugA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Tue, 22 Mar 2011 21:41:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC] checkpatch: add option to change warning return value.
Message-ID: <20110323014117.GA15728@home.goodmis.org>
References: <20110322231310.GA7338@xanatos>
 <20110322232246.GA7450@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110322232246.GA7450@xanatos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 04:22:46PM -0700, Sarah Sharp wrote:
> 
> BTW, I'm not a perl hacker, and I don't really understand the reporting code,
> so someone who knows it (Andy?) should make the correct patch.  I didn't notice
> before sending, but right now the warning count reporting is bogus, although
> the warnings don't make the script return an error code:
> 

> 
> 
> Note that second-to-last patch should have said 3 warnings.  So my patch needs
> to be changed, but I really do want this functionality.
> 

> > @@ -1096,6 +1099,9 @@ sub report {
> >  
> >  	push(our @report, $line);
> >  
> > +	if ($lazy == 1) {
> > +		return 0;
> > +	}
> >  	return 1;
> >  }
> >  sub report_dump {

Instead of this hunk, have:


diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 58848e3..54ec3d9 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -316,7 +316,7 @@ for my $filename (@ARGV) {
 	}
 	close($FILE);
 	if (!process($filename)) {
-		$exit = 1;
+		$exit = 1 if (!$lazy);
 	}
 	@rawlines = ();
 	@lines = ();


-- Steve

