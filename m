Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015Ab3ADPUD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 10:20:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6668 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754899Ab3ADPT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 10:19:59 -0500
Date: Fri, 4 Jan 2013 10:19:50 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Jovi Zhang <bookjovi@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] ktap: Another dynamic tracing tool for Linux
Message-ID: <20130104151950.GB21860@redhat.com>
References: <CACV3sb+69VQMM44vXx_-AdOZmbz18zZeVdmi1+YHEq7kZ_VmdA@mail.gmail.com> <y0mliceujz4.fsf@fche.csb> <CACV3sbKk3euv8N4SbBegJ=iYuUxfdynZ_1GNtfkwGzwGDcqATw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACV3sbKk3euv8N4SbBegJ=iYuUxfdynZ_1GNtfkwGzwGDcqATw@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

bookjovi wrote:

> >> [...]
> >> ktap use lua language syntax and bytecode as initial implementation,
> >
> > Interesting approach.  I recall we considered it way back when, but
> > rejected it for a couple of reasons, including the at-the-time
> > perceived unwelcomeness of a serious bytecode interpreter within the
> > kernel.

> [...]  Obviously, the bytecode design is the biggest differences
> with systemtap.  [...]  many Linux box doesn't deliver with gcc,
> this is very common in embedded device, even there installed gcc,
> but it's hard(impossible) to get matched kernel source.  [...]

Right, that is a strong attraction.


> [...]  On clear that, ktap is not a replacement to systemtap, it's
> supplementation.

FWIW, it would be reasonable to have systemtap emit bytecodes as an
alternative backend.  All that has been lacking is a powerful and
pervasive enough interpreter.  The script language is not tied to its
implementation via C code generation.


That reminds me of your item #4 on your ktap-systemtap comparison:

> 4). ktap is safe, whatever you doing in script file, you will never
> crash your kernel.

This is roughly as true for systemtap as for anything else.  The
scripts are constrainted to be safe.  Kernel crashes that occur are
due to occasional bugs in the systemtap runtime library, or down in
the kernel facilities being used.  You would likely encounter both
classes of problems in a kernel-side bytecode interpreter, regardless
of the theoretical safety of the scripting language.  (This is one of
the reasons we've been building out the pure-userspace dyninst-based
systemtap backend.)


> I will try to make ktap develop progress more faster, and make ktap
> source code public available soon.

Yes, please.  (RFC/experimental code need not be complete before
posting; why not develop straight on github?)


- FChE
