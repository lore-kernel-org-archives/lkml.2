Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab1BVIy1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 03:54:27 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:56361 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab1BVIyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 03:54:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=HdjiMHhuOm95y6zXG1yxkBHxjo+4vC3uhvPhU0gkvLz0rjeiudApEzpLfvuE2CYuF1
         HRHwHrbVy+DCiW5/+PDeIxNBuGoZA0VA39pxm/ifxNhijpKxUznPZ31zg/t9xjiqubQC
         yuI/kgtYUzS6LsnWGUxUKVUpt3X40HZnytnUI=
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] staging: remove null checks before kfree
Date: Tue, 22 Feb 2011 03:53:40 -0500
Message-Id: <1298364821-18915-1-git-send-email-imirkin@alum.mit.edu>
X-Mailer: git-send-email 1.7.3.4
To: Greg Kroah-Hartman <gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch was created with the following semantic patch:

// <smpl>
@@
expression E;
@@

- if (E != NULL) kfree(E);
+ kfree(E);
// </smpl>

Signed-off-by: Ilia Mirkin <imirkin@alum.mit.edu>
---

Hi Greg,

Please let me know if you would rather I split these up by driver instead.
I didn't because I saw that you took staging-wide cleanups before.

 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c       |    3 +--
 drivers/staging/brcm80211/brcmfmac/dhd_common.c    |    9 +++------
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |    3 +--
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c      |   18 ++++++------------
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c   |    3 +--
 drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c |    6 ++----
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.c   |    9 +++------
 drivers/staging/brcm80211/brcmsmac/wlc_alloc.c     |    6 ++----
 drivers/staging/brcm80211/brcmsmac/wlc_channel.c   |    3 +--
 drivers/staging/brcm80211/util/bcmotp.c            |    3 +--
 drivers/staging/brcm80211/util/bcmsrom.c           |    6 ++----
 drivers/staging/brcm80211/util/hnddma.c            |    6 ++----
 drivers/staging/comedi/drivers/das16.c             |    6 ++----
 drivers/staging/comedi/drivers/ni_at_a2150.c       |    3 +--
 drivers/staging/comedi/drivers/ni_labpc.c          |    3 +--
 drivers/staging/cx25821/cx25821-audio-upstream.c   |    3 +--
 .../staging/cx25821/cx25821-video-upstream-ch2.c   |    3 +--
 drivers/staging/cx25821/cx25821-video-upstream.c   |    3 +--
 drivers/staging/go7007/go7007-usb.c                |    6 ++----
 drivers/staging/hv/channel_mgmt.c                  |    3 +--
 drivers/staging/keucr/ms.c                         |    8 ++++----
 drivers/staging/line6/pcm.c                        |    3 +--
 drivers/staging/pohmelfs/config.c                  |    6 ++----
 drivers/staging/rt2860/common/spectrum.c           |    6 ++----
 drivers/staging/rt2860/rt_linux.c                  |    6 ++----
 .../rtl8187se/ieee80211/ieee80211_softmac.c        |    3 +--
 drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c |    1 -
 drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c  |    1 -
 drivers/staging/rtl8192u/ieee80211/cipher.c        |    3 +--
 drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c  |    1 -
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c      |    3 +--
 drivers/staging/serqt_usb2/serqt_usb2.c            |    3 +--
 drivers/staging/tidspbridge/core/chnl_sm.c         |    3 +--
 drivers/staging/tidspbridge/pmgr/dbll.c            |    3 +--
 drivers/staging/usbip/stub_main.c                  |    6 ++----
 drivers/staging/vme/bridges/vme_ca91cx42.c         |    3 +--
 drivers/staging/vme/bridges/vme_tsi148.c           |    3 +--
 drivers/staging/vt6655/device_main.c               |    3 +--
 drivers/staging/vt6655/hostap.c                    |    3 +--
 drivers/staging/vt6655/wpactl.c                    |    3 +--
 drivers/staging/vt6656/firmware.c                  |    3 +--
 drivers/staging/vt6656/hostap.c                    |    3 +--
 drivers/staging/vt6656/main_usb.c                  |   12 ++++--------
 drivers/staging/vt6656/wpactl.c                    |    3 +--
 drivers/staging/winbond/wb35reg.c                  |    3 +--
 drivers/staging/wlan-ng/prism2fw.c                 |    3 +--
 46 files changed, 68 insertions(+), 135 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
index ed204d5..c0a6cfd 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
@@ -417,8 +417,7 @@ int dhd_prot_attach(dhd_pub_t *dhd)
 	return 0;
 
 fail:
-	if (cdc != NULL)
-		kfree(cdc);
+	kfree(cdc);
 	return BCME_NOMEM;
 }
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index b2a6fb2..1857576 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -1003,8 +1003,7 @@ dhd_pktfilter_offload_enable(dhd_pub_t *dhd, char *arg, int enable,
 			   __func__, arg, rc));
 
 fail:
