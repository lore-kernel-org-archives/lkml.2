Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab1GVLJ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 07:09:28 -0400
Received: from mail.mnsspb.ru ([84.204.75.2]:43673 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753955Ab1GVLJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 07:09:26 -0400
Date: Fri, 22 Jul 2011 15:08:06 +0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Pekka Enberg <penberg@kernel.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Luke-Jr <luke@dashjr.org>,
        intel-gfx@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Ray Lee <ray-lk@madrabbit.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Florian Mickler <florian@mickler.org>,
        Keith Packard <keithp@keithp.com>
Subject: Re: Major 2.6.38 / 2.6.39 / 3.0 regression ignored?
Message-ID: <20110722110806.GA29757@tugrik.mns.mnsspb.ru>
References: <201105201306.31204.luke@dashjr.org> <BANLkTimOqhNEsBEg6f=nMiMJqYGNyFJmeQ@mail.gmail.com> <013811$4lfs6@fmsmga002.fm.intel.com> <201105211123.56053.luke@dashjr.org> <aefc95$1usaq@orsmga001.jf.intel.com> <20110528131920.GA10467@tugrik.mns.mnsspb.ru> <20110712171706.GA18414@tugrik.mns.mnsspb.ru> <CAOJsxLEz-fPnb9oYnLMk9UbGqgsfm-g1d2yH=TrEiEk7HvyQzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOJsxLEz-fPnb9oYnLMk9UbGqgsfm-g1d2yH=TrEiEk7HvyQzA@mail.gmail.com> <CA+55aFxakA2U+oMJ1T7awTYa+p6xp9N0aCbfrUqgkF7BJ8gnQw@mail.gmail.com>
Organization: Marine Bridge & Navigation Systems
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 [ Cc'ing Florian Mickler and Keith Packard ]

On Tue, Jul 12, 2011 at 09:07:47PM +0300, Pekka Enberg wrote:
> On Tue, Jul 12, 2011 at 8:17 PM, Kirill Smelkov <kirr@mns.spb.ru> wrote:
> > On Sat, May 28, 2011 at 05:19:20PM +0400, Kirill Smelkov wrote:
> >> Hello Chris, everyone,
> >>
> >> On Sat, May 21, 2011 at 04:40:17PM +0100, Chris Wilson wrote:
> >> > On Sat, 21 May 2011 11:23:53 -0400, "Luke-Jr" <luke@dashjr.org> wrote:
> >> > > On Saturday, May 21, 2011 4:41:45 AM Chris Wilson wrote:
> >> > > > On Fri, 20 May 2011 11:08:56 -0700, Ray Lee <ray-lk@madrabbit.org> wrote:
> >> > > > > [ Adding Chris Wilson (author of the problematic patch) and Rafael
> >> > > > > Wysocki to the message ]
> >> > > > >
> >> > > > > On Fri, May 20, 2011 at 10:06 AM, Luke-Jr <luke@dashjr.org> wrote:
> >> > > > > > I submitted https://bugzilla.kernel.org/show_bug.cgi?id=33662 a month
> >> > > > > > ago against 2.6.38. Now 2.6.39 was just released without the
> >> > > > > > regression being addressed. This bug makes the system unusable... Some
> >> > > > > > guys on IRC suggested I
> >> > > > > > email, so here it is.
> >> > > > >
> >> > > > > See the bugzilla entry for the bisection history.
> >> > > >
> >> > > > Which has nothing to do with Luke's bug. Considering the thousand things
> >> > > > that can go wrong during X starting, without a hint as to which it is nigh
> >> > > > on impossible to debug except by trial and error. If you set up
> >> > > > netconsole, does the kernel emit an OOPS with it's last dying breath?
> >> > >
> >> > > Why assume it's a different bug? I would almost wonder if it might affect
> >> > > all Sandy Bridge GPUs. In any case, I no longer have the original
> >> > > motherboard (it was recalled, as I said in the first post), nor even the
> >> > > revision of it (it had other issues that weren't being fixed). I *assume* I
> >> > > will have the same problem with my new motherboard (Intel DQ67SW), but I
> >> > > haven't verified that yet. I'll be sure to try a netconsole when I have to
> >> > > reboot next and get a chance to try the most recent 2.6.38 and .39 kernels,
> >> > > but at the moment it seems reasonable to address the problem bisected in the
> >> > > bug, even if it turns out to be different.
> >> >
> >> > The bisection is into an old DRI1 bug on 945GM. That DRI has inadequate
> >> > locking between release and IRQ and so is prone to such races as befell
> >> > Kirill should not surprise anyone. As neither UMS nor DRI supported SNB,
> >> > I can quite confidently state they are separate bugs.
> >> > -Chris
> >>
> >> I see DRI1 is maybe buggy and old, but still, pre-kms X used to work ok
> >> on kernels < 2.6.38, and starting from 2.6.38 the system is just
> >> unusable because X either crashes the kernel (2.6.38), or does not start
> >> at all (2.6.39):
> >>
> >> https://bugzilla.kernel.org/show_bug.cgi?id=36052
> >>
> >>
> >> It's a regression. It's blocking me to upgrade to newer kernels. I've
> >> done my homework -- digged it and came with detailed OOPS on netconsole
> >> and bisected to single commit. Could this please be fixed?
> >
> > Silence...
> >
> > Still, reverting the bisected patch helps even for 3.0:
> >
> > https://bugzilla.kernel.org/show_bug.cgi?id=36052#c4
> 
> Keith, Chris, what's up with this regression from 2.6.38? It seems
> commit e8616b6 ("drm/i915: Initialise ring vfuncs for old DRI paths")
> caused problems on other machines.

Silence again, and not surprising -- I was ringing this bell for 3
months already:

https://bugzilla.kernel.org/show_bug.cgi?id=33662#c10
https://bugzilla.kernel.org/show_bug.cgi?id=36052
(and on the list)

with detailed logs and bisected single patch, without even single reply
from intel-gfx people.


And now after v3.0 is out, I've tested it again, and yes, like it was
broken on v3.0-rc5, it is (now even more) broken on v3.0 -- after first
bad io access the system freezes completely:

    On netconsole:

    # X starts here, then

    [   45.102377] ------------[ cut here ]------------
    [   45.102402] WARNING: at lib/iomap.c:43 bad_io_access+0x3d/0x40()
    [   45.102411] Hardware name: PCISA-945GSE
    [   45.102418] Bad IO access at port 0x84 (return inl(port))
    [   45.102425] Modules linked in: 
    [   45.102438] Pid: 2846, comm: sshd Not tainted 3.0.0--NAVY #33
    [   45.102445] Call Trace:
    [   45.102460]  [<c118e9fd>] ? bad_io_access+0x3d/0x40
    [   45.102473]  [<c10287ec>] warn_slowpath_common+0x6c/0xa0
    [   45.102484]  [<c118e9fd>] ? bad_io_access+0x3d/0x40
    [   45.102495]  [<c102889e>] warn_slowpath_fmt+0x2e/0x30
    [   45.102506]  [<c118e9fd>] bad_io_access+0x3d/0x40
    [   45.102516]  [<c118edb2>] ioread32+0x22/0x40
    [   45.102528]  [<c122cc7d>] i915_driver_irq_handler+0x1ad/0x660
    [   45.102541]  [<c12c6a7e>] ? rtl8169_interrupt+0xee/0x370
    [   45.102554]  [<c105c396>] handle_irq_event_percpu+0x36/0x140
    [   45.102565]  [<c105e490>] ? handle_edge_irq+0x150/0x150
    [   45.102576]  [<c105c4d9>] handle_irq_event+0x39/0x60
    [   45.102587]  [<c105e4d5>] handle_fasteoi_irq+0x45/0xd0
    [   45.102594]  <IRQ>   [<c1003c29>] ? do_IRQ+0x39/0xb0
    [   45.102613]  [<c103c9b3>] ? start_flush_work+0xc3/0x130
    [   45.102625]  [<c13bc329>] ? common_interrupt+0x29/0x30
    [   45.102636]  [<c13bc329>] ? common_interrupt+0x29/0x30
    [   45.102648]  [<c11e007b>] ? pnpacpi_encode_resources+0x37b/0x7a0
    [   45.102659]  [<c109971e>] ? fget_light+0xe/0xf0
    [   45.102671]  [<c10a8f97>] ? do_select+0x2e7/0x680
    [   45.102685]  [<c1341998>] ? sch_direct_xmit+0x58/0x1d0
    [   45.102695]  [<c10a83e0>] ? poll_freewait+0xa0/0xa0
    [   45.102706]  [<c102df37>] ? local_bh_enable+0x47/0xa0
    [   45.102718]  [<c132e371>] ? dev_queue_xmit+0x101/0x4e0
    [   45.102729]  [<c134ffba>] ? ip_finish_output+0x10a/0x2f0
    [   45.102740]  [<c1350216>] ? ip_output+0x76/0x90
    [   45.102750]  [<c134d715>] ? ip_local_out+0x65/0x70
    [   45.102762]  [<c134fa3d>] ? ip_queue_xmit+0x1bd/0x3b0
    [   45.102775]  [<c1362af8>] ? tcp_transmit_skb+0x468/0x7d0
    [   45.102788]  [<c13215af>] ? sk_reset_timer+0xf/0x20
    [   45.102798]  [<c1362446>] ? tcp_event_new_data_sent+0x86/0xc0
    [   45.102809]  [<c1364fc1>] ? tcp_write_xmit+0x1e1/0x9a0
    [   45.102822]  [<c1326925>] ? __alloc_skb+0x55/0x100
    [   45.102838]  [<c102df37>] ? local_bh_enable+0x47/0xa0
    [   45.102849]  [<c1321246>] ? release_sock+0xd6/0x110
    [   45.102859]  [<c13657f7>] ? __tcp_push_pending_frames+0x27/0x80
    [   45.102870]  [<c13584fa>] ? tcp_sendmsg+0x64a/0xac0

    -*- and then system FREEZE -*-


For completeness `X -verbose` log is in "Appendix 1", (but who cares
anyway? I've sent lots of such logs without a reply).


And again, after reverting e8616b6 ("drm/i915: Initialise ring vfuncs
for old DRI paths") on top of v3.0, X works without any problem again.


So I wonder:

    I thought people are trying to do "no regressions" rule in kernel.
    Should we then just apply the following patch? In case Intel people
    are not responding, should it just go directly into mainline?

    Or would it be more fair to say that UMS is not supported anymore,
    is broken and just remove support for it?


Thanks,
Kirill


P.S. Sometimes people change their hardware preferences based on
software support quality. Knock, knock...


>From ef91a178e6069ae07c7a3c1e39e13eea609953cd Mon Sep 17 00:00:00 2001
From: Kirill Smelkov <kirr@mns.spb.ru>
Date: Wed, 29 Jun 2011 14:22:49 +0400
Subject: [PATCH] Revert "drm/i915: Initialise ring vfuncs for old DRI paths"

This reverts commit e8616b6ced6137085e6657cc63bc2fe3900b8616.

See https://bugzilla.kernel.org/show_bug.cgi?id=36052

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Florian Mickler <florian@mickler.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Keith Packard <keithp@keithp.com>
Cc: stable@kernel.org

---
 drivers/gpu/drm/i915/i915_dma.c         |   25 +++++++++++++-----
 drivers/gpu/drm/i915/intel_ringbuffer.c |   42 -------------------------------
 drivers/gpu/drm/i915/intel_ringbuffer.h |    3 --
 3 files changed, 18 insertions(+), 52 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 296fbd6..9300d18 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -160,7 +160,7 @@ static int i915_initialize(struct drm_device * dev, drm_i915_init_t * init)
 {
 	drm_i915_private_t *dev_priv = dev->dev_private;
 	struct drm_i915_master_private *master_priv = dev->primary->master->driver_priv;
-	int ret;
+	struct intel_ring_buffer *ring = LP_RING(dev_priv);
 
 	master_priv->sarea = drm_getsarea(dev);
 	if (master_priv->sarea) {
@@ -171,22 +171,33 @@ static int i915_initialize(struct drm_device * dev, drm_i915_init_t * init)
 	}
 
 	if (init->ring_size != 0) {
-		if (LP_RING(dev_priv)->obj != NULL) {
+		if (ring->obj != NULL) {
 			i915_dma_cleanup(dev);
 			DRM_ERROR("Client tried to initialize ringbuffer in "
 				  "GEM mode\n");
 			return -EINVAL;
 		}
 
-		ret = intel_render_ring_init_dri(dev,
-						 init->ring_start,
-						 init->ring_size);
-		if (ret) {
+		ring->size = init->ring_size;
+
+		ring->map.offset = init->ring_start;
+		ring->map.size = init->ring_size;
+		ring->map.type = 0;
+		ring->map.flags = 0;
+		ring->map.mtrr = 0;
+
+		drm_core_ioremap_wc(&ring->map, dev);
+
+		if (ring->map.handle == NULL) {
 			i915_dma_cleanup(dev);
-			return ret;
+			DRM_ERROR("can not ioremap virtual address for"
+				  " ring buffer\n");
+			return -ENOMEM;
 		}
 	}
 
+	ring->virtual_start = ring->map.handle;
+
 	dev_priv->cpp = init->cpp;
 	dev_priv->back_offset = init->back_offset;
 	dev_priv->front_offset = init->front_offset;
diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
index 95c4b14..8d2f610 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -1304,48 +1304,6 @@ int intel_init_render_ring_buffer(struct drm_device *dev)
 	return intel_init_ring_buffer(dev, ring);
 }
 
-int intel_render_ring_init_dri(struct drm_device *dev, u64 start, u32 size)
-{
-	drm_i915_private_t *dev_priv = dev->dev_private;
-	struct intel_ring_buffer *ring = &dev_priv->ring[RCS];
-
-	*ring = render_ring;
-	if (INTEL_INFO(dev)->gen >= 6) {
-		ring->add_request = gen6_add_request;
-		ring->irq_get = gen6_render_ring_get_irq;
-		ring->irq_put = gen6_render_ring_put_irq;
-	} else if (IS_GEN5(dev)) {
-		ring->add_request = pc_render_add_request;
-		ring->get_seqno = pc_render_get_seqno;
-	}
-
-	ring->dev = dev;
-	INIT_LIST_HEAD(&ring->active_list);
-	INIT_LIST_HEAD(&ring->request_list);
-	INIT_LIST_HEAD(&ring->gpu_write_list);
-
-	ring->size = size;
-	ring->effective_size = ring->size;
-	if (IS_I830(ring->dev))
-		ring->effective_size -= 128;
-
-	ring->map.offset = start;
-	ring->map.size = size;
-	ring->map.type = 0;
-	ring->map.flags = 0;
-	ring->map.mtrr = 0;
-
-	drm_core_ioremap_wc(&ring->map, dev);
-	if (ring->map.handle == NULL) {
-		DRM_ERROR("can not ioremap virtual address for"
-			  " ring buffer\n");
-		return -ENOMEM;
-	}
-
-	ring->virtual_start = (void __force __iomem *)ring->map.handle;
-	return 0;
-}
-
 int intel_init_bsd_ring_buffer(struct drm_device *dev)
 {
 	drm_i915_private_t *dev_priv = dev->dev_private;
diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.h b/drivers/gpu/drm/i915/intel_ringbuffer.h
index 39ac2b6..b6b0fd4 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.h
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.h
@@ -197,7 +197,4 @@ static inline void i915_trace_irq_get(struct intel_ring_buffer *ring, u32 seqno)
 		ring->trace_irq_seqno = seqno;
 }
 
-/* DRI warts */
-int intel_render_ring_init_dri(struct drm_device *dev, u64 start, u32 size);
-
 #endif /* _INTEL_RINGBUFFER_H_ */
-- 
1.7.6.233.gd79bc






Appendix 1. `X -verbose` log
----------------------------

# same, starting X over ssh
navy3:~# X -verbose
_XSERVTransSocketOpenCOTSServer: Unable to open socket for inet6
_XSERVTransOpen: transport open failed for inet6/navy3:0
_XSERVTransMakeAllCOTSServerListeners: failed to open listener for inet6

X.Org X Server 1.4.2
Release Date: 11 June 2008
X Protocol Version 11, Revision 0
Build Operating System: Linux Debian (xorg-server 2:1.4.2-10.lenny3)
Current Operating System: Linux navy3 3.0.0--NAVY #33 PREEMPT Fri Jul 22 13:56:40 MSD 2011 i68
6
Build Date: 25 September 2010  12:05:44PM
 
        Before reporting problems, check http://wiki.x.org
        to make sure that you have the latest version.
Module Loader present
Markers: (--) probed, (**) from config file, (==) default setting,
        (++) from command line, (!!) notice, (II) informational,
        (WW) warning, (EE) error, (NI) not implemented, (??) unknown.
(==) Log file: "/var/log/Xorg.0.log", Time: Sat Jan 19 21:24:12 2002
(==) Using config file: "/etc/X11/xorg.conf"
(==) ServerLayout "Default Layout"
(**) |-->Screen "Default Screen" (0)
(**) |   |-->Monitor "LCD 1600x1200"
(==) No device specified for screen "Default Screen".
        Using the first device section listed.
(**) |   |-->Device "Default card"
(**) |-->Input Device "Generic Keyboard"
(**) |-->Input Device "Configured Mouse"
(==) Automatically adding devices
(==) Automatically enabling devices
(==) No FontPath specified.  Using compiled-in default.
(WW) The directory "/usr/share/fonts/X11/100dpi/" does not exist.
        Entry deleted from font path.
(WW) The directory "/usr/share/fonts/X11/75dpi/" does not exist.
        Entry deleted from font path.
(WW) The directory "/usr/share/fonts/X11/Type1" does not exist.
        Entry deleted from font path.
(WW) The directory "/usr/share/fonts/X11/100dpi" does not exist.
        Entry deleted from font path.
(WW) The directory "/usr/share/fonts/X11/75dpi" does not exist.
        Entry deleted from font path.
(WW) The directory "/var/lib/defoma/x-ttcidfont-conf.d/dirs/TrueType" does not exist.
        Entry deleted from font path.
(==) FontPath set to:
        /usr/share/fonts/X11/misc,
        /usr/share/fonts/X11/cyrillic
(==) RgbPath set to "/etc/X11/rgb"
(==) ModulePath set to "/usr/lib/xorg/modules"
(II) Loading /usr/lib/xorg/modules//libpcidata.so
(II) Module pcidata: vendor="X.Org Foundation"
        compiled for 1.4.2, module version = 1.0.0
(--) using VT number 7

(--) PCI:*(0:2:0) Intel Corporation Mobile 945GME Express Integrated Graphics Controller rev 3
, Mem @ 0xfe980000/19, 0xd0000000/28, 0xfe940000/18, I/O @ 0xbc80/3
(--) PCI: (0:2:1) Intel Corporation Mobile 945GM/GMS/GME, 943/940GML Express Integrated Graphi
cs Controller rev 3, Mem @ 0xfe880000/19
(II) "extmod" will be loaded. This was enabled by default and also specified in the config fil
e.
(II) "dbe" will be loaded. This was enabled by default and also specified in the config file.
(II) "glx" will be loaded by default.
(II) "freetype" will be loaded. This was enabled by default and also specified in the config f
ile.
(II) "record" will be loaded. This was enabled by default and also specified in the config fil
e.
(II) "dri" will be loaded by default.
(II) Loading /usr/lib/xorg/modules/extensions//libdbe.so
(II) Module dbe: vendor="X.Org Foundation"
        compiled for 1.4.2, module version = 1.0.0
(II) Module "ddc" already built-in
(II) Loading /usr/lib/xorg/modules/extensions//libextmod.so
(II) Module extmod: vendor="X.Org Foundation"
        compiled for 1.4.2, module version = 1.0.0
(II) Loading /usr/lib/xorg/modules//fonts/libfreetype.so
(II) Module freetype: vendor="X.Org Foundation & the After X-TT Project"
        compiled for 1.4.2, module version = 2.1.0
(II) Loading /usr/lib/xorg/modules//libint10.so
(II) Module int10: vendor="X.Org Foundation"
        compiled for 1.4.2, module version = 1.0.0
(II) Loading /usr/lib/xorg/modules/extensions//librecord.so
(II) Module record: vendor="X.Org Foundation"
        compiled for 1.4.2, module version = 1.13.0
(II) Loading /usr/lib/xorg/modules//libvbe.so
(II) Module vbe: vendor="X.Org Foundation"
        compiled for 1.4.2, module version = 1.1.0
(II) Loading /usr/lib/xorg/modules/drivers//v4l_drv.so
(II) Module v4l: vendor="X.Org Foundation"
        compiled for 1.4.0.90, module version = 0.1.1
(II) Loading /usr/lib/xorg/modules/extensions//libglx.so
(II) Module glx: vendor="X.Org Foundation"
        compiled for 1.4.2, module version = 1.0.0
(==) AIGLX enabled
(II) Loading /usr/lib/xorg/modules/extensions//libdri.so
(II) Module dri: vendor="X.Org Foundation"
        compiled for 1.4.2, module version = 1.0.0
(II) Matched intel from file name intel.ids in autoconfig
(==) Matched intel for the autoconfigured driver
(==) Assigned the driver to the xf86ConfigLayout
(II) Loading /usr/lib/xorg/modules/drivers//intel_drv.so
(II) Module intel: vendor="X.Org Foundation"
        compiled for 1.4.2, module version = 2.3.2
(II) Loading /usr/lib/xorg/modules/input//kbd_drv.so
(II) Module kbd: vendor="X.Org Foundation"
        compiled for 1.4.0.90, module version = 1.3.1
(II) Loading /usr/lib/xorg/modules/input//mouse_drv.so
(II) Module mouse: vendor="X.Org Foundation"
        compiled for 1.4.0.90, module version = 1.3.0
(II) v4l driver for Video4Linux
(II) intel: Driver for Intel Integrated Graphics Chipsets: i810,
        i810-dc100, i810e, i815, i830M, 845G, 852GM/855GM, 865G, 915G,
        E7221 (i915), 915GM, 945G, 945GM, 945GME, 965G, G35, 965Q, 946GZ,
        965GM, 965GME/GLE, G33, Q35, Q33,
        Mobile Intel® GM45 Express Chipset,
        Intel Integrated Graphics Device, G45/G43, Q45/Q43, G41
(--) Assigning device section with no busID to primary device
(WW) intel: No matching Device section for instance (BusID PCI:0:2:1) found
(--) Chipset 945GME found
(II) Loading /usr/lib/xorg/modules//libvgahw.so
(II) Module vgahw: vendor="X.Org Foundation"
        compiled for 1.4.2, module version = 0.1.0
(**) intel(0): Depth 16, (--) framebuffer bpp 16
(==) intel(0): RGB weight 565
(==) intel(0): Default visual is TrueColor
(II) intel(0): Integrated Graphics Chipset: Intel(R) 945GME
(--) intel(0): Chipset: "945GME"
(--) intel(0): Linear framebuffer at 0xD0000000
(--) intel(0): IO registers at addr 0xFE980000
(II) intel(0): 2 display pipes available.
(**) intel(0): Using XAA for acceleration
(II) Module "ddc" already built-in
(II) Module "i2c" already built-in
(II) intel(0): Output VGA using monitor section LCD 1600x1200
(II) intel(0): I2C bus "CRTDDC_A" initialized.
(II) intel(0): Output LVDS has no monitor section
(II) intel(0): I2C bus "LVDSDDC_C" initialized.
(II) intel(0): Attempting to determine panel fixed mode.
(II) intel(0): I2C device "LVDSDDC_C:ddc2" registered at address 0xA0.
(II) intel(0): I2C device "LVDSDDC_C:ddc2" removed.
(II) intel(0): initializing int10
(WW) intel(0): Bad V_BIOS checksum
(II) intel(0): Primary V_BIOS segment is: 0xc000
(II) intel(0): VESA BIOS detected
(II) intel(0): I2C bus "SDVOCTRL_E for SDVOB" initialized.
(II) intel(0): I2C device "SDVOCTRL_E for SDVOB:SDVO Controller B" registered at address 0x70.
(II) intel(0): No SDVO device found on SDVOB
(II) intel(0): I2C device "SDVOCTRL_E for SDVOB:SDVO Controller B" removed.
(II) intel(0): I2C bus "SDVOCTRL_E for SDVOB" removed.
(II) intel(0): I2C bus "SDVOCTRL_E for SDVOC" initialized.
(II) intel(0): I2C device "SDVOCTRL_E for SDVOC:SDVO Controller C" registered at address 0x72.
(II) intel(0): No SDVO device found on SDVOC
(II) intel(0): I2C device "SDVOCTRL_E for SDVOC:SDVO Controller C" removed.
(II) intel(0): I2C bus "SDVOCTRL_E for SDVOC" removed.
(II) intel(0): Output TV has no monitor section
(II) intel(0): I2C device "CRTDDC_A:ddc2" registered at address 0xA0.
(II) intel(0): EDID vendor "SAM", prod id 476
(II) intel(0): Using hsync ranges from config file
(II) intel(0): Using vrefresh ranges from config file
(II) intel(0): Printing DDC gathered Modelines:
(II) intel(0): Modeline "1280x1024"x0.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsy
nc +vsync (64.0 kHz)
(II) intel(0): Modeline "800x600"x0.0   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync
 (37.9 kHz)
(II) intel(0): Modeline "800x600"x0.0   36.00  800 824 896 1024  600 601 603 625 +hsync +vsync
 (35.2 kHz)
(II) intel(0): Modeline "640x480"x0.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync 
(37.5 kHz)
(II) intel(0): Modeline "640x480"x0.0   31.50  640 664 704 832  480 489 491 520 -hsync -vsync 
(37.9 kHz)
(II) intel(0): Modeline "640x480"x0.0   30.24  640 704 768 864  480 483 486 525 -hsync -vsync 
(35.0 kHz)
(II) intel(0): Modeline "640x480"x0.0   25.20  640 656 752 800  480 490 492 525 -hsync -vsync 
(31.5 kHz)
(II) intel(0): Modeline "720x400"x0.0   28.32  720 738 846 900  400 412 414 449 -hsync +vsync 
(31.5 kHz)
(II) intel(0): Modeline "1280x1024"x0.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsy
nc +vsync (80.0 kHz)
(II) intel(0): Modeline "1024x768"x0.0   78.80  1024 1040 1136 1312  768 769 772 800 +hsync +v
sync (60.1 kHz)
(II) intel(0): Modeline "1024x768"x0.0   75.00  1024 1048 1184 1328  768 771 777 806 -hsync -v
sync (56.5 kHz)
(II) intel(0): Modeline "1024x768"x0.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -v
sync (48.4 kHz)
(II) intel(0): Modeline "832x624"x0.0   57.28  832 864 928 1152  624 625 628 667 -hsync -vsync
 (49.7 kHz)
(II) intel(0): Modeline "800x600"x0.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync
 (46.9 kHz)
(II) intel(0): Modeline "800x600"x0.0   50.00  800 856 976 1040  600 637 643 666 +hsync +vsync
 (48.1 kHz)
(II) intel(0): Modeline "1152x864"x0.0  108.00  1152 1216 1344 1600  864 865 868 900 +hsync +v
sync (67.5 kHz)
(II) intel(0): Modeline "1280x1024"x59.9  109.00  1280 1368 1496 1712  1024 1027 1034 1063 -hs
ync +vsync (63.7 kHz)
(II) intel(0): Modeline "1280x960"x59.9  101.25  1280 1360 1488 1696  960 963 967 996 -hsync +
vsync (59.7 kHz)
(II) intel(0): Modeline "1152x864"x74.8  104.00  1152 1224 1344 1536  864 867 871 905 -hsync +
vsync (67.7 kHz)
(II) intel(0): EDID vendor "SAM", prod id 476
(II) intel(0): I2C device "LVDSDDC_C:ddc2" registered at address 0xA0.
(II) intel(0): I2C device "LVDSDDC_C:ddc2" removed.
(II) intel(0): Output VGA connected
(II) intel(0): Output LVDS connected
(II) intel(0): Output TV disconnected
(II) intel(0): Output VGA using initial mode 1280x1024
(II) intel(0): Output LVDS using initial mode 800x600
(II) intel(0): Monitoring connected displays enabled
(II) intel(0): detected 256 kB GTT.
(II) intel(0): detected 7932 kB stolen memory.
(==) intel(0): video overlay key set to 0x83e
(==) intel(0): Will not try to enable page flipping
(==) intel(0): Triple buffering disabled
(==) intel(0): Intel XvMC decoder disabled
(==) intel(0): Using gamma correction (1.0, 1.0, 1.0)
(**) intel(0): Display dimensions: (340, 270) mm
(**) intel(0): DPI set to (119, 150)
(II) Loading /usr/lib/xorg/modules//libfb.so
(II) Module fb: vendor="X.Org Foundation"
        compiled for 1.4.2, module version = 1.0.0
(II) Loading /usr/lib/xorg/modules//libxaa.so
(II) Module xaa: vendor="X.Org Foundation"
        compiled for 1.4.2, module version = 1.2.0
(II) Module "ramdac" already built-in
(II) intel(0): Comparing regs from server start up to After PreInit
(WW) intel(0): Register 0x61200 (PP_STATUS) changed from 0xc0000008 to 0xd000000a
(WW) intel(0): PP_STATUS before: on, ready, sequencing idle
(WW) intel(0): PP_STATUS after: on, ready, sequencing on
(WW) intel(0): Register 0x61114 (PORT_HOTPLUG_STAT) changed from 0x00000b00 to 0x00000f00
(WW) intel(0): Register 0x68000 (TV_CTL) changed from 0x10000010 to 0x000c0010
(WW) intel(0): Register 0x68010 (TV_CSC_Y) changed from 0x00000000 to 0x0332012d
(WW) intel(0): Register 0x68014 (TV_CSC_Y2) changed from 0x00000000 to 0x07d30104
(WW) intel(0): Register 0x68018 (TV_CSC_U) changed from 0x00000000 to 0x0733052d
(WW) intel(0): Register 0x6801c (TV_CSC_U2) changed from 0x00000000 to 0x05c70200
(WW) intel(0): Register 0x68020 (TV_CSC_V) changed from 0x00000000 to 0x0340030c
(WW) intel(0): Register 0x68024 (TV_CSC_V2) changed from 0x00000000 to 0x06d00200
(WW) intel(0): Register 0x68028 (TV_CLR_KNOBS) changed from 0x00000000 to 0x00606000
(WW) intel(0): Register 0x6802c (TV_CLR_LEVEL) changed from 0x00000000 to 0x010b00e1
(WW) intel(0): Register 0x68030 (TV_H_CTL_1) changed from 0x00000000 to 0x00400359
(WW) intel(0): Register 0x68034 (TV_H_CTL_2) changed from 0x00000000 to 0x80480022
(WW) intel(0): Register 0x68038 (TV_H_CTL_3) changed from 0x00000000 to 0x007c0344
(WW) intel(0): Register 0x6803c (TV_V_CTL_1) changed from 0x00000000 to 0x00f01415
(WW) intel(0): Register 0x68040 (TV_V_CTL_2) changed from 0x00000000 to 0x00060607
(WW) intel(0): Register 0x68044 (TV_V_CTL_3) changed from 0x00000000 to 0x80120001
(WW) intel(0): Register 0x68048 (TV_V_CTL_4) changed from 0x00000000 to 0x000900f0
(WW) intel(0): Register 0x6804c (TV_V_CTL_5) changed from 0x00000000 to 0x000a00f0
(WW) intel(0): Register 0x68050 (TV_V_CTL_6) changed from 0x00000000 to 0x000900f0
(WW) intel(0): Register 0x68054 (TV_V_CTL_7) changed from 0x00000000 to 0x000a00f0
(WW) intel(0): Register 0x68060 (TV_SC_CTL_1) changed from 0x00000000 to 0xc1710088
(WW) intel(0): Register 0x68064 (TV_SC_CTL_2) changed from 0x00000000 to 0x4e2d1dc8
(WW) intel(0): Register 0x68070 (TV_WIN_POS) changed from 0x00000000 to 0x00360024
(WW) intel(0): Register 0x68074 (TV_WIN_SIZE) changed from 0x00000000 to 0x02640198
(WW) intel(0): Register 0x68080 (TV_FILTER_CTL_1) changed from 0x00000000 to 0x800010bb
(WW) intel(0): Register 0x68084 (TV_FILTER_CTL_2) changed from 0x00000000 to 0x00028283
(WW) intel(0): Register 0x68088 (TV_FILTER_CTL_3) changed from 0x00000000 to 0x00014141
(WW) intel(0): Register 0x68100 (TV_H_LUMA_0) changed from 0x00000000 to 0xb1403000
(WW) intel(0): Register 0x681ec (TV_H_LUMA_59) changed from 0x00000000 to 0x0000b060
(WW) intel(0): Register 0x68200 (TV_H_CHROMA_0) changed from 0x00000000 to 0xb1403000
(WW) intel(0): Register 0x682ec (TV_H_CHROMA_59) changed from 0x00000000 to 0x0000b060
(II) intel(0): Kernel reported 107520 total, 0 used
(II) [drm] DRM interface version 1.4
(II) [drm] DRM open master succeeded.
(II) intel(0): [drm] Using the DRM lock SAREA also for drawables.
(II) intel(0): [drm] framebuffer mapped by ddx driver
(II) intel(0): [drm] added 1 reserved context for kernel
(II) intel(0): X context handle = 0x1
(II) intel(0): [drm] installed DRM signal handler
(**) intel(0): Framebuffer compression enabled
(**) intel(0): Tiling enabled
(==) intel(0): VideoRam: 262144 KB
(II) intel(0): Attempting memory allocation with tiled buffers.
(II) intel(0): Allocating 4800 scanlines for pixmap cache
(II) intel(0): Tiled allocation successful.
(II) intel(0): [drm] Registers = 0xfe980000
(II) intel(0): [drm] ring buffer = 0xd0000000
(II) intel(0): [drm] mapped front buffer at 0xd2000000, handle = 0xd2000000
(II) intel(0): [drm] mapped back buffer at 0xd0800000, handle = 0xd0800000
(II) intel(0): [drm] mapped depth buffer at 0xd1000000, handle = 0xd1000000
(II) intel(0): [drm] mapped classic textures at 0xd4000000, handle = 0xd4000000
(II) intel(0): [drm] Initialized kernel agp heap manager, 33554432
(II) intel(0): [dri] visual configs initialized
(II) intel(0): Page Flipping disabled
(==) intel(0): Write-combining range (0xd0000000,0x10000000)
(II) intel(0): Using XFree86 Acceleration Architecture (XAA)
        Screen to screen bit blits
        Solid filled rectangles
        8x8 mono pattern filled rectangles
        Indirect CPU to Screen color expansion
        Solid Horizontal and Vertical Lines
        Setting up tile and stipple cache:
                32 128x128 slots
                32 256x256 slots
                16 512x512 slots
(==) intel(0): Backing store disabled
(==) intel(0): Silken mouse enabled
(II) intel(0): Initializing HW Cursor
(II) intel(0): [DRI] installation complete
(II) intel(0): Fixed memory allocation layout:
(II) intel(0): 0x00000000-0x0001ffff: ring buffer (128 kB)
(II) intel(0): 0x00020000-0x0061ffff: compressed frame buffer (6144 kB, 0x000000001f820000 physical
)
(II) intel(0): 0x00620000-0x00620fff: compressed ll buffer (4 kB, 0x000000001fe20000 physical
)
(II) intel(0): 0x00621000-0x0062afff: HW cursors (40 kB, 0x000000001fe21000 physical
)
(II) intel(0): 0x0062b000-0x00632fff: logical 3D context (32 kB)
(II) intel(0): 0x00633000-0x00633fff: overlay registers (4 kB, 0x000000001fe33000 physical
)
(II) intel(0): 0x00634000-0x00643fff: xaa scratch (64 kB)
(II) intel(0): 0x007bf000:            end of stolen memory
(II) intel(0): 0x00800000-0x00ffffff: back buffer (6400 kB) X tiled
(II) intel(0): 0x01000000-0x017fffff: depth buffer (6400 kB) X tiled
(II) intel(0): 0x02000000-0x03ffffff: front buffer (25600 kB) X tiled
(II) intel(0): 0x04000000-0x05ffffff: classic textures (32768 kB)
(II) intel(0): 0x10000000:            end of aperture
(II) intel(0): Selecting standard 18 bit TMDS pixel format.
(II) intel(0): Output configuration:
(II) intel(0):   Pipe A is on
(II) intel(0):   Display plane A is now enabled and connected to pipe A.
(II) intel(0):   Pipe B is on
(II) intel(0):   Display plane B is now enabled and connected to pipe B.
(II) intel(0):   Output VGA is connected to pipe A
(II) intel(0):   Output LVDS is connected to pipe B
(II) intel(0):   Output TV is connected to pipe none
(II) intel(0): [drm] dma control initialized, using IRQ 16
