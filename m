Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692Ab0GGNHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 09:07:50 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:56083 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753534Ab0GGNHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 09:07:47 -0400
From: Nicolas Palix <npalix@diku.dk>
To: Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH] coccicheck: use $KBUILD_EXTMOD when available
Date: Wed, 7 Jul 2010 14:22:56 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; i686; ; )
Cc: Kulikov Vasiliy <segooon@gmail.com>,
       Kernel Janitors <kernel-janitors@vger.kernel.org>,
       Julia Lawall <julia@diku.dk>, Gilles Muller <Gilles.Muller@lip6.fr>,
       Sam Ravnborg <sam@ravnborg.org>, Joerg Roedel <joerg.roedel@amd.com>,
       cocci@diku.dk, linux-kernel@vger.kernel.org
References: <1278170438-8136-1-git-send-email-segooon@gmail.com> <201007032149.30704.npalix@diku.dk> <4C345F44.4070800@suse.cz>
In-Reply-To: <4C345F44.4070800@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201007071422.56919.npalix@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday 07 July 2010 13:04:36 Michal Marek wrote:
> On 3.7.2010 21:49, Nicolas Palix wrote:
> > Hi,
> > 
> > On Saturday 03 July 2010 17:20:34 Kulikov Vasiliy wrote:
> >> Use $KBUILD_EXTMOD instead of $srctree when the latter is not null
> >> to use make M=somedir.
> >>
> >> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> >> ---
> >>  scripts/coccicheck |    8 +++++++-
> >>  1 files changed, 7 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/scripts/coccicheck b/scripts/coccicheck
> >> index b8bcf1f..7d66a55 100755
> >> --- a/scripts/coccicheck
> >> +++ b/scripts/coccicheck
> >> @@ -1,5 +1,11 @@
> >>  #!/bin/sh
> >>  
> >> +if [ -n "$KBUILD_EXTMOD" ]; then
> >> +	CHECK_DIR="$KBUILD_EXTMOD"
> >> +else
> >> +	CHECK_DIR="$srctree"
> >> +fi
> >> +
> >>  SPATCH="`which ${SPATCH:=spatch}`"
> >>  
> >>  if [ "$C" = "1" -o "$C" = "2" ]; then
> >> @@ -64,7 +70,7 @@ coccinelle () {
> >>  	echo ' http://coccinelle.lip6.fr/'
> >>  	echo ''
> >>  
> >> -	$SPATCH -D $MODE $FLAGS -sp_file $COCCI $OPT -dir $srctree || exit 1
> >> +	$SPATCH -D $MODE $FLAGS -sp_file $COCCI $OPT -dir $CHECK_DIR || exit 1
> >>      else
> >>  	$SPATCH -D $MODE $FLAGS -sp_file $COCCI $OPT $OPTIONS || exit 1
> >>      fi
> >>
> > 
> > In doing so, the output of the patch mode will produce patches relative to $KBUILD_EXTMOD.
> > I am not sure of what most of developers want but if the patches must be relative to
> > the Linux kernel root, the following patch must be used.
> 
> If you are checking your out-of-tree module, then you're probably not
> going to send the resulting patch to lkml.
> 

Indeed. I thus acked the original patch last Monday [1].

Thanks.

[1] http://lkml.org/lkml/2010/7/5/136

> Michal
> 

-- 
Nicolas Palix
Tel: (+33) 1 44 27 87 25
Tel: (+33) 6 81 07 91 72
Web: http://www.diku.dk/~npalix/