-	if (arg_org)
-		kfree(arg_org);
+	kfree(arg_org);
 }
 
 void dhd_pktfilter_offload_set(dhd_pub_t *dhd, char *arg)
@@ -1139,11 +1138,9 @@ void dhd_pktfilter_offload_set(dhd_pub_t *dhd, char *arg)
 			   __func__, arg));
 
 fail:
-	if (arg_org)
-		kfree(arg_org);
+	kfree(arg_org);
 
-	if (buf)
-		kfree(buf);
+	kfree(buf);
 }
 
 void dhd_arp_offload_set(dhd_pub_t *dhd, int arp_mode)
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index ffba746..48157b0 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -1787,8 +1787,7 @@ done:
 			bcmerror = -EFAULT;
 	}
 
-	if (buf)
-		kfree(buf);
+	kfree(buf);
 
 	if (bcmerror > 0)
 		bcmerror = 0;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 916c555..061cc82 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -1931,10 +1931,8 @@ static int dhdsdio_checkdied(dhd_bus_t *bus, u8 *data, uint size)
 #endif				/* DHD_DEBUG */
 
 done:
-	if (mbuffer)
-		kfree(mbuffer);
-	if (str)
-		kfree(str);
+	kfree(mbuffer);
+	kfree(str);
 
 	return bcmerror;
 }
@@ -1963,8 +1961,7 @@ static int dhdsdio_mem_dump(dhd_bus_t *bus)
 		ret = dhdsdio_membytes(bus, false, start, databuf, read_size);
 		if (ret) {
 			DHD_ERROR(("%s: Error membytes %d\n", __func__, ret));
-			if (buf)
-				kfree(buf);
+			kfree(buf);
 			return -1;
 		}
 		printk(".");
@@ -2082,8 +2079,7 @@ int dhdsdio_downloadvars(dhd_bus_t *bus, void *arg, int len)
 	}
 
 	/* Free the old ones and replace with passed variables */
-	if (bus->vars)
-		kfree(bus->vars);
+	kfree(bus->vars);
 
 	bus->vars = kmalloc(len, GFP_ATOMIC);
 	bus->varsz = bus->vars ? len : 0;
@@ -5763,8 +5759,7 @@ static int dhdsdio_download_code_file(struct dhd_bus *bus, char *fw_path)
 	}
 
 err:
-	if (memblock)
-		kfree(memblock);
+	kfree(memblock);
 
 	if (image)
 		dhd_os_close_image(image);
@@ -5903,8 +5898,7 @@ static int dhdsdio_download_nvram(struct dhd_bus *bus)
 	}
 
 err:
-	if (memblock)
-		kfree(memblock);
+	kfree(memblock);
 
 	if (image)
 		dhd_os_close_image(image);
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
index 0760d97..260d464 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
@@ -784,8 +784,7 @@ wlc_phy_t *wlc_phy_attach(shared_phy_t *sh, void *regs, int bandtype, char *vars
 	return &pi->pubpi_ro;
 
  err:
-	if (pi)
-		kfree(pi);
+	kfree(pi);
 	return NULL;
 }
 
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c
index c6cce8d..49277d8 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c
@@ -22386,8 +22386,7 @@ wlc_phy_gen_load_samples_nphy(phy_info_t *pi, u32 f_kHz, u16 max_val,
 
 	wlc_phy_loadsampletable_nphy(pi, tone_buf, num_samps);
 
-	if (tone_buf != NULL)
-		kfree(tone_buf);
+	kfree(tone_buf);
 
 	return num_samps;
 }
@@ -22434,8 +22433,7 @@ wlc_phy_loadsampletable_nphy(phy_info_t *pi, cs32 *tone_buf,
 	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_SAMPLEPLAY, num_samps, 0, 32,
 				 data_buf);
 
-	if (data_buf != NULL)
-		kfree(data_buf);
+	kfree(data_buf);
 
 	if (pi->phyhang_avoid)
 		wlc_phy_stay_in_carriersearch_nphy(pi, false);
diff --git a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
index 56f5d3a..9b47679 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
+++ b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
@@ -1336,8 +1336,7 @@ void wl_free(struct wl_info *wl)
 	for (t = wl->timers; t; t = next) {
 		next = t->next;
 #ifdef BCMDBG
-		if (t->name)
-			kfree(t->name);
+		kfree(t->name);
 #endif
 		kfree(t);
 	}
