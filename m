Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab1KYRIm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 12:08:42 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:64855 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab1KYRIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 12:08:40 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Shawn Guo <shawn.guo@linaro.org>, Magnus Damm <magnus.damm@gmail.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the arm tree
Date: Fri, 25 Nov 2011 17:08:27 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>,
        Paul Mundt <lethal@linux-sh.org>
References: <20111124115239.ff33728e7e9a99426528c214@canb.auug.org.au> <201111241554.09598.arnd@arndb.de> <CAAQ0ZWQZ4jMjHAKq3O1PXb7kdie5hMSTy68_3hxqnPgXkVgr3w@mail.gmail.com>
In-Reply-To: <CAAQ0ZWQZ4jMjHAKq3O1PXb7kdie5hMSTy68_3hxqnPgXkVgr3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111251708.27486.arnd@arndb.de>
X-Provags-ID: V02:K0:Jw+O+IFmb3l3XG20FXoYFAnCjcKx1Bz5NeJPKGo9upu
 +R3Mo/kcdNlLaBoA4usNJLGkWCB6lRPZnnpQ9IwmxtdGAJPg+P
 yv2DxrPpnw2gTnCvdV+A4QjQVapotw9jbfEkgBWKn9y3NnTeA0
 SXBiT9w2q/a0PO0NjJFaW6ZfennBVcqP6XrUHF+3g/gohAQwR1
 dOrlbMZZkv4e6q2hvH+Ds6dA1UWgMImT4lkUa16S9FmY6Qm42g
 8Jr27I0l0LRBYw0P3m3yEIaoHdbmHbpNWmOzcfAyDbtdfWvNMJ
 tdVstD3yTgyAzi9IqQrF3vLHE9wEopy55OXFu8+qIGKdTto8Qk
 LgFV885IKi346CGqwhv0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 November 2011, Shawn Guo wrote:
> On 24 November 2011 23:54, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Thursday 24 November 2011, Stephen Rothwell wrote:
> >> Hi Arnd,
> >>
> >> Today's linux-next merge of the arm-soc tree got a conflict in
> >> arch/arm/tools/mach-types between commit bb9b25f923fc ("ARM: Update
> >> mach-types") from the arm tree and commit 9b7c547f7747 ("ARM: Update
> >> mach-types to fix mxs build breakage") from the arm-soc tree.
> >>
> >> The arm tree version is a superset of the arm-soc version, so I used that.
> >
> > Thanks for catching this!
> >
> > Shawn, please make sure that any updates to mach-types go only through
> > Russell's tree. Unfortunately I did not realize that this was out of
> > scope when I merged it, otherwise I would have complained yesterday.
> >
> Sorry if I have misunderstood Russell's comment below.
> 
> http://thread.gmane.org/gmane.linux.ports.arm.kernel/139196/focus=140505
> 
> But I thought he would not send patch on mach-types for -rc series.
> That's why I came up with this patch and sent it to you.  After all,
> we do not want to see mxs build breakage in a release.

What Russell said was that he would not send a full update of
the mach-types file during -rc, because that would remove lots
of (broken) entries and consequently cause build regressions.

He did already send a patch 628e1110 "ARM: Add a few machine types
to mach-types" with a manual update, and normally I'd say your patch
should go the same way.

We also still need to sort out the underlying problem that Russell
mentioned in the thread, which is that he doesn't want to add any 
entries that are not used, while I don't want to add any code that
doesn't build (which a machine definition doesn't without the
mach-types entry).

The best solution I can think of is if I ask people to manually
add a line for their machines when a new one gets added (this
should be getting rarer in the future) and I check that the
line is identical to the one that we get after Russell does the
next update. The main disadvantage with this approach is that
it generates a lot of trivial merge conflicts that the database
was originally meant to avoid.

I also noticed that there is a second missing entry for a board
that Paul Mundt added recently:

$ git grep ^MACHINE_START arch/arm/ | cut -f 2 -d \( | cut -f 1 -d, | \
    while read i ; do 	\
	if ! git grep -qw "$i" arch/arm/tools/mach-types ; then echo $i ; fi ;\
    done
M28EVK
KOTA2

The patch that Magnus did for the KOTA2  mach-types entry is currently
in the same state, waiting for an Ack from Russell.

	Arnd
