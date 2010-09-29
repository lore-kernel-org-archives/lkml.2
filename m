Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090Ab0I2NE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 09:04:27 -0400
Received: from mail.vyatta.com ([76.74.103.46]:46078 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752218Ab0I2NE0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 09:04:26 -0400
Date: Wed, 29 Sep 2010 22:04:20 +0900
From: Stephen Hemminger <shemminger@vyatta.com>
To: =?ISO-8859-1?B?QW3pcmljbw==?= Wang <xiyou.wangcong@gmail.com>
Cc: Stephen Hemminger <stephen.hemminger@vyatta.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] namespace.pl: fix source tree name mangling
Message-ID: <20100929220420.60d799b1@s6510>
In-Reply-To: <20100929093411.GF5169@cr0.nay.redhat.com>
References: <20100929070631.GE5169@cr0.nay.redhat.com>
	<635705110.22841.1285744498655.JavaMail.root@tahiti.vyatta.com>
	<20100929093411.GF5169@cr0.nay.redhat.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Sep 2010 17:34:11 +0800
Américo Wang <xiyou.wangcong@gmail.com> wrote:

> On Wed, Sep 29, 2010 at 12:14:58AM -0700, Stephen Hemminger wrote:
> >
> >
> >----- Original Message -----
> >> On Wed, Sep 29, 2010 at 03:06:45PM +0900, Stephen Hemminger wrote:
> >> >On Wed, 29 Sep 2010 14:04:27 +0800
> >> >Américo Wang <xiyou.wangcong@gmail.com> wrote:
> >> >
> >> >> On Wed, Sep 29, 2010 at 02:11:53PM +0900, Stephen Hemminger wrote:
> >> >> >On Wed, 29 Sep 2010 12:31:12 +0800
> >> >> >Américo Wang <xiyou.wangcong@gmail.com> wrote:
> >> >> >
> >> >> >> On Tue, Sep 28, 2010 at 05:44:02PM +0900, Stephen Hemminger
> >> >> >> wrote:
> >> >> >> >The current namespace.pl script does not find source files
> >> >> >> >correctly. The problem is that the current directory is not the
> >> >> >> >base of the kernel
> >> >> >> >tree at the point where it calls objdump.
> >> >> >> >
> >> >> >> >Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
> >> >> >> >
> >> >> >> >--- a/scripts/namespace.pl 2010-09-27 17:53:29.919433444 +0900
> >> >> >> >+++ b/scripts/namespace.pl 2010-09-28 09:24:36.891552993 +0900
> >> >> >> >@@ -167,8 +167,10 @@ sub do_nm
> >> >> >> > 		printf STDERR "$fullname is not an object file\n";
> >> >> >> > 		return;
> >> >> >> > 	}
> >> >> >> >- ($source = $fullname) =~ s/\.o$//;
> >> >> >> >- if (-e "$objtree$source.c" || -e "$objtree$source.S") {
> >> >> >> >+ $fullname =~ s/\.o$//;
> >> >> >> >+ $source = $basename;
> >> >> >> >+ $source =~ s/\.o$//;
> >> >> >>
> >> >> >> With your patch applied, $source will be the basename of
> >> >> >> an obj path with .o stripped.
> >> >> >>
> >> >> >> >+ if (-e "$objtree$fullname.c" || -e "$objtree$fullname.S") {
> >> >> >> > 		$source = "$objtree$source";
> >> >> >> > 	} else {
> >> >> >> > 		$source = "$srctree$source";
> >> >> >> >
> >> >> >>
> >> >> >> So here we will get a non-exist path stored in $source.
> >> >> >>
> >> ...
> >> >>
> >> >> I see, the docs of Find module said it will do chdir. :)
> >> >> But I think your patch is still not right, how about the
> >> >> one below?
> >> >
> >> >Please be more precise about "not right"? It makes the code
> >> >work.
> >> >
> >> 
> >> Hmm? $srctree is the path of top source code, and $source
> >> is the basename of an object, so dirname is missed, no?
> >
> >No. it works, please stop speculating and use a debugger or demonstrate
> >what you think the problem is.
> >
> 
> Just add a print to see what $source is, after you patch applied,
> I got something like:
> 
> ===>/home/wangcong/linux-2.6/btusb
> 
> I can't see any reason that this is correct. Maybe it works, but
> probably by accident.

What matters is the output of the script, not the value of some internal
variable.