@@ -1664,8 +1663,7 @@ void wl_free_timer(struct wl_info *wl, wl_timer_t *t)
 	if (wl->timers == t) {
 		wl->timers = wl->timers->next;
 #ifdef BCMDBG
-		if (t->name)
-			kfree(t->name);
+		kfree(t->name);
 #endif
 		kfree(t);
 		return;
@@ -1677,8 +1675,7 @@ void wl_free_timer(struct wl_info *wl, wl_timer_t *t)
 		if (tmp->next == t) {
 			tmp->next = t->next;
 #ifdef BCMDBG
-			if (t->name)
-				kfree(t->name);
+			kfree(t->name);
 #endif
 			kfree(t);
 			return;
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c b/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c
index 2db96c1..b7934ed 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c
@@ -325,8 +325,7 @@ void wlc_detach_mfree(struct wlc_info *wlc, struct osl_info *osh)
 		wlc->pkt_callback = NULL;
 	}
 
-	if (wlc->wsec_def_keys[0])
-		kfree(wlc->wsec_def_keys[0]);
+	kfree(wlc->wsec_def_keys[0]);
 	if (wlc->protection) {
 		kfree(wlc->protection);
 		wlc->protection = NULL;
@@ -337,8 +336,7 @@ void wlc_detach_mfree(struct wlc_info *wlc, struct osl_info *osh)
 		wlc->stf = NULL;
 	}
 
-	if (wlc->bandstate[0])
-		kfree(wlc->bandstate[0]);
+	kfree(wlc->bandstate[0]);
 
 	if (wlc->corestate) {
 		if (wlc->corestate->macstat_snapshot) {
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_channel.c b/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
index 06b31a0..b69ae21 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
@@ -654,8 +654,7 @@ wlc_cm_info_t *wlc_channel_mgr_attach(struct wlc_info *wlc)
 
 void wlc_channel_mgr_detach(wlc_cm_info_t *wlc_cm)
 {
-	if (wlc_cm)
-		kfree(wlc_cm);
+	kfree(wlc_cm);
 }
 
 u8 wlc_channel_locale_flags_in_band(wlc_cm_info_t *wlc_cm, uint bandunit)
diff --git a/drivers/staging/brcm80211/util/bcmotp.c b/drivers/staging/brcm80211/util/bcmotp.c
index 6fa04ed..556b180 100644
--- a/drivers/staging/brcm80211/util/bcmotp.c
+++ b/drivers/staging/brcm80211/util/bcmotp.c
@@ -842,8 +842,7 @@ static int hndotp_nvread(void *oh, char *data, uint *len)
 	*len = offset;
 
  out:
-	if (rawotp)
-		kfree(rawotp);
+	kfree(rawotp);
 	si_setcoreidx(oi->sih, idx);
 
 	return rc;
diff --git a/drivers/staging/brcm80211/util/bcmsrom.c b/drivers/staging/brcm80211/util/bcmsrom.c
index b26877c..3c88018 100644
--- a/drivers/staging/brcm80211/util/bcmsrom.c
+++ b/drivers/staging/brcm80211/util/bcmsrom.c
@@ -1520,8 +1520,7 @@ static int otp_read_pci(struct osl_info *osh, si_t *sih, u16 *buf, uint bufsz)
 
 	memcpy(buf, otp, bufsz);
 
-	if (otp)
-		kfree(otp);
+	kfree(otp);
 
 	/* Check CRC */
 	if (buf[0] == 0xffff) {
@@ -1979,8 +1978,7 @@ static int initvars_srom_pci(si_t *sih, void *curmap, char **vars, uint *count)
 	err = initvars_table(osh, base, vp, vars, count);
 
  errout:
-	if (base)
-		kfree(base);
+	kfree(base);
 
 	kfree(srom);
 	return err;
diff --git a/drivers/staging/brcm80211/util/hnddma.c b/drivers/staging/brcm80211/util/hnddma.c
index 3f1d63e..56fed04 100644
--- a/drivers/staging/brcm80211/util/hnddma.c
+++ b/drivers/staging/brcm80211/util/hnddma.c
@@ -557,12 +557,10 @@ static void _dma_detach(dma_info_t *di)
 		kfree((void *)di->rxp);
 
 	/* free tx packet DMA handles */
-	if (di->txp_dmah)
-		kfree(di->txp_dmah);
+	kfree(di->txp_dmah);
 
 	/* free rx packet DMA handles */
-	if (di->rxp_dmah)
-		kfree(di->rxp_dmah);
+	kfree(di->rxp_dmah);
 
 	/* free our private info structure */
 	kfree((void *)di);
diff --git a/drivers/staging/comedi/drivers/das16.c b/drivers/staging/comedi/drivers/das16.c
index 0af1b46..e7905ba 100644
--- a/drivers/staging/comedi/drivers/das16.c
+++ b/drivers/staging/comedi/drivers/das16.c
@@ -1695,10 +1695,8 @@ static int das16_detach(struct comedi_device *dev)
 		}
 		if (devpriv->dma_chan)
 			free_dma(devpriv->dma_chan);
-		if (devpriv->user_ai_range_table)
-			kfree(devpriv->user_ai_range_table);
-		if (devpriv->user_ao_range_table)
-			kfree(devpriv->user_ao_range_table);
+		kfree(devpriv->user_ai_range_table);
+		kfree(devpriv->user_ao_range_table);
 	}
 
 	if (dev->irq)
diff --git a/drivers/staging/comedi/drivers/ni_at_a2150.c b/drivers/staging/comedi/drivers/ni_at_a2150.c
index e46d62b..4d0053e 100644
--- a/drivers/staging/comedi/drivers/ni_at_a2150.c
+++ b/drivers/staging/comedi/drivers/ni_at_a2150.c
@@ -479,8 +479,7 @@ static int a2150_detach(struct comedi_device *dev)
 	if (devpriv) {
 		if (devpriv->dma)
 			free_dma(devpriv->dma);
-		if (devpriv->dma_buffer)
-			kfree(devpriv->dma_buffer);
+		kfree(devpriv->dma_buffer);
 	}
 
 	return 0;
diff --git a/drivers/staging/comedi/drivers/ni_labpc.c b/drivers/staging/comedi/drivers/ni_labpc.c
index 0728c3c..241fe52 100644
--- a/drivers/staging/comedi/drivers/ni_labpc.c
+++ b/drivers/staging/comedi/drivers/ni_labpc.c
@@ -797,8 +797,7 @@ int labpc_common_detach(struct comedi_device *dev)
 		subdev_8255_cleanup(dev, dev->subdevices + 2);
 
 	/* only free stuff if it has been allocated by _attach */
-	if (devpriv->dma_buffer)
-		kfree(devpriv->dma_buffer);
+	kfree(devpriv->dma_buffer);
 	if (devpriv->dma_chan)
 		free_dma(devpriv->dma_chan);
 	if (dev->irq)
diff --git a/drivers/staging/cx25821/cx25821-audio-upstream.c b/drivers/staging/cx25821/cx25821-audio-upstream.c
index 7992a3b..be657df 100644
--- a/drivers/staging/cx25821/cx25821-audio-upstream.c
+++ b/drivers/staging/cx25821/cx25821-audio-upstream.c
@@ -249,8 +249,7 @@ void cx25821_stop_upstream_audio(struct cx25821_dev *dev)
 		dev->_irq_audio_queues = NULL;
 	}
 
-	if (dev->_audiofilename != NULL)
-		kfree(dev->_audiofilename);
+	kfree(dev->_audiofilename);
 }
 
 void cx25821_free_mem_upstream_audio(struct cx25821_dev *dev)
