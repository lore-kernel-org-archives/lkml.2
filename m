Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab1JSUE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 16:04:57 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:37211 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753194Ab1JSUE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 16:04:56 -0400
Subject: Re: Please include const-sections into linux-next
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
In-Reply-To: <20111019190517.GK15908@one.firstfloor.org>
References: <20111013233818.GB26654@one.firstfloor.org>
	 <1318631204.3018.101.camel@dabdike.int.hansenpartnership.com>
	 <20111016033514.GC26654@one.firstfloor.org>
	 <1318799006.2995.1.camel@dabdike.int.hansenpartnership.com>
	 <0e9ef9174a0089187fde0b3d084672ad.squirrel@www.firstfloor.org>
	 <1319039663.3034.18.camel@dabdike.int.hansenpartnership.com>
	 <20111019161537.GH15908@one.firstfloor.org>
	 <1319041281.3034.25.camel@dabdike.int.hansenpartnership.com>
	 <20111019163351.GJ15908@one.firstfloor.org>
	 <1319050557.3034.46.camel@dabdike.int.hansenpartnership.com>
	 <20111019190517.GK15908@one.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 Oct 2011 15:04:53 -0500
Message-ID: <1319054693.3034.49.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-10-19 at 21:05 +0200, Andi Kleen wrote:
> On Wed, Oct 19, 2011 at 01:55:57PM -0500, James Bottomley wrote:
> > On Wed, 2011-10-19 at 18:33 +0200, Andi Kleen wrote:
> > > > OK, look at it another way: why do we need the type annotations?  I
> > > > think it's only for section conflict checking, right?  If the compiler
> > > > gets it wrong anyway, why not just dump all the type annotations, then
> > > > it should have no type conflicts (spurious or otherwise) to complain
> > > > about.  We already have link time section checking scripts (they're the
> > > > useless ones that complain about section mismatches in dev annoations)
> > > > so why not put them to work to make up for compiler deficiencies?
> > > 
> > > You mean removing all the init sections stuff?  I think it has been proposed
> > > in the past, but it's a couple of hundred KB of memory usually.
> > > Would you accept that for PA-RISC? 
> > > 
> > > If you have init sections you need to annotate them correctly because
> > > a section is defined by its rwx attributes plus name and both need
> > > to match. We didn't always check this, so there was some bitrot,
> > > but it ultimatively has to be correct.
> > 
> > We're talking at cross purposes. But it doesn't matter, the error
> > doesn't seem to be anything to do with type.  This simple patch is
> > what's causing it (I can apply it alone to the working tree) and get the
> > error.
> > 
> > What I can't see is why.
> 
> For some reason your compiler sets the const section read/write:
> 
> .section        .devinit.data,"aw",@progbits     <---- writable
>         .align 8
>         .type   skel_netdrv_tbl, @object
>         .size   skel_netdrv_tbl, 48
> skel_netdrv_tbl:
> ; chip_name:
>         .dword  .LC56
> 
> while my x86 toolchain sets it to read only
> 
>         .string "1000/100/10M Ethernet PCI Adapter"
>         .section        .devinit.data,"a",@progbits   <---- not writable
>         .align 16
>         .type   skel_netdrv_tbl, @object
>         .size   skel_netdrv_tbl, 48

So most of our const stuff is "a" not "aw".  However, this particular
list is a list of strings ... this is probably something to do with
writeable strings?

James


