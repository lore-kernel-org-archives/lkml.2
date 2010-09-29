Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab0I2HVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 03:21:31 -0400
Received: from mail.vyatta.com ([76.74.103.46]:49642 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114Ab0I2HV3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 03:21:29 -0400
Date: Wed, 29 Sep 2010 00:14:58 -0700 (PDT)
From: Stephen Hemminger <stephen.hemminger@vyatta.com>
To: =?utf-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org
Message-ID: <635705110.22841.1285744498655.JavaMail.root@tahiti.vyatta.com>
In-Reply-To: <20100929070631.GE5169@cr0.nay.redhat.com>
Subject: Re: [PATCH 1/2] namespace.pl: fix source tree name mangling
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [203.112.11.42]
X-Mailer: Zimbra 6.0.6_GA_2330.RHEL5_64 (ZimbraWebClient - FF3.0 (Linux)/6.0.6_GA_2330.RHEL5_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> On Wed, Sep 29, 2010 at 03:06:45PM +0900, Stephen Hemminger wrote:
> >On Wed, 29 Sep 2010 14:04:27 +0800
> >Américo Wang <xiyou.wangcong@gmail.com> wrote:
> >
> >> On Wed, Sep 29, 2010 at 02:11:53PM +0900, Stephen Hemminger wrote:
> >> >On Wed, 29 Sep 2010 12:31:12 +0800
> >> >Américo Wang <xiyou.wangcong@gmail.com> wrote:
> >> >
> >> >> On Tue, Sep 28, 2010 at 05:44:02PM +0900, Stephen Hemminger
> >> >> wrote:
> >> >> >The current namespace.pl script does not find source files
> >> >> >correctly. The problem is that the current directory is not the
> >> >> >base of the kernel
> >> >> >tree at the point where it calls objdump.
> >> >> >
> >> >> >Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
> >> >> >
> >> >> >--- a/scripts/namespace.pl 2010-09-27 17:53:29.919433444 +0900
> >> >> >+++ b/scripts/namespace.pl 2010-09-28 09:24:36.891552993 +0900
> >> >> >@@ -167,8 +167,10 @@ sub do_nm
> >> >> > 		printf STDERR "$fullname is not an object file\n";
> >> >> > 		return;
> >> >> > 	}
> >> >> >- ($source = $fullname) =~ s/\.o$//;
> >> >> >- if (-e "$objtree$source.c" || -e "$objtree$source.S") {
> >> >> >+ $fullname =~ s/\.o$//;
> >> >> >+ $source = $basename;
> >> >> >+ $source =~ s/\.o$//;
> >> >>
> >> >> With your patch applied, $source will be the basename of
> >> >> an obj path with .o stripped.
> >> >>
> >> >> >+ if (-e "$objtree$fullname.c" || -e "$objtree$fullname.S") {
> >> >> > 		$source = "$objtree$source";
> >> >> > 	} else {
> >> >> > 		$source = "$srctree$source";
> >> >> >
> >> >>
> >> >> So here we will get a non-exist path stored in $source.
> >> >>
> ...
> >>
> >> I see, the docs of Find module said it will do chdir. :)
> >> But I think your patch is still not right, how about the
> >> one below?
> >
> >Please be more precise about "not right"? It makes the code
> >work.
> >
> 
> Hmm? $srctree is the path of top source code, and $source
> is the basename of an object, so dirname is missed, no?

No. it works, please stop speculating and use a debugger or demonstrate
what you think the problem is.