diff --git a/drivers/staging/cx25821/cx25821-video-upstream-ch2.c b/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
index e2efacd..586739d 100644
--- a/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
+++ b/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
@@ -239,8 +239,7 @@ void cx25821_stop_upstream_video_ch2(struct cx25821_dev *dev)
 		dev->_irq_queues_ch2 = NULL;
 	}
 
-	if (dev->_filename_ch2 != NULL)
-		kfree(dev->_filename_ch2);
+	kfree(dev->_filename_ch2);
 
 	tmp = cx_read(VID_CH_MODE_SEL);
 	cx_write(VID_CH_MODE_SEL, tmp & 0xFFFFFE00);
diff --git a/drivers/staging/cx25821/cx25821-video-upstream.c b/drivers/staging/cx25821/cx25821-video-upstream.c
index 31b4e3c..25bfd8a 100644
--- a/drivers/staging/cx25821/cx25821-video-upstream.c
+++ b/drivers/staging/cx25821/cx25821-video-upstream.c
@@ -284,8 +284,7 @@ void cx25821_stop_upstream_video_ch1(struct cx25821_dev *dev)
 		dev->_irq_queues = NULL;
 	}
 
-	if (dev->_filename != NULL)
-		kfree(dev->_filename);
+	kfree(dev->_filename);
 
 	tmp = cx_read(VID_CH_MODE_SEL);
 	cx_write(VID_CH_MODE_SEL, tmp & 0xFFFFFE00);
diff --git a/drivers/staging/go7007/go7007-usb.c b/drivers/staging/go7007/go7007-usb.c
index bea9f4d..3db3b0a 100644
--- a/drivers/staging/go7007/go7007-usb.c
+++ b/drivers/staging/go7007/go7007-usb.c
@@ -1247,15 +1247,13 @@ static void go7007_usb_disconnect(struct usb_interface *intf)
 		vurb = usb->video_urbs[i];
 		if (vurb) {
 			usb_kill_urb(vurb);
-			if (vurb->transfer_buffer)
-				kfree(vurb->transfer_buffer);
+			kfree(vurb->transfer_buffer);
 			usb_free_urb(vurb);
 		}
 		aurb = usb->audio_urbs[i];
 		if (aurb) {
 			usb_kill_urb(aurb);
-			if (aurb->transfer_buffer)
-				kfree(aurb->transfer_buffer);
+			kfree(aurb->transfer_buffer);
 			usb_free_urb(aurb);
 		}
 	}
