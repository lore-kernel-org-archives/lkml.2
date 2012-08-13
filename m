Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab2HMTtm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 15:49:42 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65464 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585Ab2HMTtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 15:49:41 -0400
Message-ID: <1344887375.7580.2.camel@maxim-laptop>
Subject: Re: [bisected] nouveau: "Failed to idle channel x" after resume
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Sven Joachim <svenjoac@gmx.de>
Cc: Ben Skeggs <skeggsb@gmail.com>, Aioanei Rares <krnl.list@gmail.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        Martin Nyhus <martin.nyhus@gmx.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Ben Skeggs <bskeggs@redhat.com>
Date: Mon, 13 Aug 2012 22:49:35 +0300
In-Reply-To: <87d32uzrq5.fsf@turtle.gmx.de>
References: <20120611231842.221bd738@europa>
	 <20120705222429.43586868@europa>
	 <CAJCn4U=pLjiLVW_TT+JN5G177dh4RUwg=vinjBrS4udChOyqoQ@mail.gmail.com>
	 <1344091275.4520.1.camel@maxim-laptop>
	 <1344285484.14543.0.camel@maxim-laptop>
	 <20120808053716.GA10092@turiel.bne.redhat.com>
	 <87lihpkjnu.fsf@turtle.gmx.de>
	 <20120808060841.GB10092@turiel.bne.redhat.com>
	 <87fw7xkiu6.fsf@turtle.gmx.de> <87d32uzrq5.fsf@turtle.gmx.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-13 at 18:22 +0200, Sven Joachim wrote: 
> On 2012-08-08 08:18 +0200, Sven Joachim wrote:
> 
> > On 2012-08-08 08:08 +0200, Ben Skeggs wrote:
> >
> >> On Wed, Aug 08, 2012 at 08:00:21AM +0200, Sven Joachim wrote:
> >>> Not for me on my GeForce 8500 GT, and I still cannot suspend more than
> >>> once, subsequent attempts fail:
> >>> 
> >>> ,----
> >>> | Aug 8 07:49:16 turtle kernel: [ 91.697068] nouveau W[
> >>> | PGRAPH][0000:01:00.0][0x0200502d][ffff880037be1d40] parent failed
> >>> | suspend, -16
> >>> | Aug  8 07:49:16 turtle kernel: [   91.697078] nouveau  [     DRM][0000:01:00.0] resuming display...
> >>> `----
> >> Interesting.  Were there any messages prior to that?
> >
> > Nothing interesting:
> >
> > ,----
> > | Aug  8 07:49:16 turtle kernel: [   89.655362] nouveau  [     DRM][0000:01:00.0] suspending fbcon...
> > | Aug  8 07:49:16 turtle kernel: [   89.655367] nouveau  [     DRM][0000:01:00.0] suspending display...
> > | Aug  8 07:49:16 turtle kernel: [   89.696888] nouveau  [     DRM][0000:01:00.0] unpinning framebuffer(s)...
> > | Aug  8 07:49:16 turtle kernel: [   89.696909] nouveau  [     DRM][0000:01:00.0] evicting buffers...
> > | Aug  8 07:49:16 turtle kernel: [   89.696913] nouveau  [     DRM][0000:01:00.0] suspending client object trees...
> > `----
> >
> >> I guess the the fifo
> >> code detected a timeout when trying to save the graphics context, I have
> >> I have other patches in my tree (I'll push them soon, tied up with other
> >> work atm) that might help here.
> >
> > Thanks, I'll try them when they are available.
> 
> With current nouveau master ("drm/nouveau: fix find/replace bug in
> license header") suspending works again, thanks!  However, it is a bit
> slow, taking between two and five seconds:
> 
> ,----
> | Aug 13 18:17:56 turtle kernel: [  678.524814] PM: Syncing filesystems ... done.
> | Aug 13 18:18:09 turtle kernel: [  678.639202] Freezing user space processes ... (elapsed 0.01 seconds) done.
> | Aug 13 18:18:09 turtle kernel: [  678.649954] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
> | Aug 13 18:18:09 turtle kernel: [  678.663298] Suspending console(s) (use no_console_suspend to debug)
> | Aug 13 18:18:09 turtle kernel: [  678.680884] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> | Aug 13 18:18:09 turtle kernel: [  678.681000] sd 0:0:0:0: [sda] Stopping disk
> | Aug 13 18:18:09 turtle kernel: [  678.695141] parport_pc 00:07: disabled
> | Aug 13 18:18:09 turtle kernel: [  678.695204] serial 00:06: disabled
> | Aug 13 18:18:09 turtle kernel: [  678.695209] serial 00:06: wake-up capability disabled by ACPI
> | Aug 13 18:18:09 turtle kernel: [  678.695235] nouveau  [     DRM][0000:01:00.0] suspending fbcon...
> | Aug 13 18:18:09 turtle kernel: [  678.695239] nouveau  [     DRM][0000:01:00.0] suspending display...
> | Aug 13 18:18:09 turtle kernel: [  678.742111] nouveau  [     DRM][0000:01:00.0] unpinning framebuffer(s)...
> | Aug 13 18:18:09 turtle kernel: [  678.742189] nouveau  [     DRM][0000:01:00.0] evicting buffers...
> | Aug 13 18:18:09 turtle kernel: [  682.357319] nouveau  [     DRM][0000:01:00.0] suspending client object trees...
> | Aug 13 18:18:09 turtle kernel: [  683.526646] PM: suspend of devices complete after 4863.181 msecs
> `----
> 
> With the 3.4.8 kernel, suspending takes little more than one second.
> 
> Cheers,
>        Sven
I confirm exactly the same thing.

Here suspend takes more that 10 seconds:

[ 2165.363878] nouveau  [     DRM][0000:01:00.0] suspending fbcon...
[ 2165.363885] nouveau  [     DRM][0000:01:00.0] suspending display...
[ 2165.475791] sd 0:0:0:0: [sda] Stopping disk
[ 2166.396877] nouveau  [     DRM][0000:01:00.0] unpinning
framebuffer(s)...
[ 2166.396926] nouveau  [     DRM][0000:01:00.0] evicting buffers...
[ 2174.809084] nouveau  [     DRM][0000:01:00.0] suspending client
object trees...
[ 2177.950222] nouveau 0000:01:00.0: power state changed by ACPI to D3


Best regards,
Maxim Levitsky

