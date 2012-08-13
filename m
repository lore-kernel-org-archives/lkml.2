Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab2HMQXI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 12:23:08 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:37289 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752386Ab2HMQXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 12:23:04 -0400
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX1+zc4MGyPKzgzKBcMyL2zfx9JtTxYb0uhOn8kXaUn
	Sal9ewxSm5PlDY
From: Sven Joachim <svenjoac@gmx.de>
To: Ben Skeggs <skeggsb@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
        Aioanei Rares <krnl.list@gmail.com>,
        "nouveau\@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        Martin Nyhus <martin.nyhus@gmx.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Ben Skeggs <bskeggs@redhat.com>
Subject: Re: [bisected] nouveau: "Failed to idle channel x" after resume
References: <20120611231842.221bd738@europa> <20120705222429.43586868@europa>
	<CAJCn4U=pLjiLVW_TT+JN5G177dh4RUwg=vinjBrS4udChOyqoQ@mail.gmail.com>
	<1344091275.4520.1.camel@maxim-laptop>
	<1344285484.14543.0.camel@maxim-laptop>
	<20120808053716.GA10092@turiel.bne.redhat.com>
	<87lihpkjnu.fsf@turtle.gmx.de>
	<20120808060841.GB10092@turiel.bne.redhat.com>
	<87fw7xkiu6.fsf@turtle.gmx.de>
Date: Mon, 13 Aug 2012 18:22:58 +0200
In-Reply-To: <87fw7xkiu6.fsf@turtle.gmx.de> (Sven Joachim's message of "Wed,
	08 Aug 2012 08:18:09 +0200")
Message-ID: <87d32uzrq5.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-08-08 08:18 +0200, Sven Joachim wrote:

> On 2012-08-08 08:08 +0200, Ben Skeggs wrote:
>
>> On Wed, Aug 08, 2012 at 08:00:21AM +0200, Sven Joachim wrote:
>>> Not for me on my GeForce 8500 GT, and I still cannot suspend more than
>>> once, subsequent attempts fail:
>>> 
>>> ,----
>>> | Aug 8 07:49:16 turtle kernel: [ 91.697068] nouveau W[
>>> | PGRAPH][0000:01:00.0][0x0200502d][ffff880037be1d40] parent failed
>>> | suspend, -16
>>> | Aug  8 07:49:16 turtle kernel: [   91.697078] nouveau  [     DRM][0000:01:00.0] resuming display...
>>> `----
>> Interesting.  Were there any messages prior to that?
>
> Nothing interesting:
>
> ,----
> | Aug  8 07:49:16 turtle kernel: [   89.655362] nouveau  [     DRM][0000:01:00.0] suspending fbcon...
> | Aug  8 07:49:16 turtle kernel: [   89.655367] nouveau  [     DRM][0000:01:00.0] suspending display...
> | Aug  8 07:49:16 turtle kernel: [   89.696888] nouveau  [     DRM][0000:01:00.0] unpinning framebuffer(s)...
> | Aug  8 07:49:16 turtle kernel: [   89.696909] nouveau  [     DRM][0000:01:00.0] evicting buffers...
> | Aug  8 07:49:16 turtle kernel: [   89.696913] nouveau  [     DRM][0000:01:00.0] suspending client object trees...
> `----
>
>> I guess the the fifo
>> code detected a timeout when trying to save the graphics context, I have
>> I have other patches in my tree (I'll push them soon, tied up with other
>> work atm) that might help here.
>
> Thanks, I'll try them when they are available.

With current nouveau master ("drm/nouveau: fix find/replace bug in
license header") suspending works again, thanks!  However, it is a bit
slow, taking between two and five seconds:

,----
| Aug 13 18:17:56 turtle kernel: [  678.524814] PM: Syncing filesystems ... done.
| Aug 13 18:18:09 turtle kernel: [  678.639202] Freezing user space processes ... (elapsed 0.01 seconds) done.
| Aug 13 18:18:09 turtle kernel: [  678.649954] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
| Aug 13 18:18:09 turtle kernel: [  678.663298] Suspending console(s) (use no_console_suspend to debug)
| Aug 13 18:18:09 turtle kernel: [  678.680884] sd 0:0:0:0: [sda] Synchronizing SCSI cache
| Aug 13 18:18:09 turtle kernel: [  678.681000] sd 0:0:0:0: [sda] Stopping disk
| Aug 13 18:18:09 turtle kernel: [  678.695141] parport_pc 00:07: disabled
| Aug 13 18:18:09 turtle kernel: [  678.695204] serial 00:06: disabled
| Aug 13 18:18:09 turtle kernel: [  678.695209] serial 00:06: wake-up capability disabled by ACPI
| Aug 13 18:18:09 turtle kernel: [  678.695235] nouveau  [     DRM][0000:01:00.0] suspending fbcon...
| Aug 13 18:18:09 turtle kernel: [  678.695239] nouveau  [     DRM][0000:01:00.0] suspending display...
| Aug 13 18:18:09 turtle kernel: [  678.742111] nouveau  [     DRM][0000:01:00.0] unpinning framebuffer(s)...
| Aug 13 18:18:09 turtle kernel: [  678.742189] nouveau  [     DRM][0000:01:00.0] evicting buffers...
| Aug 13 18:18:09 turtle kernel: [  682.357319] nouveau  [     DRM][0000:01:00.0] suspending client object trees...
| Aug 13 18:18:09 turtle kernel: [  683.526646] PM: suspend of devices complete after 4863.181 msecs
`----

With the 3.4.8 kernel, suspending takes little more than one second.

Cheers,
       Sven