diff --git a/drivers/staging/hv/channel_mgmt.c b/drivers/staging/hv/channel_mgmt.c
index 0781c0e..0fe4e2d 100644
--- a/drivers/staging/hv/channel_mgmt.c
+++ b/drivers/staging/hv/channel_mgmt.c
@@ -829,8 +829,7 @@ int vmbus_request_offers(void)
 
 
 cleanup:
-	if (msginfo)
-		kfree(msginfo);
+	kfree(msginfo);
 
 	return ret;
 }
diff --git a/drivers/staging/keucr/ms.c b/drivers/staging/keucr/ms.c
index 452ea8f..7779d3b 100644
--- a/drivers/staging/keucr/ms.c
+++ b/drivers/staging/keucr/ms.c
@@ -242,8 +242,8 @@ int MS_CardInit(struct us_data *us)
 	result = MS_STATUS_SUCCESS;
 
 exit:
-	if (PageBuffer1)		kfree(PageBuffer1);
-    	if (PageBuffer0)		kfree(PageBuffer0);
+	kfree(PageBuffer1);
+    	kfree(PageBuffer0);
 
 	printk("MS_CardInit end\n");
 	return result;
@@ -278,7 +278,7 @@ int MS_LibCheckDisableBlock(struct us_data *us, WORD PhyBlock)
 	} while(1);
 
 exit:
-	if (PageBuf)	kfree(PageBuf);
+	kfree(PageBuf);
 	return result;
 }
 
@@ -468,7 +468,7 @@ int MS_LibProcessBootBlock(struct us_data *us, WORD PhyBlock, BYTE *PageData)
 
 exit:
 	if (result)		MS_LibFreeLogicalMap(us);
-	if (PageBuffer)	kfree(PageBuffer);
+	kfree(PageBuffer);
 
 	result = 0;
 	return result;
diff --git a/drivers/staging/line6/pcm.c b/drivers/staging/line6/pcm.c
index b9c55f9..9d4c8a6 100644
--- a/drivers/staging/line6/pcm.c
+++ b/drivers/staging/line6/pcm.c
@@ -189,8 +189,7 @@ int line6_pcm_stop(struct snd_line6_pcm *line6pcm, int channels)
 		line6pcm->buffer_out = NULL;
 	}
 #if LINE6_BACKUP_MONITOR_SIGNAL
-	if (line6pcm->prev_fbuf != NULL)
-		kfree(line6pcm->prev_fbuf);
+	kfree(line6pcm->prev_fbuf);
 #endif
 
 	return 0;
diff --git a/drivers/staging/pohmelfs/config.c b/drivers/staging/pohmelfs/config.c
index ed91330..a9a3e25 100644
--- a/drivers/staging/pohmelfs/config.c
+++ b/drivers/staging/pohmelfs/config.c
@@ -601,11 +601,9 @@ void pohmelfs_config_exit(void)
 
 		list_del(&g->group_entry);
 
-		if (g->hash_string)
-			kfree(g->hash_string);
+		kfree(g->hash_string);
 
-		if (g->cipher_string)
-			kfree(g->cipher_string);
+		kfree(g->cipher_string);
 
 		kfree(g);
 	}
