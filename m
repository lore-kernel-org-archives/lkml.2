Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982Ab0E0OYv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 10:24:51 -0400
Received: from mail.gmx.net ([213.165.64.20]:52535 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753220Ab0E0OYs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 10:24:48 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/tgPAVMC7tnPd3o0VTuig+hTvr1UlTVNdVPnBVeb
	2e5CmzKhlcARSl
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: rostedt@goodmis.org
Subject: Re: [PATCH] streamline_config.pl: use references rather than copied data structures
Date: Thu, 27 May 2010 16:24:44 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34; KDE/4.4.3; i686; ; )
Cc: zippel@linux-m68k.org, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <201005271342.09066.toralf.foerster@gmx.de> <1274965649.22648.263.camel@gandalf.stny.rr.com>
In-Reply-To: <1274965649.22648.263.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201005271624.44746.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Steven Rostedt wrote at 15:07:29
> On Thu, 2010-05-27 at 13:42 +0200, Toralf Förster wrote:
> > IMHO there's no need for a copy-by-value
> 
> Hi Toralf,
> 
> I'm sorry but "Your Humble Opinion" is not rational to make changes.
> 
> A change to the code must have a reason other than opinion. You must be
> able to show that there is actual benefit for a change, or at least
> explain it.
> 
> Every time a change is made, there is potential for a new bug to be
> introduced (especially in Perl). So, unless there's actual need for a
> change, don't make one.
> 
> This is not performance critical code. If you are fixing a bug, or
> adding a feature, then sure. But I really don't want changes that do
> nothing but skin the cat a different way.
> 
> Thanks,
> 
> -- Steve

Understood and accepted.

What's about the following 2 snippets (a trivial typo and an attempt to 
prevent a possible trap) ? :


diff --git a/scripts/kconfig/streamline_config.pl 
b/scripts/kconfig/streamline_config.pl
index afbd54a..3f54911 100644
--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -242,7 +242,7 @@ foreach my $makefile (@makefiles) {
            foreach my $obj (split /\s+/,$objs) {
                $obj =~ s/-/_/g;
                if ($obj =~ /(.*)\.o$/) {
-                   # Objects may bes enabled by more than one config.
+                   # Objects may be enabled by more than one config.
                    # Store configs in an array.
                    my @arr;



diff --git a/scripts/kconfig/streamline_config.pl 
b/scripts/kconfig/streamline_config.pl
index afbd54a..9726946 100644
--- a/scripts/kconfig/streamline_config.pl
+++ b/scripts/kconfig/streamline_config.pl
@@ -307,7 +307,7 @@ close (LIN);
 my %configs;
 foreach my $module (keys(%modules)) {
     if (defined($objects{$module})) {
-       @arr = @{$objects{$module}};
+       my @arr = @{$objects{$module}};
        foreach my $conf (@arr) {
            $configs{$conf} = $module;
        }


-- 
MfG/Sincerely
Toralf Förster

pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

