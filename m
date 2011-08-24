Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094Ab1HXNxv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 09:53:51 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:49078 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750972Ab1HXNxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 09:53:48 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: gVZ4wMEVM1mWc.dHQLacLnG5c.ySJJXf1f1d3Sy3oQBnedf
 WctcEYP7CsqmN0NUhC0pyg013_fImcFl8DbwgYvLRB.5ykCnImtZSPfQ_u6l
 wh6SRKC_TcV9Q7LAOBO0XnHZXMnwIXRuCpAZeO.GauUPEZcpR._IufH3zHSd
 OGv2drxsq_V7CGHDb8rlvXyxL.3Z1d517c1ODMCiAGVb.UjSBg9qZcZjeksF
 2mGWSuDvXoDzxO3JfM21.A0yONS3ooMq04_aKLztumSBqycuYxxQ0ImQJevh
 csWWb5xRrkM0foDK1sy2VofB8kcHXOV_lS_jWuvcOSdg8Z6GBkMbiblwjnwk
 IMuykWg0hOYAVC94xAP7alnIUnWNzOXhRkkqZ8vc4JEdI8NXFOwdXlfHTMmo
 VBXZg2r8zATi1VIFL6KYV4Q--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 24 Aug 2011 08:53:44 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 13/15] x86: add cmpxchg_flag() variant
In-Reply-To: <4E542681.2090703@goop.org>
Message-ID: <alpine.DEB.2.00.1108240852370.24118@router.home>
References: <cover.1314045780.git.jeremy.fitzhardinge@citrix.com> <738d736ecffa3bd32df76ae41188aa39c2ace941.1314054734.git.jeremy.fitzhardinge@citrix.com> <alpine.DEB.2.00.1108231355380.26421@router.home> <4E540548.4080402@goop.org> <4E541154.6090805@zytor.com>
 <4E542681.2090703@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Aug 2011, Jeremy Fitzhardinge wrote:

> However, having prototyped it, I dunno, it doesn't really seem like much
> of a win for all the extra code it adds.  I just can't get too excited
> about an extra test instruction adjacent to a monster like a locked
> cmpxchg.  The jump variant avoids the test, but gcc still generates some
> pretty bogus stuff:

There are also unlocked cmpxchges in use. And if the cmpxchg is a 16 byte
cmpxchg (cmpxchg_double) then the comparison is getting more expensive.