diff --git a/drivers/staging/rt2860/common/spectrum.c b/drivers/staging/rt2860/common/spectrum.c
index 1dfb802..c0d2f42 100644
--- a/drivers/staging/rt2860/common/spectrum.c
+++ b/drivers/staging/rt2860/common/spectrum.c
@@ -416,8 +416,7 @@ void MeasureReqTabExit(struct rt_rtmp_adapter *pAd)
 {
 	NdisFreeSpinLock(&pAd->CommonCfg.MeasureReqTabLock);
 
-	if (pAd->CommonCfg.pMeasureReqTab)
-		kfree(pAd->CommonCfg.pMeasureReqTab);
+	kfree(pAd->CommonCfg.pMeasureReqTab);
 	pAd->CommonCfg.pMeasureReqTab = NULL;
 
 	return;
@@ -614,8 +613,7 @@ void TpcReqTabExit(struct rt_rtmp_adapter *pAd)
 {
 	NdisFreeSpinLock(&pAd->CommonCfg.TpcReqTabLock);
 
-	if (pAd->CommonCfg.pTpcReqTab)
-		kfree(pAd->CommonCfg.pTpcReqTab);
+	kfree(pAd->CommonCfg.pTpcReqTab);
 	pAd->CommonCfg.pTpcReqTab = NULL;
 
 	return;
diff --git a/drivers/staging/rt2860/rt_linux.c b/drivers/staging/rt2860/rt_linux.c
index b3f836d..e5b0427 100644
--- a/drivers/staging/rt2860/rt_linux.c
+++ b/drivers/staging/rt2860/rt_linux.c
@@ -241,8 +241,7 @@ void RTMPFreeAdapter(struct rt_rtmp_adapter *pAd)
 
 	os_cookie = (struct os_cookie *)pAd->OS_Cookie;
 
-	if (pAd->BeaconBuf)
-		kfree(pAd->BeaconBuf);
+	kfree(pAd->BeaconBuf);
 
 	NdisFreeSpinLock(&pAd->MgmtRingLock);
 
@@ -264,8 +263,7 @@ void RTMPFreeAdapter(struct rt_rtmp_adapter *pAd)
 	release_firmware(pAd->firmware);
 
 	vfree(pAd);		/* pci_free_consistent(os_cookie->pci_dev,sizeof(struct rt_rtmp_adapter),pAd,os_cookie->pAd_pa); */
-	if (os_cookie)
-		kfree(os_cookie);
+	kfree(os_cookie);
 }
 
 BOOLEAN OS_Need_Clone_Packet(void)
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
index 652d879..ef84e06 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
@@ -2604,8 +2604,7 @@ void ieee80211_softmac_free(struct ieee80211_device *ieee)
 	cancel_delayed_work(&ieee->GPIOChangeRFWorkItem);
 
 	destroy_workqueue(ieee->wq);
-	if(NULL != ieee->pDot11dInfo)
-		kfree(ieee->pDot11dInfo);
+	kfree(ieee->pDot11dInfo);
 	up(&ieee->wx_sem);
 }
 
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c
index 07d8dbc..ca414a9 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c
@@ -735,7 +735,6 @@ int ieee80211_wx_set_gen_ie(struct ieee80211_device *ieee, u8 *ie, size_t len)
 		ieee->wpa_ie_len = len;
 	}
 	else{
-		if (ieee->wpa_ie)
 		kfree(ieee->wpa_ie);
 		ieee->wpa_ie = NULL;
 		ieee->wpa_ie_len = 0;
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c
index cac340e..bb0ff26 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c
@@ -862,7 +862,6 @@ int ieee80211_wx_set_gen_ie(struct ieee80211_device *ieee, u8 *ie, size_t len)
 		ieee->wpa_ie_len = len;
 	}
 	else{
-		if (ieee->wpa_ie)
 		kfree(ieee->wpa_ie);
 		ieee->wpa_ie = NULL;
 		ieee->wpa_ie_len = 0;
diff --git a/drivers/staging/rtl8192u/ieee80211/cipher.c b/drivers/staging/rtl8192u/ieee80211/cipher.c
index 0b9e8a4..69dcc31 100644
--- a/drivers/staging/rtl8192u/ieee80211/cipher.c
+++ b/drivers/staging/rtl8192u/ieee80211/cipher.c
@@ -294,6 +294,5 @@ out:
 
 void crypto_exit_cipher_ops(struct crypto_tfm *tfm)
 {
-	if (tfm->crt_cipher.cit_iv)
-		kfree(tfm->crt_cipher.cit_iv);
+	kfree(tfm->crt_cipher.cit_iv);
 }
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c
index d6f55c2..f0ba7f4 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c
@@ -855,7 +855,6 @@ int ieee80211_wx_set_gen_ie(struct ieee80211_device *ieee, u8 *ie, size_t len)
 		ieee->wpa_ie_len = len;
 	}
 	else{
-		if (ieee->wpa_ie)
 		kfree(ieee->wpa_ie);
 		ieee->wpa_ie = NULL;
 		ieee->wpa_ie_len = 0;
diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
index 221be81..d5eafb5 100644
--- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
@@ -1873,8 +1873,7 @@ static int r871x_mp_ioctl_hdl(struct net_device *dev,
 		goto _r871x_mp_ioctl_hdl_exit;
 	}
 _r871x_mp_ioctl_hdl_exit:
-	if (pparmbuf != NULL)
-		kfree(pparmbuf);
+	kfree(pparmbuf);
 	return ret;
 }
 
diff --git a/drivers/staging/serqt_usb2/serqt_usb2.c b/drivers/staging/serqt_usb2/serqt_usb2.c
index 27841ef..2be2d88 100644
--- a/drivers/staging/serqt_usb2/serqt_usb2.c
+++ b/drivers/staging/serqt_usb2/serqt_usb2.c
@@ -1098,8 +1098,7 @@ static void qt_close(struct usb_serial_port *port)
 
 	if (qt_port->write_urb) {
 		/* if this urb had a transfer buffer already (old tx) free it */
-		if (qt_port->write_urb->transfer_buffer != NULL)
-			kfree(qt_port->write_urb->transfer_buffer);
+		kfree(qt_port->write_urb->transfer_buffer);
 		usb_free_urb(qt_port->write_urb);
 	}
 
