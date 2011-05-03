Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab1ECQxD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 12:53:03 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45625 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911Ab1ECQxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 12:53:01 -0400
X-Greylist: delayed 357 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 May 2011 12:52:53 EDT
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 00/23] Intel SST driver update
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 03 May 2011 17:31:17 +0100
Message-ID: <20110503162919.24853.58699.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a forward port of various further Intel work on the SST driver in
staging. This keeps the staging driver up to date while the ALSA driver
development continues.

Alan



---

Andy CH Lin (1):
      intel_sst: intelmid_v2_control: correct jack event type

Chandramouli Narayanan (1):
      intel_sst: fix runtime pm issue

Dharageswari R (1):
      intel_sst: Line out support

Feng Tang (1):
      intel_sst: make sure the sst_drop_stream() get called when needed

Lu Guanqun (9):
      intel_sst: fix output noises when it's not in playback
      sst: internal speaker needs setting a GPIO line
      intel_sst: add Master Volume
      sst: set default output and input device
      sst: return correct output/input device id
      intel_sst: move jack detection related configs to init time
      intel_sst: Enable recording via DMIC
      intel_sst: Enable recording via HS_MIC
      intel_sst: Set de-bounce time

Ramesh Babu K V (1):
      intel_sst: rework jack implementation

Sitanshu Nanavati (1):
      intel_sst: DMIC routing

Vinod Koul (5):
      intel_sst: parameter tuning ioctl
      intel_sst: ignore IRQ when suspended
      intel_sst: fix unload bugs
      intel_sst: MSIC codec power optimisation
      intel_sst: Save audio state across D3 on Medfield

Wu Fengguang (2):
      intel_sst: MRST can only do 16bit recording
      intel_sst: MRST can only do mono recording

xingchao (1):
      intel_sst: Headphone Automute support


 drivers/staging/intel_sst/intel_sst.c              |  129 +++
 drivers/staging/intel_sst/intel_sst.h              |   33 +
 .../staging/intel_sst/intel_sst_app_interface.c    |   37 +
 drivers/staging/intel_sst/intel_sst_common.h       |    9 
 .../staging/intel_sst/intel_sst_drv_interface.c    |   23 -
 drivers/staging/intel_sst/intel_sst_dsp.c          |   14 
 drivers/staging/intel_sst/intel_sst_fw_ipc.h       |    7 
 drivers/staging/intel_sst/intel_sst_ioctl.h        |    8 
 drivers/staging/intel_sst/intel_sst_ipc.c          |   74 ++
 drivers/staging/intel_sst/intel_sst_stream.c       |   15 
 .../staging/intel_sst/intel_sst_stream_encoded.c   |    8 
 drivers/staging/intel_sst/intelmid.c               |  473 +++--------
 drivers/staging/intel_sst/intelmid.h               |   38 +
 drivers/staging/intel_sst/intelmid_adc_control.h   |  193 +++++
 drivers/staging/intel_sst/intelmid_ctrl.c          |  304 +++++++
 drivers/staging/intel_sst/intelmid_msic_control.c  |  833 ++++++++++++++++++--
 drivers/staging/intel_sst/intelmid_pvt.c           |    1 
 drivers/staging/intel_sst/intelmid_snd_control.h   |    9 
 drivers/staging/intel_sst/intelmid_v0_control.c    |  109 ++-
 drivers/staging/intel_sst/intelmid_v1_control.c    |  141 +++
 drivers/staging/intel_sst/intelmid_v2_control.c    |  219 ++++-
 drivers/staging/intel_sst/jack.h                   |   10 
 22 files changed, 2125 insertions(+), 562 deletions(-)
 create mode 100644 drivers/staging/intel_sst/intelmid_adc_control.h
 delete mode 100644 drivers/staging/intel_sst/jack.h

-- 
	"Policy is a poor man's substitute for common sense."
			-- David Woodhouse

