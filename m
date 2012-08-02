Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab2HBQpH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 12:45:07 -0400
Received: from nm9-vm1.bullet.mail.ukl.yahoo.com ([217.146.183.241]:48151 "HELO
	nm9-vm1.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753053Ab2HBQpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 12:45:05 -0400
X-Yahoo-Newman-Id: 571953.84495.bm@smtp117.mail.ukl.yahoo.com
X-Yahoo-Newman-Property: ymail-5
X-YMail-OSG: Z_SNJM0VM1mD7dhiyV8xV2h9ZS_H088O713wnz.mHP4cdlp
 1YGo_zWfpM4ypxT4Q7sC4mfZo1qp7FaL1GF32MBGrcGZlcOxO2qcqN1_a5BL
 IhOrjxYHfT5ORp0CFAj6_cPRxQMEvpJiR_KHRzbZGFKHxQp5iySoAFrzxq6c
 4IrqRRZqt6o4TNsKtFYM0zFJ6s0r9iHnIwZxpMQKW1hXvdyksFchhESO_oH9
 7j4T36KRhjCnjvWHE8tD9iIKC.zibkeiSFW9CDFdk_JZEAhwNS1xNB4.rSFk
 SLUghdKXyyMgnwFHu64OgJec.HaAdqDmf3mXDSD74r5CFJKaCefw3C0.Qv1M
 nWsF24kpU.uGbsqE5dxQ.pi3G7HNKMi4B33mSJB18nsFdADMLdyoO0OG2wDn
 ln_CtrKphFTdMw1.RtPRn83WFBudVGEiHXiSrKLkTnNLRxHHZwiD9S9SqXo6
 THlU-
X-Yahoo-SMTP: mOFZFAuswBAG4_8a4ZBj.Wmvw2Qxc4R7nmE-
From: Schrober <franzschrober@yahoo.de>
To: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] checkpatch: Add control statement test to SINGLE_STATEMENT_DO_WHILE_MACRO
Date: Thu, 02 Aug 2012 18:44:57 +0200
Message-ID: <14936868.DMgLzkV3C3@bentobox>
User-Agent: KMail/4.8.4 (Linux/3.2.0-3-amd64; KDE/4.8.4; x86_64; ; )
In-Reply-To: <20120802162322.GI2501@dm>
References: <4204029.7cYAuJfu4T@bentobox> <1343921213.2011.9.camel@joe2Laptop> <20120802162322.GI2501@dm>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 August 2012 17:23:22 Andy Whitcroft wrote:
> > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> > index 913d6bd..ca05ba2 100755
> > --- a/scripts/checkpatch.pl
> > +++ b/scripts/checkpatch.pl
> > @@ -3016,7 +3016,8 @@ sub process {
> > 
> >  					$herectx .= raw_line($linenr, $n) . "\n";
> >  				
> >  				}
> > 
> > -				if (($stmts =~ tr/;/;/) == 1) {
> > +				if (($stmts =~ tr/;/;/) == 1 &&
> > +				    $stmts !~ /^\s*(if|while|for|switch)\b/) {
> > 
> >  					WARN("SINGLE_STATEMENT_DO_WHILE_MACRO",
> >  					
> >  					     "Single statement macros should not use a do {} while 
(0)
> >  					     loop\n" . "$herectx");>  				
> >  				}
> 
> Looks reasonable enough.
> 
> Acked-by: Andy Whitcroft <apw@canonical.com>

Works well for me, thanks

Just as note: I think this test was accidently added twice. Once in commit 
b13edf7ff2dd0fef95e981170fa71fa6b60421b0 and one time in 
7d64ef43914a734990e48a80bc60686c8db21946 (just checked linux-next, and Stephen 
added it again). Maybe Andrew Morton's tree is out of sync.
-- 
Franz Schrober