diff --git a/drivers/staging/tidspbridge/core/chnl_sm.c b/drivers/staging/tidspbridge/core/chnl_sm.c
index 3c05d7c..8381130 100644
--- a/drivers/staging/tidspbridge/core/chnl_sm.c
+++ b/drivers/staging/tidspbridge/core/chnl_sm.c
@@ -828,8 +828,7 @@ out_err:
 	free_chirp_list(&pchnl->io_requests);
 	free_chirp_list(&pchnl->free_packets_list);
 
-	if (sync_event)
-		kfree(sync_event);
+	kfree(sync_event);
 
 	if (pchnl->ntfy_obj) {
 		ntfy_delete(pchnl->ntfy_obj);
diff --git a/drivers/staging/tidspbridge/pmgr/dbll.c b/drivers/staging/tidspbridge/pmgr/dbll.c
index 2e20f78e..31da62b 100644
--- a/drivers/staging/tidspbridge/pmgr/dbll.c
+++ b/drivers/staging/tidspbridge/pmgr/dbll.c
@@ -272,8 +272,7 @@ void dbll_delete(struct dbll_tar_obj *target)
 	DBC_REQUIRE(refs > 0);
 	DBC_REQUIRE(zl_target);
 
-	if (zl_target != NULL)
-		kfree(zl_target);
+	kfree(zl_target);
 
 }
 
diff --git a/drivers/staging/usbip/stub_main.c b/drivers/staging/usbip/stub_main.c
index f3a4096..076a7e5 100644
--- a/drivers/staging/usbip/stub_main.c
+++ b/drivers/staging/usbip/stub_main.c
@@ -264,11 +264,9 @@ void stub_device_cleanup_urbs(struct stub_device *sdev)
 
 		kmem_cache_free(stub_priv_cache, priv);
 
-		if (urb->transfer_buffer != NULL)
-			kfree(urb->transfer_buffer);
+		kfree(urb->transfer_buffer);
 
-		if (urb->setup_packet != NULL)
-			kfree(urb->setup_packet);
+		kfree(urb->setup_packet);
 
 		usb_free_urb(urb);
 	}
diff --git a/drivers/staging/vme/bridges/vme_ca91cx42.c b/drivers/staging/vme/bridges/vme_ca91cx42.c
index 42de83e..812b8f2 100644
--- a/drivers/staging/vme/bridges/vme_ca91cx42.c
+++ b/drivers/staging/vme/bridges/vme_ca91cx42.c
@@ -516,8 +516,7 @@ static int ca91cx42_alloc_resource(struct vme_master_resource *image,
 	if (existing_size != 0) {
 		iounmap(image->kern_base);
 		image->kern_base = NULL;
-		if (image->bus_resource.name != NULL)
-			kfree(image->bus_resource.name);
+		kfree(image->bus_resource.name);
 		release_resource(&image->bus_resource);
 		memset(&image->bus_resource, 0, sizeof(struct resource));
 	}
diff --git a/drivers/staging/vme/bridges/vme_tsi148.c b/drivers/staging/vme/bridges/vme_tsi148.c
index 26ea42f..c1eacaa 100644
--- a/drivers/staging/vme/bridges/vme_tsi148.c
+++ b/drivers/staging/vme/bridges/vme_tsi148.c
@@ -821,8 +821,7 @@ static int tsi148_alloc_resource(struct vme_master_resource *image,
 	if (existing_size != 0) {
 		iounmap(image->kern_base);
 		image->kern_base = NULL;
-		if (image->bus_resource.name != NULL)
-			kfree(image->bus_resource.name);
+		kfree(image->bus_resource.name);
 		release_resource(&image->bus_resource);
 		memset(&image->bus_resource, 0, sizeof(struct resource));
 	}
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 4fbacf8..8d6a1e1 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -3064,8 +3064,7 @@ else {
 }
 
 error1:
-  if(buffer)
-  	 kfree(buffer);
+  kfree(buffer);
 
   if(filp_close(filp,NULL))
        printk("Config_FileOperation:close file fail\n");
diff --git a/drivers/staging/vt6655/hostap.c b/drivers/staging/vt6655/hostap.c
index 5b83f94..7735027 100644
--- a/drivers/staging/vt6655/hostap.c
+++ b/drivers/staging/vt6655/hostap.c
@@ -860,8 +860,7 @@ int vt6655_hostap_ioctl(PSDevice pDevice, struct iw_point *p)
 	}
 
  out:
-	if (param != NULL)
-		kfree(param);
+	kfree(param);
 
 	return ret;
 }
