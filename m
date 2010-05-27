Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759500Ab0E0SuO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 14:50:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60731 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756656Ab0E0SuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 14:50:11 -0400
X-Authority-Analysis: v=1.1 cv=WC2cwRI/KXdLNEmE8ivg2cmI8vFt6dWmaZdvaJ93QHU= c=1 sm=0 a=Dwj94tMcmnEA:10 a=UBIxAjGgU1YA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=_4JdDZT890xhelYK684A:9 a=HcTPAvR26G4G1iAMsVmppoXyNmIA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] streamline_config.pl: use references rather than
 copied data structures
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: zippel@linux-m68k.org, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <201005271624.44746.toralf.foerster@gmx.de>
References: <201005271342.09066.toralf.foerster@gmx.de>
	 <1274965649.22648.263.camel@gandalf.stny.rr.com>
	 <201005271624.44746.toralf.foerster@gmx.de>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 27 May 2010 14:50:07 -0400
Message-ID: <1274986207.22648.268.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-27 at 16:24 +0200, Toralf Förster wrote:
> Steven Rostedt wrote at 15:07:29
> > On Thu, 2010-05-27 at 13:42 +0200, Toralf Förster wrote:

> Understood and accepted.
> 
> What's about the following 2 snippets (a trivial typo and an attempt to 
> prevent a possible trap) ? :
> 

OK, this is better :-)

-- Steve

> 
> diff --git a/scripts/kconfig/streamline_config.pl 
> b/scripts/kconfig/streamline_config.pl
> index afbd54a..3f54911 100644
> --- a/scripts/kconfig/streamline_config.pl
> +++ b/scripts/kconfig/streamline_config.pl
> @@ -242,7 +242,7 @@ foreach my $makefile (@makefiles) {
>             foreach my $obj (split /\s+/,$objs) {
>                 $obj =~ s/-/_/g;
>                 if ($obj =~ /(.*)\.o$/) {
> -                   # Objects may bes enabled by more than one config.
> +                   # Objects may be enabled by more than one config.
>                     # Store configs in an array.
>                     my @arr;
> 
> 
> 
> diff --git a/scripts/kconfig/streamline_config.pl 
> b/scripts/kconfig/streamline_config.pl
> index afbd54a..9726946 100644
> --- a/scripts/kconfig/streamline_config.pl
> +++ b/scripts/kconfig/streamline_config.pl
> @@ -307,7 +307,7 @@ close (LIN);
>  my %configs;
>  foreach my $module (keys(%modules)) {
>      if (defined($objects{$module})) {
> -       @arr = @{$objects{$module}};
> +       my @arr = @{$objects{$module}};
>         foreach my $conf (@arr) {
>             $configs{$conf} = $module;
>         }
> 
> 


