Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132Ab1CVUVG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 16:21:06 -0400
Received: from mail.perches.com ([173.55.12.10]:4223 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754936Ab1CVUVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 16:21:04 -0400
Subject: Re: checkpatch: introduce --nocs to disable CodingStyle warnings.
From: Joe Perches <joe@perches.com>
To: Dave Jones <davej@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Jonathan Corbet <corbet@lwn.net>,
        Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110322195831.GA15838@redhat.com>
References: <1300416744.16880.904.camel@gandalf.stny.rr.com>
	 <20110317211548.646b04d2@tpl.lwn.net> <20110319193954.GA2032@redhat.com>
	 <1300713980.16880.5813.camel@gandalf.stny.rr.com>
	 <20110322195831.GA15838@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Mar 2011 13:21:01 -0700
Message-ID: <1300825261.24885.35.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-22 at 15:58 -0400, Dave Jones wrote:
> How about this ?  running checkpatch with --nocs will now only print
> non-CodingStyle related warnings.   I may have missed some of the
> conversions, but this seems to silence the more egregious 'noise'.
> Signed-off-by: Dave Jones <davej@redhat.com>

Hi Dave.

Trivia only:

> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 58848e3..a2b0086 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -19,6 +19,7 @@ my $tree = 1;
>  my $chk_signoff = 1;
>  my $chk_patch = 1;
>  my $tst_only;
> +my $nocs = 0;

To match the other checkpatch control flag uses,
I think this would be better as:

my $chk_style = 1;

> @@ -55,6 +56,7 @@ Options:

+  --style               display warnings about CodingStyle.

etc...

> @@ -80,6 +82,7 @@ GetOptions(
>  
>  	'debug=s'	=> \%debug,
>  	'test-only=s'	=> \$tst_only,
> +	'nocs'		=> \$nocs,

'style!' => \$chk_style,

etc...

And the command line use would be --nostyle

cheers, Joe