diff --git a/drivers/staging/vt6655/wpactl.c b/drivers/staging/vt6655/wpactl.c
index 4bdb836..fbae16d 100644
--- a/drivers/staging/vt6655/wpactl.c
+++ b/drivers/staging/vt6655/wpactl.c
@@ -987,8 +987,7 @@ int wpa_ioctl(PSDevice pDevice, struct iw_point *p)
 	}
 
 out:
-	if (param != NULL)
-		kfree(param);
+	kfree(param);
 
 	return ret;
 }
diff --git a/drivers/staging/vt6656/firmware.c b/drivers/staging/vt6656/firmware.c
index 1625412..8c8126a 100644
--- a/drivers/staging/vt6656/firmware.c
+++ b/drivers/staging/vt6656/firmware.c
@@ -109,8 +109,7 @@ FIRMWAREbDownload(
 	result = TRUE;
 
 out:
-	if (pBuffer)
-		kfree(pBuffer);
+	kfree(pBuffer);
 
 	spin_lock_irq(&pDevice->lock);
 	return result;
diff --git a/drivers/staging/vt6656/hostap.c b/drivers/staging/vt6656/hostap.c
index f70e922..51b5adf 100644
--- a/drivers/staging/vt6656/hostap.c
+++ b/drivers/staging/vt6656/hostap.c
@@ -858,8 +858,7 @@ int vt6656_hostap_ioctl(PSDevice pDevice, struct iw_point *p)
 	}
 
  out:
-	if (param != NULL)
-		kfree(param);
+	kfree(param);
 
 	return ret;
 }
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 56ce9be..61b6121 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -837,8 +837,7 @@ static void device_free_tx_bufs(PSDevice pDevice)
             usb_kill_urb(pTxContext->pUrb);
             usb_free_urb(pTxContext->pUrb);
         }
-        if (pTxContext)
-            kfree(pTxContext);
+        kfree(pTxContext);
     }
     return;
 }
@@ -861,8 +860,7 @@ static void device_free_rx_bufs(PSDevice pDevice)
         if (pRCB->skb)
             dev_kfree_skb(pRCB->skb);
     }
-    if (pDevice->pRCBMem)
-        kfree(pDevice->pRCBMem);
+    kfree(pDevice->pRCBMem);
 
     return;
 }
@@ -878,8 +876,7 @@ static void usb_device_reset(PSDevice pDevice)
 
 static void device_free_int_bufs(PSDevice pDevice)
 {
-    if (pDevice->intBuf.pDataBuf != NULL)
-        kfree(pDevice->intBuf.pDataBuf);
+    kfree(pDevice->intBuf.pDataBuf);
     return;
 }
 
@@ -1480,8 +1477,7 @@ error2:
   */
 
 if(result!=0) {
-    if(buffer)
-  	 kfree(buffer);
+    kfree(buffer);
     buffer=NULL;
 }
   return buffer;
diff --git a/drivers/staging/vt6656/wpactl.c b/drivers/staging/vt6656/wpactl.c
index 7fd300f..8752736 100644
--- a/drivers/staging/vt6656/wpactl.c
+++ b/drivers/staging/vt6656/wpactl.c
@@ -999,8 +999,7 @@ int wpa_ioctl(PSDevice pDevice, struct iw_point *p)
 	}
 
 out:
-	if (param != NULL)
-		kfree(param);
+	kfree(param);
 
 	return ret;
 }
diff --git a/drivers/staging/winbond/wb35reg.c b/drivers/staging/winbond/wb35reg.c
index 42ae610..da595f1 100644
--- a/drivers/staging/winbond/wb35reg.c
+++ b/drivers/staging/winbond/wb35reg.c
@@ -66,8 +66,7 @@ unsigned char Wb35Reg_BurstWrite(struct hw_data *pHwData, u16 RegisterNo, u32 *p
 	} else {
 		if (urb)
 			usb_free_urb(urb);
-		if (reg_queue)
-			kfree(reg_queue);
+		kfree(reg_queue);
 		return false;
 	}
    return false;
diff --git a/drivers/staging/wlan-ng/prism2fw.c b/drivers/staging/wlan-ng/prism2fw.c
index fd5ddb2..729d03d 100644
--- a/drivers/staging/wlan-ng/prism2fw.c
+++ b/drivers/staging/wlan-ng/prism2fw.c
@@ -443,8 +443,7 @@ void free_chunks(struct imgchunk *fchunk, unsigned int *nfchunks)
 {
 	int i;
 	for (i = 0; i < *nfchunks; i++) {
-		if (fchunk[i].data != NULL)
-			kfree(fchunk[i].data);
+		kfree(fchunk[i].data);
 	}
 	*nfchunks = 0;
 	memset(fchunk, 0, sizeof(*fchunk));
-- 
1.7.3.4

