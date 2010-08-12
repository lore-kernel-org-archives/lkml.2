Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759774Ab0HLKgf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 06:36:35 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41189 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759677Ab0HLKgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 06:36:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=wY8/wHJFxNYlbCFCutbmIA0LrLwVxy7kQqEnq3NFQOYhZVo/jiX0zCIFidGM9mcTwM
         rkaFy0rewKt7z8Ih06NSMb5cZa3kFePjiesTOupb8JeW8MoESjpx4MFi3FKrQZNVr3c1
         LZ3Gdz50E4Hu8cw1E3KoFQTyeDyxFJnf9Stew=
MIME-Version: 1.0
In-Reply-To: <20100812034435.GA7403@linux.vnet.ibm.com>
References: <20100808155719.GB3635@thunk.org>
	<AANLkTinM5e2HGOFavODPZNzZx4KshDSjsvKN4pLpGGgr@mail.gmail.com>
	<20100808213821.GD3635@thunk.org>
	<20100809112453.77210acc@lxorguk.ukuu.org.uk>
	<20100809181638.GI3026@linux.vnet.ibm.com>
	<AANLkTikwHaKpLdRdxmZj6JDJnsZ+o-jzbVcXhRW3Jmd9@mail.gmail.com>
	<20100811222854.GJ2516@linux.vnet.ibm.com>
	<AANLkTimahmGikeai8QnAxCy45deT00-6T7h-eA-NqL4G@mail.gmail.com>
	<20100812010612.GL2516@linux.vnet.ibm.com>
	<AANLkTinVV1NVHFPeO0p_e2pCtNwTNB932q9tbu9MMD3_@mail.gmail.com>
	<20100812034435.GA7403@linux.vnet.ibm.com>
Date: Thu, 12 Aug 2010 13:36:28 +0300
Message-ID: <AANLkTi=RD=eM_gpc7FfRq0923sUbARmZ2+4-m+fLibYC@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
From: Felipe Contreras <felipe.contreras@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "Ted Ts'o" <tytso@mit.edu>,
        david@lang.hm, Brian Swetland <swetland@google.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, menage@google.com,
        david-b@pacbell.net, James.Bottomley@suse.de, arjan@infradead.org,
        swmike@swm.pp.se, galibert@pobox.com, dipankar@in.ibm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 6:44 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Thu, Aug 12, 2010 at 04:25:21AM +0300, Felipe Contreras wrote:
>> Think in terms of an ARM laptop. What good is opportunistic suspend if
>> it's not going to help when the laptop is being used?
>
> For when the laptop is not being used, presumably.

Right, but if you have to optimize for dynamic PM anyway for normal
usage, how much would you gain by opportunistic suspend?

As it has been explained before, there's a point of diminishing returns:
http://article.gmane.org/gmane.linux.kernel/995525
http://article.gmane.org/gmane.linux.ports.arm.omap/37982

Now, how much would dynamic PM have progressed by the time we start
thinking on opportunistic suspend on laptops (ARM, or fixed PM), 10
seconds idle? 1 minute idle? Would it make sense to rewrite *all*
user-space in order to archive that little extra performance, *or*
would it make more sense to keep investing on dynamic PM which we have
to do anyway?

All this has already been explained.

BTW, the gain is even less if you consider that laptops already
automatically go to suspend after a while, so the gains of
opportunistic suspend would have to be measured only for a small
period of time (like 30 min or so).

-- 
Felipe Contreras
