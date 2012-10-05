Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928Ab2JENnP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 09:43:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1829 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273Ab2JENnK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 09:43:10 -0400
Date: Fri, 5 Oct 2012 10:42:59 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for 3.7-rc1] media updates - part 1
Message-ID: <20121005104259.03c94150@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

For the first part of the media updates for Kernel 3.7.

This series contain:

	- A major tree renaming patch series: now, drivers are organized internally
	  by their used bus, instead of by V4L2 and/or DVB API, providing a cleaner
	  driver location for hybrid drivers that implement both APIs, and allowing to
	  cleanup the Kconfig items and make them more intuitive for the end user;

	- Media Kernel developers are typically very lazy with their duties of
	  keeping the MAINTAINERS entries for their drivers updated. As now the tree
	  is more organized, we're doing an effort to add/update those entries
	  for the drivers that aren't currently orphan;

	- Several DVB USB drivers got moved to a new DVB USB v2 core; the new core
	  fixes several bugs (as the existing one that got bitroted). Now, 
	  suspend/resume finally started to work fine (at least with some devices -
	  we should expect more work with regards to it);

	- added multistream support for DVB-T2, and unified the API for DVB-S2
	  and ISDB-S. Backward binary support is preserved;

	- as usual, a few new drivers, some V4L2 core improvements and lots of 
	  drivers improvements and fixes.

There are some points to notice on this series:

	1) you should expect a trivial merge conflict on your tree, with the removal
	   of Documentation/feature-removal-schedule.txt: this series would be adding
	   two additional entries there. I opted to not rebase it due to this recent
	   change;

	2) With regards to the PCTV 520e udev-related breakage, I opted to fix it
	   in a way that the patches can be backported to 3.5 even without your
	   firmware fix patch. This way, Greg doesn't need to rush backporting your
	   patch (as there are still the firmware cache and firmware path customization
	   issues to be addressed there). I'll send later a patch (likely after the end 
	   of the merge window) reverting the rest of the DRX-K async firmware request,
	   fully restoring its original behaviour to allow media drivers to initialize
	   everything serialized as before for 3.7 and upper.

	3) I'm planning to work on this weekend to test the DMABUF patches for V4L2.
	   The patches are on my queue for several Kernel cycles, but, up to now,
	   there is/was no way to test the series locally. I have some concerns about
	   this particular changeset with regards to security issues, and with regards
	   to the replacement of the old VIDIOC_OVERLAY ioctl's that is broken on
	   modern systems, due to GPU drivers change. The Overlay API allows direct
	   PCI2PCI transfers from a media capture card into the GPU framebuffer, but
	   its API is crappy. Also, the only existing X11 driver that implements it
	   requires a XV extension that is not available anymore on modern drivers.
	   The DMABUF can do the same thing, but with it is promising to be a
	   properly-designed API. If I can successfully test this series and
	   be happy with it, I should be asking you to pull them next week.

Thanks,
Mauro

-

The following changes since commit a0d271cbfed1dd50278c6b06bead3d00ba0a88f9:

  Linux 3.6 (2012-09-30 16:47:46 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

for you to fetch changes up to bd0d10498826ed150da5e4c45baf8b9c7088fb71:

  Merge branch 'staging/for_v3.7' into v4l_for_linus (2012-10-05 09:36:26 -0300)

----------------------------------------------------------------

Alan Cox (5):
      [media] mantis: fix silly crash case
      [media] tda8261: add printk levels
      [media] cx88: Fix reset delays
      [media] tlg2300: fix missing check for audio creation
      [media] v4l2: spi modalias is an array

Albert Wang (1):
      [media] media: soc_camera: don't clear pix->sizeimage in JPEG mode

Alex Gershgorin (2):
      [media] media: mx3_camera: buf_init() add buffer state check
      [media] mt9v022: Add support for mt9v024

Alexey Khoroshilov (1):
      [media] ddbridge: fix error handling in module_init_ddbridge()

Andrzej Hajda (2):
      [media] s5p-mfc: added support for end of stream handling in MFC encoder
      [media] s5p-mfc: optimized code related to working contextes

Andy Shevchenko (11):
      [media] saa7164: use native print_hex_dump() instead of custom one
      [media] dvb: nxt200x: apply levels to the printk()s
      [media] staging: lirc: use %*ph to print small buffers
      [media] common: tunners: use %*ph to dump small buffers
      [media] dvb: frontends: use %*ph to dump small buffers
      [media] radio-shark2: use %*ph to print small buffers
      [media] gspca: use %*ph to print small buffers
      [media] dvb: use %*ph to hexdump small buffers
      [media] ati_remote: use %*ph to dump small buffers
      [media] saa7127: use %*ph to print small buffers
      [media] dvb-usb: use %*ph to dump small buffers

Andy Walls (3):
      [media] ivtv, ivtv-alsa: Add initial ivtv-alsa interface driver for ivtv
      [media] ivtv-alsa, ivtv: Connect ivtv PCM capture stream to ivtv-alsa interface driver
      [media] ivtv-alsa: Remove EXPERIMENTAL from Kconfig and revise Kconfig help text

Anton Nurkin (2):
      [media] cx23885-cards: fix netup card default revision
      [media] cx23885: fix pointer to structure for CAM

Antti Palosaari (214):
      [media] dvb_usb_v2: copy current dvb_usb as a starting point
      [media] dvb_usb_v2: add .init() callback
      [media] dvb_usb_v2: remove one parameter from dvb_usbv2_device_init()
      [media] dvb_usb_v2: use .driver_info to pass struct dvb_usb_device_properties
      [media] dvb_usb_v2: remove owner parameter from dvb_usbv2_device_init()
      [media] dvb_usb_v2: remove adapter_nums parameter from dvb_usbv2_device_init()
      [media] dvb_usb_v2: pass (struct dvb_usb_device *) as a parameter for fw download
      [media] dvb_usb_v2: implement .get_firmware_name()
      [media] dvb_usb_v2: fix issues raised by checkpatch.pl
      [media] dvb_usb_v2: pass device name too using (struct usb_device_id)
      [media] dvb_usb_v2: implement .get_adapter_count()
      [media] dvb_usb_v2: implement .read_config()
      [media] dvb_usb_v2: remote controller
      [media] dvb_usb_v2: restore .firmware - pointer to name
      [media] dvb_usb_v2: init I2C and USB mutex earlier
      [media] dvb_usb_v2: remote controller changes
      [media] dvb_usb_v2: dynamic USB stream URB configuration
      [media] dvb_usb_v2: usb_urb.c use dynamic debugs
      [media] dvb_usb_v2: add .get_usb_stream_config()
      [media] dvb_usb_v2: move (struct usb_data_stream) to one level up
      [media] dvb_usb_v2: add .get_ts_config() callback
      [media] dvb_usb_v2: move (struct usb_data_stream_properties) to upper level
      [media] dvb_usb_v2: move PID filters from frontend to adapter
      [media] dvb_usb_v2: move 3 callbacks from the frontend to adapter
      [media] dvb_usb_v2: get rid of (struct dvb_usb_adapter_fe_properties)
      [media] dvb_usb_v2: remove .num_frontends
      [media] dvb_usb_v2: delay firmware download as it blocks module init
      [media] dvb_usb_v2: clean firmware downloading routines
      [media] dvb_usb_v2: add macro for filling usb_device_id table entry
      [media] dvb_usb_v2: use dynamic debugs
      [media] dvb_usb_v2: remove various unneeded variables
      [media] dvb_usb_v2: frontend switching changes
      [media] dvb_usb_v2: ensure driver_info is not null
      [media] dvb_usb_v2: refactor delayed init
      [media] dvb_usb_v2: remove usb_clear_halt()
      [media] dvb_usb_v2: unregister all frontends in error case
      [media] dvb_usb_v2: use Kernel logging (pr_debug/pr_err/pr_info)
      [media] dvb_usb_v2: move I2C adapter code to different file
      [media] dvb_usb_v2: rename device_init/device_exit to probe/disconnect
      [media] dvb_usb_v2: add .bInterfaceNumber match
      [media] dvb_usb_v2: add missing new line for log writings
      [media] dvb_usb_v2: fix dvb_usb_generic_rw() debug
      [media] dvb_usb_v2: do not free resources until delayed init is done
      [media] dvb_usb_v2: enable compile
      [media] af9015: switch to new DVB-USB
      [media] af9015: use USB core soft_unbind
      [media] dvb_usb_v2: I2C adapter cleanup changes
      [media] dvb_usb_v2: misc cleanup changes
      [media] dvb_usb_v2: probe/disconnect error handling
      [media] dvb_usb_v2: add .disconnect() callback
      [media] dvb_usb_v2: suspend/resume stop/start USB streaming
      [media] dvb_usb_v2: Cypress firmware download module
      [media] dvb_usb_v2: move few callbacks one level up
      [media] dvb_usb_v2: use keyword const for USB ID table
      [media] af9015: suspend/resume
      [media] dvb_usb_v2: use pointers to properties
      [media] ec168: convert to new DVB USB
      [media] ec168: switch Kernel pr_* logging
      [media] dvb_usb_v2: do not check active fe when stop streaming
      [media] ec168: re-implement firmware loading
      [media] au6610: convert to new DVB USB
      [media] dvb_usb_v2: move remote controller to the main file
      [media] ce6230: convert to new DVB USB
      [media] ce6230: various small changes
      [media] dvb_usb_v2: attach tuners later
      [media] anysee: convert to new DVB USB
      [media] dvb_usb_v2: do not release USB interface when device reconnects
      [media] dvb_usb_v2: try to remove all adapters on exit
      [media] dvb_usb_v2: simplify remote init/exit logic
      [media] dvb_usb_v2: get rid of dvb_usb_device state
      [media] dvb_usb_v2: move fe_ioctl_override() callback
      [media] dvb_usb_v2: remove num_frontends_initialized from dvb_usb_adapter
      [media] dvb_usb_v2: .read_mac_address() callback changes
      [media] dvb_usb_v2: add macros to fill USB stream properties
      [media] dvb_usb_v2: change USB stream config logic
      [media] af9015: update USB streaming configuration logic
      [media] dvb_usb_v2: helper macros for device/adapter/frontend pointers
      [media] af9015: use helper macros for some pointers
      [media] dvb_usb_v2: use lock to sync feed and frontend control
      [media] af9035: convert to new DVB USB
      [media] dvb_usb_v2: git rid of dvb_usb_adapter state variable
      [media] anysee: use DVB USB macros
      [media] au6610: use DVB USB macros
      [media] ce6230: use DVB USB macros
      [media] ec168: use DVB UDB macros
      [media] dvb_usb_v2: use container_of() for adapter to device
      [media] dvb_usb_v2: merge get_ts_config() to get_usb_stream_config()
      [media] dvb_usb_v2: use identify_state() to resolve firmware name
      [media] dvb_usb_v2: remove num_adapters_initialized variable
      [media] dvb_usb_v2: refactor dvb_usb_ctrl_feed() logic
      [media] dvb_usb_v2: merge files dvb_usb_init.c and dvb_usb_dvb.c
      [media] dvb_usb_v2: move dvb_usbv2_generic_rw() debugs behind define
      [media] dvb_usb_v2: multiple small tweaks around the code
      [media] dvb_usb_v2: refactor dvb_usbv2_generic_rw()
      [media] dvb_usb_v2: update header dvb_usb.h comments
      [media] dvb_usb_v2: remove unused variable
      [media] dvb_usb_v2: update copyrights
      [media] dvb_usb_v2: fix power_ctrl() callback error handling
      [media] dvb_usb_v2: change streaming control callback parameter
      [media] dvb_usb_v2: use dev_* logging macros
      [media] dvb_usb_v2: do not try to remove non-existent adapter
      [media] dvb_usb_v2: remove usb_clear_halt() from stream
      [media] dvb_usb_v2: register device even no remote keymap defined
      [media] mxl111sf: convert to new DVB USB
      [media] gl861: convert to new DVB USB
      [media] dvb_usb_v2: move from dvb-usb to dvb-usb-v2
      [media] af9015: remote controller fixes
      [media] dvb_usbv2: rename dvb_usb_firmware to cypress_firmware
      [media] m88rs2000: add missing FE_HAS_SYNC flag
      [media] tda18212: silence compiler warning
      [media] tda18212: use Kernel dev_* logging
      [media] tda18218: silence compiler warning
      [media] rtl28xxu: convert to new DVB USB
      [media] rtl28xxu: generalize streaming control
      [media] add DTMB support for DVB API
      [media] DVB API: add INTERLEAVING_AUTO
      [media] dvb_usb_v2: use %*ph to dump usb xfer debugs
      [media] anysee: fix compiler warning
      [media] anysee: convert Kernel dev_* logging
      [media] dvb_core: export function to perform retune
      [media] dvb_usb_v2: implement power-management for suspend
      [media] dvb_frontend: implement suspend / resume
      [media] dvb_usb_v2: .reset_resume() support
      [media] dvb_usb_v2: af9015, af9035, anysee use .reset_resume
      [media] dvb_usb_v2: ce6230, rtl28xxu use .reset_resume
      [media] dvb_frontend: use Kernel dev_* logging
      [media] dvb_frontend: return -ENOTTY for unimplement IOCTL
      [media] DocBook: update ioctl error codes
      [media] rtl2832: remove dummy callback implementations
      [media] dvb_usb_v2: use ratelimited debugs where appropriate
      [media] dvb-usb: remove unused files
      [media] qt1010: do not change frequency during init
      [media] gl861: reset_resume support
      [media] qt1010: convert for Kernel logging
      [media] qt1010: remove debug register dump
      [media] tda18218: re-implement tda18218_wr_regs()
      [media] tda18218: switch to Kernel logging
      [media] rtl28xxu: stream did not start after stop on USB3.0
      [media] rtl28xxu: fix rtl2832u module reload fails bug
      [media] rtl2832: implement .get_frontend()
      [media] rtl2832: implement .read_snr()
      [media] rtl2832: implement .read_ber()
      [media] au6610: define reset_resume
      [media] dvb_usb_v2: add debug macro dvb_usb_dbg_usb_control_msg
      [media] dvb_usb_v2: use dvb_usb_dbg_usb_control_msg()
      [media] rtl28xxu: correct usb_clear_halt() usage
      [media] Elonics E4000 silicon tuner driver
      [media] rtl28xxu: add support for Elonics E4000 tuner
      [media] mxl5005s: implement get_if_frequency()
      [media] af9013: add debug for IF frequency
      [media] mc44s803: implement get_if_frequency()
      [media] tuners: add FCI FC2580 silicon tuner driver
      [media] rtl28xxu: add support for FCI FC2580 silicon tuner driver
      [media] rtl28xxu: Dexatek DK DVB-T Dongle [1d19:1101]
      [media] rtl2832: separate tuner specific init from general
      [media] rtl2832: remove redundant function declaration
      [media] af9035: relax frontend callback error handling
      [media] tua9001: implement control pin callbacks
      [media] rtl28xxu: add support for tua9001 tuner based devices
      [media] rtl2832: support for tua9001 tuner
      [media] tua9001: use dev_foo logging
      [media] rtl2832: use dev_foo() logging
      [media] af9013: declare MODULE_FIRMWARE
      [media] af9015: declare MODULE_FIRMWARE
      [media] tda10071: declare MODULE_FIRMWARE
      [media] ec168: declare MODULE_FIRMWARE
      [media] af9033: use Kernel dev_foo() logging
      [media] af9013: use Kernel dev_foo() logging
      [media] ec100: use Kernel dev_foo() logging
      [media] ec100: improve I2C routines
      [media] hd29l2: use Kernel dev_foo() logging
      [media] rtl2830: use Kernel dev_foo() logging
      [media] rtl2830: use .get_if_frequency()
      [media] rtl2830: declare two tables as constant
      [media] af9015: use Kernel dev_foo() logging
      [media] af9015: improve af9015_eeprom_hash()
      [media] af9015: correct few error codes
      [media] af9035: use Kernel dev_foo() logging
      [media] au6610: use Kernel dev_foo() logging
      [media] gl861: use Kernel dev_foo() logging
      [media] ec168: use Kernel dev_foo() logging
      [media] ce6230: use Kernel dev_foo() logging
      [media] tua9001: enter full power save on attach
      [media] af9035: implement TUA9001 GPIOs correctly
      [media] af9033: sleep on attach
      [media] rtl28xxu: add ID [0bda:2832] Realtek RTL2832U reference design
      [media] dvb_frontend: do not allow statistic IOCTLs when sleeping
      [media] add LNA support for DVB API
      [media] DVB API: LNA documentation
      [media] cxd2820r: switch to Kernel dev_* logging
      [media] cxd2820r: use Kernel GPIO for GPIO access
      [media] dvb_usb_v2: rename module dvb_usbv2 => dvb_usb_v2
      [media] dvb_usb_v2: call streaming_ctrl() before kill urbs
      [media] af9035: declare MODULE_FIRMWARE
      [media] rtl28xxu: move rtl2832u tuner probing to .read_config()
      [media] rtl28xxu: masked reg write
      [media] rtl28xxu: do not return error for unimplemented fe callback
      [media] rtl28xxu: move rtl2831u tuner probing to .read_config()
      [media] rtl28xxu: remove fc0013 tuner fe callback
      [media] rtl2832: add configuration for e4000 tuner
      [media] rtl28xxu: use proper config for e4000 tuner
      [media] rtl28xxu: [0413:6680] DigitalNow Quad DVB-T Receiver
      [media] cypress_firmware: use Kernel dev_foo() logging
      [media] cypress_firmware: refactor firmware downloading
      [media] fc2580: small improvements for chip id check
      [media] dvb_usb_v2: fix error handling for .tuner_attach()
      [media] fc2580: fix crash when attach fails
      [media] e4000: fix crash when attach fails
      [media] anysee: do not remove CI when it is not attached
      [media] MAINTAINERS: add modules I am responsible
      [media] em28xx: implement FE set_lna() callback
      [media] cxd2820r: use static GPIO config when GPIOLIB is undefined
      [media] em28xx: do not set PCTV 290e LNA handler if fe attach fail
      [media] rtl28xxu: [0ccd:00d3] TerraTec Cinergy T Stick RC (Rev. 3)

Arnd Bergmann (2):
      [media] media/radio/shark2: Fix build error caused by missing dependencies
      [media] media/radio/shark2: Fix build error caused by missing dependencies

Axel Lin (1):
      gpio: bt8xx: Fix build error due to missing include file

Ben Hutchings (1):
      [media] rc: ite-cir: Initialise ite_dev::rdev earlier

Dan Carpenter (6):
      [media] qt1010: signedness bug in qt1010_init_meas1()
      [media] it913x-fe: use ARRAY_SIZE() as a cleanup
      [media] em28xx: use after free in em28xx_v4l2_close()
      [media] mem2mem_testdev: unlock and return error code properly
      [media] stk1160: unlock on error path stk1160_set_alternate()
      [media] stk1160: remove unneeded check

David Härdeman (3):
      [media] rc-core: move timeout and checks to lirc
      [media] winbond-cir: correctness fix
      [media] winbond-cir: asynchronous tx

Devendra Naga (3):
      [media] staging: media: cxd2099: fix sparse warnings in cxd2099_attach
      [media] staging: media: cxd2099: use kzalloc to allocate ci pointer of type struct cxd in cxd2099_attach
      [media] staging: media: cxd2099: remove memcpy of similar structure variables

Devin Heitmueller (24):
      [media] au8522: fix intermittent lockup of analog video decoder
      [media] au8522: Fix off-by-one in SNR table for QAM256
      [media] au8522: properly recover from the au8522 delivering misaligned TS streams
      [media] au0828: Make the s_reg and g_reg advanced debug calls work against the bridge
      [media] xc5000: properly show quality register values
      [media] xc5000: add support for showing the SNR and gain in the debug output
      [media] xc5000: properly report i2c write failures
      [media] au0828: fix race condition that causes xc5000 to not bind for digital
      [media] au0828: make sure video standard is setup in tuner-core
      [media] au8522: fix regression in logging introduced by separation of modules
      [media] xc5000: don't invoke auto calibration unless we really did reset tuner
      [media] au0828: prevent i2c gate from being kept open while in analog mode
      [media] au0828: fix case where STREAMOFF being called on stopped stream causes BUG()
      [media] au0828: speed up i2c clock when doing xc5000 firmware load
      [media] au0828: remove control buffer from send_control_msg
      [media] au0828: tune retry interval for i2c interaction
      [media] xc5000: reset device if encountering PLL lock failure
      [media] xc5000: add support for firmware load check and init status
      [media] au0828: tweak workaround for i2c clock stretching bug
      [media] xc5000: show debug version fields in decimal instead of hex
      [media] au0828: fix a couple of missed edge cases for i2c gate with analog
      [media] au0828: make xc5000 firmware speedup apply to the xc5000c as well
      [media] xc5000: change filename to production/redistributable xc5000c firmware
      [media] au0828: fix possible race condition in usage of dev->ctrlmsg

Djuri Baars (1):
      [media] Add support for the Terratec Cinergy T Dual PCIe IR remote

Emil Goode (3):
      [media] cx88: Remove duplicate const
      [media] media: coda: add const qualifiers
      [media] gspca: dubious one-bit signed bitfield

Evgeny Plehov (4):
      [media] ttpci: add support for Omicom S2 PCI
      [media] dvb_frontend: add multistream support
      [media] DocBook: Multistream support
      [media] stv090x: add support for multistream

Ezequiel Garcia (9):
      [media] pwc: Use vb2 queue mutex through a single name
      [media] pwc: Remove unneeded struct vb2_queue clearing
      [media] stk1160: Make kill/free urb debug message more verbose
      [media] stk1160: Handle urb allocation failure condition properly
      [media] stk1160: Fix s_fmt and try_fmt implementation
      [media] stk1160: Stop device and unqueue buffers when start_streaming() fails
      [media] vivi: Add return code check at vb2_queue_init()
      [media] videobuf2-core: Replace BUG_ON and return an error at vb2_queue_init()
      [media] MAINTAINERS: Add stk1160 driver

Ezequiel García (13):
      [media] em28xx: Remove useless runtime->private_data usage
      [media] media: Add stk1160 new driver (easycap replacement)
      [media] staging: media: Remove easycap driver
      [media] stk1160: Remove unneeded struct vb2_queue clearing
      [media] vivi: Remove unneeded struct vb2_queue clearing
      [media] mem2mem_testdev: Remove unneeded struct vb2_queue clear on queue_init()
      [media] coda: Remove unneeded struct vb2_queue clear on queue_init()
      [media] mem2mem-deinterlace: Remove unneeded struct vb2_queue clear on queue_init()
      [media] mem2mem-emmaprp: Remove unneeded struct vb2_queue clear on queue_init()
      [media] s5p-fimc: Remove unneeded struct vb2_queue clear on queue_init()
      [media] s5p-jpeg: Remove unneeded struct vb2_queue clear on queue_init()
      [media] s5p-g2d: Remove unneeded struct vb2_queue clear on queue_init()
      [media] stk1160: Remove unused 'ifnum' variable

Fabio Estevam (2):
      [media] video: mx1_camera: Use clk_prepare_enable/clk_disable_unprepare
      [media] video: mx2_camera: Use clk_prepare_enable/clk_disable_unprepare

Frank Schäfer (6):
      [media] gspca_pac7302: add support for device 1ae7:2001 Speedlink Snappy Microphone SL-6825-SBK
      [media] gspca_pac7302: make red balance and blue balance controls work again
      [media] gspca_pac7302: add sharpness control
      [media] gspca_pac7302: increase default value for white balance temperature
      [media] gspca_pac7302: avoid duplicate calls of the image quality adjustment functions on capturing start
      [media] gspca_pac7302: extend register documentation

Gianluca Gennari (3):
      [media] fc2580: define const as UL to silence a warning
      [media] fc2580: silence uninitialized variable warning
      [media] fc2580: use macro for 64 bit division and reminder

Guennadi Liakhovetski (2):
      [media] V4L: soc-camera: add selection API host operations
      [media] media: sh-vou: fix compilation breakage

Hans Petter Selasky (1):
      [media] tuner-xc2028: add missing else case

Hans Verkuil (95):
      [media] ivtv: remove V4L2_FL_LOCK_ALL_FOPS
      [media] saa7146: remove V4L2_FL_LOCK_ALL_FOPS
      [media] cpia2: remove V4L2_FL_LOCK_ALL_FOPS
      [media] usbvision: remove V4L2_FL_LOCK_ALL_FOPS
      [media] em28xx: remove V4L2_FL_LOCK_ALL_FOPS
      [media] tm6000: remove V4L2_FL_LOCK_ALL_FOPS
      [media] dt3155v4l: remove V4L2_FL_LOCK_ALL_FOPS
      [media] wl128x: remove V4L2_FL_LOCK_ALL_FOPS
      [media] fsl-viu: remove V4L2_FL_LOCK_ALL_FOPS
      [media] s2255drv: remove V4L2_FL_LOCK_ALL_FOPS
      [media] vpbe_display: remove V4L2_FL_LOCK_ALL_FOPS
      [media] mx2_emmaprp: remove V4L2_FL_LOCK_ALL_FOPS
      [media] sh_vou: remove V4L2_FL_LOCK_ALL_FOPS
      [media] bfin_capture: remove V4L2_FL_LOCK_ALL_FOPS
      [media] cx231xx: remove V4L2_FL_LOCK_ALL_FOPS
      [media] soc_camera: remove V4L2_FL_LOCK_ALL_FOPS
      [media] s5p-jpeg: remove V4L2_FL_LOCK_ALL_FOPS
      [media] s5p-g2d: remove V4L2_FL_LOCK_ALL_FOPS
      [media] s5p-tv: remove V4L2_FL_LOCK_ALL_FOPS
      [media] s5p-mfc: remove V4L2_FL_LOCK_ALL_FOPS
      [media] vpif_display: remove V4L2_FL_LOCK_ALL_FOPS
      [media] vpif_capture: remove V4L2_FL_LOCK_ALL_FOPS
      [media] mem2mem_testdev: remove V4L2_FL_LOCK_ALL_FOPS
      [media] v4l2-dev: remove V4L2_FL_LOCK_ALL_FOPS
      [media] vivi: fix colorspace setup
      [media] vivi: add frame size reporting
      [media] vivi: zero fmt.pix.priv as per spec
      [media] Remove documentation chunk of non-existent V4L2_CID_AUTO_FOCUS_AREA
      [media] DocBook: various version/copyright year updates
      [media] DocBook: fix incorrect or missing links
      [media] DocBook: add missing AUDIO_* ioctls
      [media] DocBook: add missing DVB video ioctls
      [media] DocBook: add stubs for the undocumented DVB net ioctls
      [media] DocBook: add stubs for missing DVB DMX ioctls
      [media] DocBook: add stubs for missing DVB CA ioctls
      [media] DocBook: update RDS references to the latest RDS standards
      [media] DocBook validation fixes
      [media] Fix vino compilation
      [media] v4l2 core: add the missing pieces to support DVI/HDMI/DisplayPort
      [media] V4L2 spec: document the new DV controls and ioctls
      [media] v4l2-subdev: add support for the new edid ioctls
      [media] v4l2-ctrls.c: add support for the new DV controls
      [media] v4l2-common: add v4l_match_dv_timings
      [media] v4l2-common: add CVT and GTF detection functions
      [media] adv7604: driver for the Analog Devices ADV7604 video decoder
      [media] ad9389b: driver for the Analog Devices AD9389B video encoder
      [media] v4l2-ioctl.c: fix overlay support
      [media] [TRIVIAL] ivtv-alsa-pcm: remove unnecessary printk.h include
      [media] videodev2.h: split off controls into v4l2-controls.h
      [media] DocBook: improve STREAMON/OFF documentation
      [media] DocBook: make the G/S/TRY_FMT specification more strict
      [media] DocBook: bus_info can no longer be empty
      [media] vivi/mem2mem_testdev: update to latest bus_info specification
      [media] v4l2-core: deprecate V4L2_BUF_TYPE_PRIVATE
      [media] cx18/ivtv: Remove usage of V4L2_BUF_TYPE_PRIVATE
      [media] DocBook: deprecate V4L2_BUF_TYPE_PRIVATE
      [media] v4l2: remove experimental tag from a number of old drivers
      [media] DocBook: document when to return ENODATA
      [media] v4l2-core: tvnorms may be 0 for a given input, handle that case
      [media] Rename V4L2_(IN|OUT)_CAP_CUSTOM_TIMINGS
      [media] Feature removal: Remove CUSTOM_TIMINGS defines in 3.9
      [media] DocBook: fix awkward language and fix the documented return value
      [media] DocBook: clarify that sequence is also set for output devices
      [media] DocBook: Mark CROPCAP as optional instead of as compulsory
      [media] v4l2: make vidioc_s_fbuf const
      [media] v4l2: make vidioc_s_jpegcomp const
      [media] v4l2: make vidioc_s_freq_hw_seek const
      [media] v4l2: make vidioc_(un)subscribe_event const
      [media] v4l2: make vidioc_s_audio const
      [media] v4l2: make vidioc_s_audout const
      [media] v4l2: make vidioc_s_modulator const
      [media] v4l2: make vidioc_s_crop const
      [media] v4l2-dev: add new VFL_DIR_ defines
      [media] Set vfl_dir for all display or m2m drivers
      [media] v4l2-dev: improve ioctl validity checks
      [media] v4l2-dev: reorder checks into blocks of ioctls with similar properties
      [media] Add vfl_dir field documentation
      [media] vb2: fix wrong owner check
      [media] vpif: replace preset with the timings API
      [media] davinci: vpif: remove unwanted header file inclusion
      [media] Docbook: add missing vidioc-subdev-g-edid.xml
      [media] DocBook: EAGAIN == EWOULDBLOCK
      [media] DocBook: in non-blocking mode return EAGAIN in hwseek
      [media] radio drivers: in non-blocking mode return EAGAIN in hwseek
      [media] tvaudio: add back lost tda9875 copyright
      [media] v4l2-ioctl.c: fix overlay support
      [media] v4l2-ctrls: add a filter function to v4l2_ctrl_add_handler
      [media] sliced vbi: subdevs shouldn't clear the full v4l2_sliced_vbi_format struct
      [media] ivtv: DECODER_CMD v4l2-compliance fixes
      [media] ivtv: fix v4l2-compliance error: inconsistent std reporting
      [media] ivtv: fix v4l2-compliance errors for the radio device
      [media] ivtv: don't allow g/s_frequency for output device nodes
      [media] ivtv: fix incorrect service_set for the decoder VBI capture
      [media] ivtv: disable a bunch of ioctls that are invalid for the decoder VBI
      [media] ivtv: fix format enumeration: don't show invalid formats

Hans de Goede (10):
      [media] media-api-docs: Documented V4L2_TUNER_CAP_HWSEEK_PROG_LIM in G_TUNER docs
      [media] snd_tea575x: Add support for tuning AM
      [media] radio-tea5777.c: Get rid of do_div usage
      [media] radio-tea5777: Add support for tuning AM
      [media] radio-shark2: Add support for suspend & resume
      [media] radio-shark: Add support for suspend & resume
      [media] gspca: Don't set gspca_dev->dev to NULL before stop0
      [media] gspca_finepix: Remove unnecessary lock/unlock call
      [media] gspca: Update / fix various comments wrt workqueue usb_lock usage
      [media] gspca: Fix input urb creation / destruction surrounding suspend resume

Igor M. Liplianin (1):
      [media] mantis: Terratec Cinergy C PCI HD (CI)

Ivaylo Petrov (1):
      [media] omap3isp: csi2: Add V4L2_MBUS_FMT_YUYV8_2X8 support

Javier Martin (10):
      [media] i.MX: coda: Add platform support for coda in i.MX27
      [media] media: coda: Add driver for Coda video codec
      [media] Visstrim M10: Add support for Coda
      [media] media: Add mem2mem deinterlacing driver
      [media] i.MX27: Visstrim_M10: Add support for deinterlacing driver
      [media] media: i.MX27: Fix mx2_emmaprp mem2mem driver clocks
      [media] media: mx2_camera: Mark i.MX25 support as BROKEN
      [media] Schedule removal of i.MX25 support in mx2_camera.c
      [media] media: mx2_camera: Add YUYV output format
      [media] media: mx2_camera: Fix clock handling for i.MX27

Jean Delvare (2):
      [media] mceusb: Optimize DIV_ROUND_CLOSEST call
      [media] cx23885: Select drivers for Terratec Cinergy T PCIe Dual

Jiri Slaby (1):
      [media] DVB: dib0700, remove double \n's from log

Jose Alberto Reguero (1):
      [media] ttusb2: add toggle to the tt3650_rc_query function

Julia Lawall (8):
      [media] drivers/media/radio/radio-timb.c: use devm_ functions
      [media] drivers/media/radio/radio-wl1273.c: use devm_ functions
      [media] drivers/media/radio/radio-si4713.c: use devm_ functions
      [media] drivers/media/platform/mx2_emmaprp.c: use devm_kzalloc and devm_clk_get
      [media] drivers/media/usb/{s2255drv.c, tm6000/tm6000-alsa.c, tm6000/tm6000-input.c}: Remove potential NULL dereferences
      [media] m5mols: introduce missing initialization
      [media] mt9m032.c: introduce missing initialization
      [media] drivers/media/platform/mx2_emmaprp.c: adjust inconsistent IS_ERR and PTR_ERR

Kamil Debski (2):
      [media] s5p-mfc: Fix second memory bank alignment
      [media] s5p-mfc: Fix second memory bank alignment

Lad, Prabhakar (4):
      [media] davinci: fix build warning when CONFIG_DEBUG_SECTION_MISMATCH is enabled
      [media] media: davinci: fix section mismatch warnings
      [media] v4l: Documentation: change path of video drivers
      [media] davinci: vpif: capture/display: fix race condition

Laurent Pinchart (33):
      [media] omap3isp: Don't access ISP_CTRL directly in the statistics modules
      [media] omap3isp: Configure HS/VS interrupt source before enabling interrupts
      [media] omap3isp: preview: Remove lens shading compensation support
      [media] omap3isp: preview: Pass a prev_params pointer to configuration functions
      [media] omap3isp: preview: Reorder configuration functions
      [media] omap3isp: preview: Merge gamma correction and gamma bypass
      [media] omap3isp: preview: Add support for non-GRBG Bayer patterns
      [media] omap3isp: video: Split format info bpp field into width and bpp
      [media] omap3isp: video: Add YUYV8_2X8 and UYVY8_2X8 support
      [media] omap3isp: ccdc: Remove support for interlaced data and master HS/VS mode
      [media] omap3isp: ccdc: Remove ispccdc_syncif structure
      [media] omap3isp: ccdc: Add YUV input formats support
      [media] omap3isp: Mark the resizer output video node as the default video node
      [media] uvcvideo: Support super speed endpoints
      [media] uvcvideo: Add support for Ophir Optronics SPCAM 620U cameras
      [media] soc_camera: Don't call .s_power() during probe
      [media] soc-camera: Continue the power off sequence if one of the steps fails
      [media] soc-camera: Add and use soc_camera_power_[on|off]() helper functions
      [media] soc-camera: Push probe-time power management to drivers
      [media] ov772x: Fix memory leak in probe error path
      [media] ov772x: Select the default format at probe time
      [media] ov772x: Don't fail in s_fmt if the requested format isn't supported
      [media] ov772x: try_fmt must not default to the current format
      [media] ov772x: Make to_ov772x convert from v4l2_subdev to ov772x_priv
      [media] ov772x: Add ov772x_read() and ov772x_write() functions
      [media] ov772x: Add support for SBGGR10 format
      [media] ov772x: Compute window size registers at runtime
      [media] ov772x: Stop sensor readout right after reset
      [media] v4l2-ctrls: Add v4l2_ctrl_[gs]_ctrl_int64()
      [media] mt9v032: Provide link frequency control
      [media] mt9v032: Export horizontal and vertical blanking as V4L2 controls
      [media] mt9p031: Fix horizontal and vertical blanking configuration
      [media] uvcvideo: Remove outdated comment

Liu Ying (1):
      [media] media: mx3_camera: Improve data bus width check code for probe

Malcolm Priestley (5):
      [media] dvb_usb_v2: return the download ret in dvb_usb_download_firmware
      [media] dvb_usb_lmedm04: don't crash if firmware is not loaded
      [media] lmedm04 2.06 conversion to dvb-usb-v2 version 2
      [media] lmedm04: fix data usage past the end of the buffer
      [media] it913x ver 1.32 driver moved to dvb-usb-v2

Manoel Pinheiro (1):
      [media] saa7134-dvb: Fix kworld sbtvd I2C gate control

Mariusz Bia?o?czyk (1):
      [media] Add support for Prof Revolution DVB-S2 8000 PCI-E card

Mauro Carvalho Chehab (76):
      [media] radio-tea5777: use library for 64bits div
      Merge tag 'v3.6-rc1' into staging/for_v3.6
      [media] move dvb-usb-ids.h to dvb-core
      [media] m2m-deinterlace: fix two warnings
      [media] dvb-usb-v2: Fix cypress firmware compilation
      [media] dvb-usb-v2: Don't ask user to select Cypress firmware module
      [media] az6007: convert it to use dvb-usb-v2
      [media] az6007: fix the I2C W+R logic
      [media] az6007: Fix the number of parameters for QAM setup
      [media] az6007: rename "st" to "state" at az6007_power_ctrl()
      [media] az6007: make all functions static
      [media] az6007: handle CI during suspend/resume
      [media] az6007: Update copyright
      [media] em28xx: Fix height setting on non-progressive captures
      [media] dvb core: remove support for post FE legacy ioctl intercept
      [media] lmedm04: fix build
      [media] dvb: get rid of fe_ioctl_override callback
      [media] frontend.h, Docbook: Improve status documentation
      [media] rc/Kconfig: Fix a warning
      [media] v4l: move v4l2 core into a separate directory
      [media] dvb: move the dvb core one level up
      [media] move the dvb/frontends to drivers/media/dvb-frontends
      [media] firewire: move it one level up
      [media] dvb-usb: move it to drivers/media/usb/dvb-usb
      [media] Rename media/dvb as media/pci
      [media] b2c2: break it into common/pci/usb directories
      [media] common: move media/common/tuners to media/tuners
      [media] saa7146: Move it to its own directory
      [media] siano: break it into common, mmc and usb
      [media] b2c2: frontends/tuners are not needed at the bridge binding
      ioctl-number.txt: Remove legacy private ioctl's from media drivers
      [media] b2c2: fix driver's build due to the lack of pci DMA code
      [media] rename most media/video usb drivers to media/usb
      [media] move the remaining USB drivers to drivers/media/usb
      [media] bt8xx: move analog TV part to be together with DTV one
      [media] rename most media/video pci drivers to media/pci
      [media] move analog PCI saa7146 drivers to its own dir
      [media] move the remaining PCI devices to drivers/media/pci
      [media] move parallel port/isa video drivers to drivers/media/parport/
      [media] mmc/Kconfig: Improve driver name for siano mmc/sdio driver
      [media] reorganize the API core items
      [media] move i2c files into drivers/media/i2c
      [media] move soc_camera i2c drivers into its own dir
      [media] rename drivers/media/video as .../platform
      [media] Fix some Makefile rules
      [media] b2c2: export b2c2_flexcop_debug symbol
      sh_mobile_csi2: move it to the right place
      [media] move soc_camera to its own directory
      [media] Kconfig reorganization
      [media] Put the test devices together
      [media] Cleanup media Kconfig files
      [media] Kconfig: use menuconfig instead of menu
      [media] Kconfig: merge all customise options into just one
      [media] flexcop: Show the item to enable debug after the driver
      [media] Add missing help for some menuconfig items
      [media] Kconfig: Fix b2c2 common code selection
      [media] saa7164: Add dependency for V4L2 core
      Makefile: Add missing soc_camera/ directory
      Merge tag 'v3.6-rc3' into staging/for_v3.7
      [media] move i2c files into drivers/media/i2c
      [media] au0828, cx231xx: remove dependency for DVB_CAPTURE_DRIVERS
      [media] DocBook: Fix docbook compilation
      [media] shark,shark2: declare resume/suspend functions as static
      Merge tag 'v3.6-rc5' into staging/for_v3.7
      [media] gscaler: mark it as BROKEN
      Revert "[media] gscaler: mark it as BROKEN"
      MAINTAINERS: Remove entries for drivers that got removed
      MAINTAINERS: fix the path for the media drivers that got renamed
      [media] pd-alsa: fix compilation breakage by commit da35de640
      get_dvb_firmware: fix download site for tda10046 firmware
      tda1004x: Lock I2C bus during firmware load
      Merge tag 'v3.6' into staging/for_v3.7
      em28xx: Make all em28xx extensions to be initialized asynchronously
      drxk: allow loading firmware synchrousnously
      em28xx: regression fix: use DRX-K sync firmware requests on em28xx
      Merge branch 'staging/for_v3.7' into v4l_for_linus

Michael Jones (3):
      [media] omap3isp: #include videodev2.h in omap3isp.h
      [media] omap3isp: queue: Fix omap3isp_video_queue_dqbuf() description comment
      [media] v4l2: typos

Michael Krufky (13):
      [media] DVB: improve handling of TS packets containing a raised TEI bit
      [media] tda18271: enter low-power standby mode at the end of tda18271_attach()
      [media] tda18271: make 'low-power standby mode after attach' multi-instance safe
      [media] MAINTAINERS: add Michael Krufky as tda18271 maintainer
      [media] MAINTAINERS: add Michael Krufky as mxl5007t maintainer
      [media] MAINTAINERS: add Michael Krufky as mxl111sf maintainer
      [media] MAINTAINERS: add Michael Krufky as lgdt3305 maintainer
      [media] MAINTAINERS: add Michael Krufky as lg2160 maintainer
      [media] MAINTAINERS: add Michael Krufky as cxusb maintainer
      [media] MAINTAINERS: add Michael Krufky as tda8290 maintainer
      [media] MAINTAINERS: add Michael Krufky as tda827x maintainer
      [media] tda18271: delay IR & RF calibration until init() if delay_cal is set
      [media] tda18271: properly report read errors in tda18271_get_id

Nicolas THERY (2):
      [media] videobuf2: fix sparse warning
      [media] media: fix MEDIA_IOC_DEVICE_INFO return code

Oliver Schinagl (1):
      [media] Support for Asus MyCinema U3100Mini Plus

Patrice Chotard (2):
      [media] dvb: add support for Thomson DTT7520X
      [media] ngene: add support for Terratec Cynergy 2400i Dual DVB-T

Peter Meerwald (1):
      [media] omap3isp: ccdc: No semicolon is needed after switch statement

Peter Senna Tschudin (10):
      [media] drivers/media/usb/gspca/cpia1.c: fix error return code
      [media] drivers/media/rc/redrat3.c: fix error return code
      [media] drivers/media/rc/ati_remote.c: fix error return code
      [media] drivers/media/platform/davinci/vpfe_capture.c: fix error return code
      [media] drivers/media/platform/blackfin/bfin_capture.c: fix error return code
      [media] drivers/media/dvb-core/dvb_demux.c: removes unnecessary semicolon
      [media] drivers/media/tuners/tda18271-common.c: removes unnecessary semicolon
      [media] drivers/media/i2c/tea6415c.c: removes unnecessary semicolon
      [media] drivers/media/dvb-frontends/tda10071.c: removes unnecessary semicolon
      [media] omap3isp: Fix error return code in probe function

Philipp Dreimann (1):
      [media] Add the usb id of the Trekstor DVB-T Stick Terres 2.0

Philipp Zabel (13):
      [media] media: coda: firmware loading for 64-bit AXI bus width
      [media] media: coda: add i.MX53 / CODA7541 platform support
      [media] media: coda: fix IRAM/AXI handling for i.MX53
      [media] media: coda: allocate internal framebuffers separately from v4l2 buffers
      [media] media: coda: ignore coda busy status in coda_job_ready
      [media] media: coda: keep track of active instances
      [media] media: coda: stop all queues in case of lockup
      [media] media: coda: enable user pointer support
      [media] media: coda: wait for picture run completion in start/stop_streaming
      [media] media: coda: fix sizeimage setting in try_fmt
      [media] media: coda: add horizontal / vertical flipping support
      [media] media: coda: add byte size slice limit control
      [media] media: coda: set up buffers to be sized as negotiated with s_fmt

Reinhard Nissl (1):
      [media] stb0899: return internally tuned frequency via get_frontend.

Richard Zhao (1):
      [media] media: coda: remove duplicated call of fh_to_ctx in vidioc_s_fmt_vid_out

Sachin Kamat (18):
      [media] s5k6aa: Add missing static storage class specifier
      [media] s5k6aa: Use devm_kzalloc function
      [media] s5p-tv: Use devm_regulator_get() in sdo_drv.c file
      [media] s5p-tv: Replace printk with pr_* functions
      [media] s5p-tv: Use devm_* functions in sii9234_drv.c file
      [media] mem2mem_testdev: Make m2mtest_dev_release function static
      [media] smiapp: Use devm_* functions in smiapp-core.c file
      [media] smiapp: Remove unused function
      [media] media-devnode: Replace printk with pr_*
      [media] s5p-jpeg: Add missing braces around sizeof
      [media] s5p-fimc: Replace asm/* headers with linux/*
      [media] s5p-fimc: Add missing braces around sizeof
      [media] s5p-mfc: Add missing braces around sizeof
      [media] s5p-tv: Fix potential NULL pointer dereference error
      [media] s5p-fimc: Fix incorrect condition in fimc_lite_reqbufs()
      [media] exynos-gsc: Remove <linux/version.h> header file inclusion
      [media] exynos-gsc: Add missing static storage class specifiers
      [media] s5p-mfc: Fix misplaced return statement in s5p_mfc_suspend()

Sakari Ailus (5):
      [media] v4l: Add missing compatibility definitions for bounds rectangles
      [media] mt9v032: Provide pixel rate control
      [media] v4l: Remove experimental tag from certain API elements
      [media] smiapp: Use highest bits-per-pixel for sensor internal format
      [media] smiapp: Provide module identification information through sysfs

Sangwook Lee (1):
      [media] Add v4l2 subdev driver for S5K4ECGX sensor

Sascha Hauer (2):
      [media] media v4l2-mem2mem: fix src/out and dst/cap num_rdy
      [media] media v4l2-mem2mem: Use list_first_entry

Sean Young (18):
      [media] nec-decoder: fix NEC decoding for Pioneer Laserdisc CU-700 remote
      [media] iguanair: reuse existing urb callback for command responses
      [media] iguanair: ignore unsupported firmware versions
      [media] iguanair: support suspend and resume
      [media] iguanair: fix return value for transmit
      [media] iguanair: reset the IR state after rx overflow or receiver enable
      [media] iguanair: advertise the resolution and timeout properly
      [media] iguanair: fix receiver overflow
      [media] rc: Add support for the TechnoTrend USB IR Receiver
      [media] rc: do not wake up rc thread unless there is something to do
      [media] saa7134: simplify timer activation
      [media] rc: transmit on device which does not support it should fail
      [media] lirc: remove lirc_ttusbir driver
      [media] lirc: lirc_ene0100.h is not referenced anywhere
      [media] rc: fix buffer overrun
      [media] ttusbir: Add USB dependency
      [media] iguanair: do not modify transmit buffer
      [media] ttusbir: ad support suspend and resume

Shaik Ameer Basha (2):
      [media] v4l: Add new YVU420 multi planar fourcc definition
      [media] gscaler: Add Makefile for G-Scaler Driver

Shawn Guo (2):
      [media] media: mx2_camera: remove dead code in mx2_camera_add_device
      [media] media: mx2_camera: use managed functions to clean up code

Shubhrajyoti D (6):
      [media] ks0127: convert struct i2c_msg initialization to C99 format
      [media] tvaudio: convert struct i2c_msg initialization to C99 format
      [media] radio-tea5764: convert struct i2c_msg initialization to C99 format
      [media] msp3400: convert struct i2c_msg initialization to C99 format
      [media] saa7706h: convert struct i2c_msg initialization to C99 format
      [media] radio-si470x: convert struct i2c_msg initialization to C99 format

Stefan Muenzel (1):
      [media] uvcvideo: Support 10bit, 12bit and alternate 8bit greyscale formats

Sungchun Kang (3):
      [media] gscaler: Add new driver for generic scaler
      [media] gscaler: Add core functionality for the G-Scaler driver
      [media] gscaler: Add m2m functionality for the G-Scaler driver

Sylwester Nawrocki (26):
      [media] s5p-fimc: Enable FIMC-LITE driver only for SOC_EXYNOS4x12
      [media] s5p-fimc: Don't allocate fimc-lite video device structure dynamically
      [media] s5p-fimc: Don't allocate fimc-capture video device dynamically
      [media] s5p-fimc: Don't allocate fimc-m2m video device dynamically
      [media] m5mols: Add missing free_irq() on error path
      [media] m5mols: Fix cast warnings from m5mols_[set/get]_ctrl_mode
      [media] s5p-fimc: Fix setup of initial links to FIMC entities
      [media] exynos-gsc: Add missing Makefile
      [media] coda: Add V4L2_CAP_VIDEO_M2M capability flag
      [media] m2m-deinterlace: Add V4L2_CAP_VIDEO_M2M capability flag
      [media] s5p-fimc: Enable FIMC-LITE driver only for SOC_EXYNOS4x12
      [media] s5p-fimc: Don't allocate fimc-lite video device structure dynamically
      [media] s5p-fimc: Don't allocate fimc-capture video device dynamically
      [media] s5p-fimc: Don't allocate fimc-m2m video device dynamically
      [media] m5mols: Add missing free_irq() on error path
      [media] m5mols: Fix cast warnings from m5mols_[set/get]_ctrl_mode
      [media] s5p-fimc: Fix setup of initial links to FIMC entities
      [media] s5p-fimc: fimc-lite: Correct Bayer pixel format definitions
      [media] s5p-fimc: fimc-lite: Propagate frame format on the subdev
      [media] s5p-fimc: Add pipeline ops to separate FIMC-LITE module
      [media] s5p-csis: Add transmission errors logging
      [media] s5p-fimc: Keep local copy of sensors platform data
      [media] m5mols: Remove unneeded control ops assignments
      [media] m5mols: Protect driver data with a mutex
      [media] s5k6aa: Fix possible NULL pointer dereference
      [media] s5p-tv: Report only multi-plane capabilities in vidioc_querycap

Tim Gardner (7):
      [media] cx25840: Declare MODULE_FIRMWARE usage
      [media] ivtv: Declare MODULE_FIRMWARE usage
      [media] cx231xx: Declare MODULE_FIRMWARE usage
      [media] cx23885: Declare MODULE_FIRMWARE usage
      [media] pvrusb2: Declare MODULE_FIRMWARE usage
      [media] cx18: Declare MODULE_FIRMWARE usage
      [media] cpia2: Declare MODULE_FIRMWARE usage

Timo Kokkonen (4):
      [media] media: rc: Introduce RX51 IR transmitter driver
      [media] ARM: mach-omap2: board-rx51-peripherals: Add lirc-rx51 data
      [media] ir-rx51: Trivial fixes
      [media] ir-rx51: Adjust dependencies

Wanlong Gao (2):
      [media] media:dvb:fix up ENOIOCTLCMD error handling
      [media] omap3isp: Fix up ENOIOCTLCMD error handling

 Documentation/DocBook/media/Makefile               |    2 +-
 Documentation/DocBook/media/dvb/audio.xml          |  113 +-
 Documentation/DocBook/media/dvb/ca.xml             |  353 ++
 Documentation/DocBook/media/dvb/demux.xml          |  230 +-
 Documentation/DocBook/media/dvb/dvbapi.xml         |    4 +-
 Documentation/DocBook/media/dvb/dvbproperty.xml    |  113 +-
 Documentation/DocBook/media/dvb/frontend.xml       |   71 +-
 Documentation/DocBook/media/dvb/intro.xml          |    2 +-
 Documentation/DocBook/media/dvb/kdapi.xml          |    2 +-
 Documentation/DocBook/media/dvb/net.xml            |  127 +
 Documentation/DocBook/media/dvb/video.xml          |  333 +-
 Documentation/DocBook/media/v4l/biblio.xml         |   52 +-
 Documentation/DocBook/media/v4l/common.xml         |   30 +-
 Documentation/DocBook/media/v4l/compat.xml         |   41 +-
 Documentation/DocBook/media/v4l/controls.xml       |  614 +--
 Documentation/DocBook/media/v4l/dev-osd.xml        |    7 -
 Documentation/DocBook/media/v4l/dev-rds.xml        |    2 +-
 Documentation/DocBook/media/v4l/dev-subdev.xml     |   20 +-
 Documentation/DocBook/media/v4l/gen-errors.xml     |   19 +-
 Documentation/DocBook/media/v4l/io.xml             |   21 +-
 .../DocBook/media/v4l/pixfmt-srggb10dpcm8.xml      |    3 +-
 Documentation/DocBook/media/v4l/pixfmt-yvu420m.xml |  154 +
 Documentation/DocBook/media/v4l/pixfmt.xml         |    1 +
 Documentation/DocBook/media/v4l/selection-api.xml  |   22 +-
 Documentation/DocBook/media/v4l/v4l2.xml           |   15 +-
 Documentation/DocBook/media/v4l/vidioc-cropcap.xml |   12 +-
 .../DocBook/media/v4l/vidioc-decoder-cmd.xml       |    7 -
 .../DocBook/media/v4l/vidioc-encoder-cmd.xml       |    7 -
 .../DocBook/media/v4l/vidioc-enum-dv-presets.xml   |    6 +
 .../DocBook/media/v4l/vidioc-enum-dv-timings.xml   |    6 +
 .../DocBook/media/v4l/vidioc-enum-fmt.xml          |    9 +-
 .../DocBook/media/v4l/vidioc-enum-framesizes.xml   |    7 -
 .../DocBook/media/v4l/vidioc-enuminput.xml         |    2 +-
 .../DocBook/media/v4l/vidioc-enumoutput.xml        |    2 +-
 Documentation/DocBook/media/v4l/vidioc-enumstd.xml |    6 +
 Documentation/DocBook/media/v4l/vidioc-g-crop.xml  |    6 +-
 .../DocBook/media/v4l/vidioc-g-dv-preset.xml       |    9 +-
 .../DocBook/media/v4l/vidioc-g-dv-timings.xml      |   13 +-
 .../DocBook/media/v4l/vidioc-g-enc-index.xml       |    7 -
 Documentation/DocBook/media/v4l/vidioc-g-fmt.xml   |   13 +-
 Documentation/DocBook/media/v4l/vidioc-g-parm.xml  |    4 +-
 .../DocBook/media/v4l/vidioc-g-selection.xml       |    9 +-
 Documentation/DocBook/media/v4l/vidioc-g-std.xml   |   10 +-
 Documentation/DocBook/media/v4l/vidioc-g-tuner.xml |    6 +
 Documentation/DocBook/media/v4l/vidioc-qbuf.xml    |    2 +
 .../DocBook/media/v4l/vidioc-query-dv-preset.xml   |    9 +
 .../DocBook/media/v4l/vidioc-query-dv-timings.xml  |    6 +
 .../DocBook/media/v4l/vidioc-querycap.xml          |   10 +-
 .../DocBook/media/v4l/vidioc-querystd.xml          |    8 +
 Documentation/DocBook/media/v4l/vidioc-reqbufs.xml |    5 +-
 .../DocBook/media/v4l/vidioc-s-hw-freq-seek.xml    |   10 +
 .../DocBook/media/v4l/vidioc-streamon.xml          |    7 +-
 .../DocBook/media/v4l/vidioc-subdev-g-edid.xml     |  152 +
 .../media/v4l/vidioc-subdev-g-selection.xml        |    8 +-
 Documentation/DocBook/media_api.tmpl               |    9 +-
 Documentation/dvb/README.dvb-usb                   |    2 +-
 Documentation/dvb/get_dvb_firmware                 |    2 +-
 Documentation/feature-removal-schedule.txt         |   18 +
 Documentation/ioctl/ioctl-number.txt               |    5 -
 Documentation/video4linux/CARDLIST.cx23885         |    1 +
 Documentation/video4linux/CQcam.txt                |    2 +-
 Documentation/video4linux/README.davinci-vpbe      |   20 +-
 Documentation/video4linux/fimc.txt                 |   16 +-
 Documentation/video4linux/omap3isp.txt             |    2 +-
 Documentation/video4linux/v4l2-controls.txt        |    6 +-
 Documentation/video4linux/v4l2-framework.txt       |   12 +-
 Documentation/video4linux/videobuf                 |    2 +-
 MAINTAINERS                                        |  404 +-
 arch/arm/mach-imx/clk-imx27.c                      |    4 +-
 arch/arm/mach-imx/devices-imx27.h                  |    4 +
 arch/arm/mach-imx/mach-imx27_visstrim_m10.c        |   49 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c       |   30 +
 arch/arm/plat-mxc/devices/Kconfig                  |    6 +-
 arch/arm/plat-mxc/devices/Makefile                 |    1 +
 arch/arm/plat-mxc/devices/platform-imx27-coda.c    |   37 +
 arch/arm/plat-mxc/include/mach/devices-common.h    |    8 +
 drivers/gpio/gpio-bt8xx.c                          |    2 +-
 drivers/media/Kconfig                              |   53 +-
 drivers/media/Makefile                             |   23 +-
 drivers/media/common/Kconfig                       |   12 +-
 drivers/media/common/Makefile                      |    7 +-
 drivers/media/common/b2c2/Kconfig                  |   28 +
 drivers/media/common/b2c2/Makefile                 |    8 +
 .../media/{dvb => common}/b2c2/flexcop-common.h    |    0
 .../media/{dvb => common}/b2c2/flexcop-eeprom.c    |    0
 .../media/{dvb => common}/b2c2/flexcop-fe-tuner.c  |    0
 .../media/{dvb => common}/b2c2/flexcop-hw-filter.c |    0
 drivers/media/{dvb => common}/b2c2/flexcop-i2c.c   |    0
 drivers/media/{dvb => common}/b2c2/flexcop-misc.c  |    0
 drivers/media/{dvb => common}/b2c2/flexcop-reg.h   |    0
 drivers/media/{dvb => common}/b2c2/flexcop-sram.c  |    0
 drivers/media/{dvb => common}/b2c2/flexcop.c       |    1 +
 drivers/media/{dvb => common}/b2c2/flexcop.h       |    0
 .../{dvb => common}/b2c2/flexcop_ibi_value_be.h    |    0
 .../{dvb => common}/b2c2/flexcop_ibi_value_le.h    |    0
 drivers/media/common/saa7146/Kconfig               |    9 +
 drivers/media/common/saa7146/Makefile              |    5 +
 drivers/media/common/{ => saa7146}/saa7146_core.c  |    8 -
 drivers/media/common/{ => saa7146}/saa7146_fops.c  |   55 +-
 drivers/media/common/{ => saa7146}/saa7146_hlp.c   |    0
 drivers/media/common/{ => saa7146}/saa7146_i2c.c   |    0
 drivers/media/common/{ => saa7146}/saa7146_vbi.c   |    0
 drivers/media/common/{ => saa7146}/saa7146_video.c |    2 +-
 drivers/media/common/siano/Kconfig                 |   17 +
 drivers/media/{dvb => common}/siano/Makefile       |    6 +-
 drivers/media/{dvb => common}/siano/sms-cards.c    |    0
 drivers/media/{dvb => common}/siano/sms-cards.h    |    0
 drivers/media/{dvb => common}/siano/smscoreapi.c   |    0
 drivers/media/{dvb => common}/siano/smscoreapi.h   |    0
 drivers/media/{dvb => common}/siano/smsdvb.c       |    0
 drivers/media/{dvb => common}/siano/smsendian.c    |    0
 drivers/media/{dvb => common}/siano/smsendian.h    |    0
 drivers/media/{dvb => common}/siano/smsir.c        |    0
 drivers/media/{dvb => common}/siano/smsir.h        |    0
 drivers/media/dvb-core/Kconfig                     |   29 +
 drivers/media/{dvb => }/dvb-core/Makefile          |    0
 drivers/media/{dvb => }/dvb-core/demux.h           |    0
 drivers/media/{dvb => }/dvb-core/dmxdev.c          |    4 +-
 drivers/media/{dvb => }/dvb-core/dmxdev.h          |    0
 .../media/{dvb/dvb-usb => dvb-core}/dvb-usb-ids.h  |    3 +
 drivers/media/{dvb => }/dvb-core/dvb_ca_en50221.c  |    0
 drivers/media/{dvb => }/dvb-core/dvb_ca_en50221.h  |    0
 drivers/media/{dvb => }/dvb-core/dvb_demux.c       |   29 +-
 drivers/media/{dvb => }/dvb-core/dvb_demux.h       |    0
 drivers/media/{dvb => }/dvb-core/dvb_filter.c      |    0
 drivers/media/{dvb => }/dvb-core/dvb_filter.h      |    0
 drivers/media/{dvb => }/dvb-core/dvb_frontend.c    |  368 +-
 drivers/media/{dvb => }/dvb-core/dvb_frontend.h    |   12 +-
 drivers/media/{dvb => }/dvb-core/dvb_math.c        |    0
 drivers/media/{dvb => }/dvb-core/dvb_math.h        |    0
 drivers/media/{dvb => }/dvb-core/dvb_net.c         |    0
 drivers/media/{dvb => }/dvb-core/dvb_net.h         |    0
 drivers/media/{dvb => }/dvb-core/dvb_ringbuffer.c  |    0
 drivers/media/{dvb => }/dvb-core/dvb_ringbuffer.h  |    0
 drivers/media/{dvb => }/dvb-core/dvbdev.c          |    2 +-
 drivers/media/{dvb => }/dvb-core/dvbdev.h          |   26 -
 .../media/{dvb/frontends => dvb-frontends}/Kconfig |  195 +-
 .../{dvb/frontends => dvb-frontends}/Makefile      |   12 +-
 .../media/{dvb/frontends => dvb-frontends}/a8293.c |    0
 .../media/{dvb/frontends => dvb-frontends}/a8293.h |    0
 .../{dvb/frontends => dvb-frontends}/af9013.c      |  158 +-
 .../{dvb/frontends => dvb-frontends}/af9013.h      |    2 +-
 .../{dvb/frontends => dvb-frontends}/af9013_priv.h |   15 +-
 .../{dvb/frontends => dvb-frontends}/af9033.c      |   96 +-
 .../{dvb/frontends => dvb-frontends}/af9033.h      |    3 +-
 .../{dvb/frontends => dvb-frontends}/af9033_priv.h |   37 +
 .../{dvb/frontends => dvb-frontends}/atbm8830.c    |    2 +-
 .../{dvb/frontends => dvb-frontends}/atbm8830.h    |    0
 .../frontends => dvb-frontends}/atbm8830_priv.h    |    0
 .../{dvb/frontends => dvb-frontends}/au8522.h      |    0
 .../frontends => dvb-frontends}/au8522_common.c    |   22 +-
 .../frontends => dvb-frontends}/au8522_decoder.c   |   11 +-
 .../{dvb/frontends => dvb-frontends}/au8522_dig.c  |   98 +-
 .../{dvb/frontends => dvb-frontends}/au8522_priv.h |   29 +-
 .../{dvb/frontends => dvb-frontends}/bcm3510.c     |    0
 .../{dvb/frontends => dvb-frontends}/bcm3510.h     |    0
 .../frontends => dvb-frontends}/bcm3510_priv.h     |    0
 .../{dvb/frontends => dvb-frontends}/bsbe1-d01a.h  |    0
 .../media/{dvb/frontends => dvb-frontends}/bsbe1.h |    0
 .../media/{dvb/frontends => dvb-frontends}/bsru6.h |    0
 .../{dvb/frontends => dvb-frontends}/cx22700.c     |    0
 .../{dvb/frontends => dvb-frontends}/cx22700.h     |    0
 .../{dvb/frontends => dvb-frontends}/cx22702.c     |    0
 .../{dvb/frontends => dvb-frontends}/cx22702.h     |    0
 .../{dvb/frontends => dvb-frontends}/cx24110.c     |    0
 .../{dvb/frontends => dvb-frontends}/cx24110.h     |    0
 .../{dvb/frontends => dvb-frontends}/cx24113.c     |    0
 .../{dvb/frontends => dvb-frontends}/cx24113.h     |    0
 .../{dvb/frontends => dvb-frontends}/cx24116.c     |    0
 .../{dvb/frontends => dvb-frontends}/cx24116.h     |    0
 .../{dvb/frontends => dvb-frontends}/cx24123.c     |    0
 .../{dvb/frontends => dvb-frontends}/cx24123.h     |    0
 .../{dvb/frontends => dvb-frontends}/cxd2820r.h    |   14 +-
 .../{dvb/frontends => dvb-frontends}/cxd2820r_c.c  |   31 +-
 .../frontends => dvb-frontends}/cxd2820r_core.c    |  211 +-
 .../frontends => dvb-frontends}/cxd2820r_priv.h    |   22 +-
 .../{dvb/frontends => dvb-frontends}/cxd2820r_t.c  |   34 +-
 .../{dvb/frontends => dvb-frontends}/cxd2820r_t2.c |   31 +-
 .../{dvb/frontends => dvb-frontends}/dib0070.c     |    0
 .../{dvb/frontends => dvb-frontends}/dib0070.h     |    0
 .../{dvb/frontends => dvb-frontends}/dib0090.c     |    0
 .../{dvb/frontends => dvb-frontends}/dib0090.h     |    0
 .../{dvb/frontends => dvb-frontends}/dib3000.h     |    0
 .../{dvb/frontends => dvb-frontends}/dib3000mb.c   |    0
 .../frontends => dvb-frontends}/dib3000mb_priv.h   |    0
 .../{dvb/frontends => dvb-frontends}/dib3000mc.c   |    0
 .../{dvb/frontends => dvb-frontends}/dib3000mc.h   |    0
 .../{dvb/frontends => dvb-frontends}/dib7000m.c    |    0
 .../{dvb/frontends => dvb-frontends}/dib7000m.h    |    0
 .../{dvb/frontends => dvb-frontends}/dib7000p.c    |    0
 .../{dvb/frontends => dvb-frontends}/dib7000p.h    |    0
 .../{dvb/frontends => dvb-frontends}/dib8000.c     |    0
 .../{dvb/frontends => dvb-frontends}/dib8000.h     |    0
 .../{dvb/frontends => dvb-frontends}/dib9000.c     |    0
 .../{dvb/frontends => dvb-frontends}/dib9000.h     |    0
 .../frontends => dvb-frontends}/dibx000_common.c   |    0
 .../frontends => dvb-frontends}/dibx000_common.h   |    0
 .../media/{dvb/frontends => dvb-frontends}/drxd.h  |    0
 .../{dvb/frontends => dvb-frontends}/drxd_firm.c   |    0
 .../{dvb/frontends => dvb-frontends}/drxd_firm.h   |    0
 .../{dvb/frontends => dvb-frontends}/drxd_hard.c   |    0
 .../frontends => dvb-frontends}/drxd_map_firm.h    |    0
 .../media/{dvb/frontends => dvb-frontends}/drxk.h  |    2 +
 .../{dvb/frontends => dvb-frontends}/drxk_hard.c   |   20 +-
 .../{dvb/frontends => dvb-frontends}/drxk_hard.h   |    0
 .../{dvb/frontends => dvb-frontends}/drxk_map.h    |    0
 .../{dvb/frontends => dvb-frontends}/ds3000.c      |    0
 .../{dvb/frontends => dvb-frontends}/ds3000.h      |    0
 .../{dvb/frontends => dvb-frontends}/dvb-pll.c     |   26 +
 .../{dvb/frontends => dvb-frontends}/dvb-pll.h     |    1 +
 .../frontends => dvb-frontends}/dvb_dummy_fe.c     |    0
 .../frontends => dvb-frontends}/dvb_dummy_fe.h     |    0
 .../media/{dvb/frontends => dvb-frontends}/ec100.c |   60 +-
 .../media/{dvb/frontends => dvb-frontends}/ec100.h |    2 +-
 .../{dvb/frontends => dvb-frontends}/eds1547.h     |    0
 .../{dvb/frontends => dvb-frontends}/hd29l2.c      |   75 +-
 .../{dvb/frontends => dvb-frontends}/hd29l2.h      |    2 +-
 .../{dvb/frontends => dvb-frontends}/hd29l2_priv.h |   13 -
 .../{dvb/frontends => dvb-frontends}/isl6405.c     |    0
 .../{dvb/frontends => dvb-frontends}/isl6405.h     |    0
 .../{dvb/frontends => dvb-frontends}/isl6421.c     |    0
 .../{dvb/frontends => dvb-frontends}/isl6421.h     |    0
 .../{dvb/frontends => dvb-frontends}/isl6423.c     |    0
 .../{dvb/frontends => dvb-frontends}/isl6423.h     |    0
 .../frontends => dvb-frontends}/it913x-fe-priv.h   |    0
 .../{dvb/frontends => dvb-frontends}/it913x-fe.c   |    2 +-
 .../{dvb/frontends => dvb-frontends}/it913x-fe.h   |    0
 .../{dvb/frontends => dvb-frontends}/itd1000.c     |    0
 .../{dvb/frontends => dvb-frontends}/itd1000.h     |    0
 .../frontends => dvb-frontends}/itd1000_priv.h     |    0
 .../{dvb/frontends => dvb-frontends}/ix2505v.c     |    0
 .../{dvb/frontends => dvb-frontends}/ix2505v.h     |    0
 .../{dvb/frontends => dvb-frontends}/l64781.c      |    0
 .../{dvb/frontends => dvb-frontends}/l64781.h      |    0
 .../{dvb/frontends => dvb-frontends}/lg2160.c      |    0
 .../{dvb/frontends => dvb-frontends}/lg2160.h      |    0
 .../{dvb/frontends => dvb-frontends}/lgdt3305.c    |    0
 .../{dvb/frontends => dvb-frontends}/lgdt3305.h    |    0
 .../{dvb/frontends => dvb-frontends}/lgdt330x.c    |    0
 .../{dvb/frontends => dvb-frontends}/lgdt330x.h    |    0
 .../frontends => dvb-frontends}/lgdt330x_priv.h    |    0
 .../{dvb/frontends => dvb-frontends}/lgs8gl5.c     |    2 +-
 .../{dvb/frontends => dvb-frontends}/lgs8gl5.h     |    0
 .../{dvb/frontends => dvb-frontends}/lgs8gxx.c     |    2 +-
 .../{dvb/frontends => dvb-frontends}/lgs8gxx.h     |    0
 .../frontends => dvb-frontends}/lgs8gxx_priv.h     |    0
 .../{dvb/frontends => dvb-frontends}/lnbh24.h      |    0
 .../{dvb/frontends => dvb-frontends}/lnbp21.c      |    0
 .../{dvb/frontends => dvb-frontends}/lnbp21.h      |    0
 .../{dvb/frontends => dvb-frontends}/lnbp22.c      |    0
 .../{dvb/frontends => dvb-frontends}/lnbp22.h      |    0
 .../{dvb/frontends => dvb-frontends}/m88rs2000.c   |    2 +-
 .../{dvb/frontends => dvb-frontends}/m88rs2000.h   |    0
 .../{dvb/frontends => dvb-frontends}/mb86a16.c     |    0
 .../{dvb/frontends => dvb-frontends}/mb86a16.h     |    0
 .../frontends => dvb-frontends}/mb86a16_priv.h     |    0
 .../{dvb/frontends => dvb-frontends}/mb86a20s.c    |    0
 .../{dvb/frontends => dvb-frontends}/mb86a20s.h    |    0
 .../media/{dvb/frontends => dvb-frontends}/mt312.c |    0
 .../media/{dvb/frontends => dvb-frontends}/mt312.h |    0
 .../{dvb/frontends => dvb-frontends}/mt312_priv.h  |    0
 .../media/{dvb/frontends => dvb-frontends}/mt352.c |    0
 .../media/{dvb/frontends => dvb-frontends}/mt352.h |    0
 .../{dvb/frontends => dvb-frontends}/mt352_priv.h  |    0
 .../{dvb/frontends => dvb-frontends}/nxt200x.c     |   64 +-
 .../{dvb/frontends => dvb-frontends}/nxt200x.h     |    0
 .../{dvb/frontends => dvb-frontends}/nxt6000.c     |    0
 .../{dvb/frontends => dvb-frontends}/nxt6000.h     |    0
 .../frontends => dvb-frontends}/nxt6000_priv.h     |    0
 .../{dvb/frontends => dvb-frontends}/or51132.c     |    0
 .../{dvb/frontends => dvb-frontends}/or51132.h     |    0
 .../{dvb/frontends => dvb-frontends}/or51211.c     |    0
 .../{dvb/frontends => dvb-frontends}/or51211.h     |    0
 .../{dvb/frontends => dvb-frontends}/rtl2830.c     |  124 +-
 .../{dvb/frontends => dvb-frontends}/rtl2830.h     |    9 +-
 .../frontends => dvb-frontends}/rtl2830_priv.h     |   13 -
 .../{dvb/frontends => dvb-frontends}/rtl2832.c     |  301 +-
 .../{dvb/frontends => dvb-frontends}/rtl2832.h     |   13 +-
 .../frontends => dvb-frontends}/rtl2832_priv.h     |  112 +-
 .../{dvb/frontends => dvb-frontends}/s5h1409.c     |    0
 .../{dvb/frontends => dvb-frontends}/s5h1409.h     |    0
 .../{dvb/frontends => dvb-frontends}/s5h1411.c     |    0
 .../{dvb/frontends => dvb-frontends}/s5h1411.h     |    0
 .../{dvb/frontends => dvb-frontends}/s5h1420.c     |    0
 .../{dvb/frontends => dvb-frontends}/s5h1420.h     |    0
 .../frontends => dvb-frontends}/s5h1420_priv.h     |    0
 .../{dvb/frontends => dvb-frontends}/s5h1432.c     |    0
 .../{dvb/frontends => dvb-frontends}/s5h1432.h     |    0
 .../media/{dvb/frontends => dvb-frontends}/s921.c  |    0
 .../media/{dvb/frontends => dvb-frontends}/s921.h  |    0
 .../{dvb/frontends => dvb-frontends}/si21xx.c      |    0
 .../{dvb/frontends => dvb-frontends}/si21xx.h      |    0
 .../{dvb/frontends => dvb-frontends}/sp8870.c      |    0
 .../{dvb/frontends => dvb-frontends}/sp8870.h      |    0
 .../{dvb/frontends => dvb-frontends}/sp887x.c      |    0
 .../{dvb/frontends => dvb-frontends}/sp887x.h      |    0
 .../frontends => dvb-frontends}/stb0899_algo.c     |    0
 .../{dvb/frontends => dvb-frontends}/stb0899_cfg.h |    0
 .../{dvb/frontends => dvb-frontends}/stb0899_drv.c |    1 +
 .../{dvb/frontends => dvb-frontends}/stb0899_drv.h |    0
 .../frontends => dvb-frontends}/stb0899_priv.h     |    0
 .../{dvb/frontends => dvb-frontends}/stb0899_reg.h |    0
 .../{dvb/frontends => dvb-frontends}/stb6000.c     |    0
 .../{dvb/frontends => dvb-frontends}/stb6000.h     |    0
 .../{dvb/frontends => dvb-frontends}/stb6100.c     |    0
 .../{dvb/frontends => dvb-frontends}/stb6100.h     |    0
 .../{dvb/frontends => dvb-frontends}/stb6100_cfg.h |    0
 .../frontends => dvb-frontends}/stb6100_proc.h     |    0
 .../{dvb/frontends => dvb-frontends}/stv0288.c     |    0
 .../{dvb/frontends => dvb-frontends}/stv0288.h     |    0
 .../{dvb/frontends => dvb-frontends}/stv0297.c     |    0
 .../{dvb/frontends => dvb-frontends}/stv0297.h     |    0
 .../{dvb/frontends => dvb-frontends}/stv0299.c     |    0
 .../{dvb/frontends => dvb-frontends}/stv0299.h     |    0
 .../{dvb/frontends => dvb-frontends}/stv0367.c     |    0
 .../{dvb/frontends => dvb-frontends}/stv0367.h     |    0
 .../frontends => dvb-frontends}/stv0367_priv.h     |    0
 .../frontends => dvb-frontends}/stv0367_regs.h     |    0
 .../{dvb/frontends => dvb-frontends}/stv0900.h     |    0
 .../frontends => dvb-frontends}/stv0900_core.c     |    0
 .../frontends => dvb-frontends}/stv0900_init.h     |    0
 .../frontends => dvb-frontends}/stv0900_priv.h     |    0
 .../{dvb/frontends => dvb-frontends}/stv0900_reg.h |    0
 .../{dvb/frontends => dvb-frontends}/stv0900_sw.c  |    0
 .../{dvb/frontends => dvb-frontends}/stv090x.c     |   32 +
 .../{dvb/frontends => dvb-frontends}/stv090x.h     |    0
 .../frontends => dvb-frontends}/stv090x_priv.h     |    0
 .../{dvb/frontends => dvb-frontends}/stv090x_reg.h |    0
 .../{dvb/frontends => dvb-frontends}/stv6110.c     |    0
 .../{dvb/frontends => dvb-frontends}/stv6110.h     |    0
 .../{dvb/frontends => dvb-frontends}/stv6110x.c    |    0
 .../{dvb/frontends => dvb-frontends}/stv6110x.h    |    0
 .../frontends => dvb-frontends}/stv6110x_priv.h    |    0
 .../frontends => dvb-frontends}/stv6110x_reg.h     |    0
 .../{dvb/frontends => dvb-frontends}/tda10021.c    |    0
 .../{dvb/frontends => dvb-frontends}/tda10023.c    |    0
 .../{dvb/frontends => dvb-frontends}/tda1002x.h    |    0
 .../{dvb/frontends => dvb-frontends}/tda10048.c    |    0
 .../{dvb/frontends => dvb-frontends}/tda10048.h    |    0
 .../{dvb/frontends => dvb-frontends}/tda1004x.c    |    8 +-
 .../{dvb/frontends => dvb-frontends}/tda1004x.h    |    0
 .../{dvb/frontends => dvb-frontends}/tda10071.c    |    7 +-
 .../{dvb/frontends => dvb-frontends}/tda10071.h    |    0
 .../frontends => dvb-frontends}/tda10071_priv.h    |    2 +-
 .../{dvb/frontends => dvb-frontends}/tda10086.c    |    0
 .../{dvb/frontends => dvb-frontends}/tda10086.h    |    0
 .../frontends => dvb-frontends}/tda18271c2dd.c     |    0
 .../frontends => dvb-frontends}/tda18271c2dd.h     |    0
 .../tda18271c2dd_maps.h                            |    0
 .../{dvb/frontends => dvb-frontends}/tda665x.c     |    0
 .../{dvb/frontends => dvb-frontends}/tda665x.h     |    0
 .../{dvb/frontends => dvb-frontends}/tda8083.c     |    0
 .../{dvb/frontends => dvb-frontends}/tda8083.h     |    0
 .../{dvb/frontends => dvb-frontends}/tda8261.c     |   28 +-
 .../{dvb/frontends => dvb-frontends}/tda8261.h     |    0
 .../{dvb/frontends => dvb-frontends}/tda8261_cfg.h |    0
 .../{dvb/frontends => dvb-frontends}/tda826x.c     |    0
 .../{dvb/frontends => dvb-frontends}/tda826x.h     |    0
 .../media/{dvb/frontends => dvb-frontends}/tdhd1.h |    0
 .../{dvb/frontends => dvb-frontends}/tua6100.c     |    0
 .../{dvb/frontends => dvb-frontends}/tua6100.h     |    0
 .../{dvb/frontends => dvb-frontends}/ves1820.c     |    0
 .../{dvb/frontends => dvb-frontends}/ves1820.h     |    0
 .../{dvb/frontends => dvb-frontends}/ves1x93.c     |    0
 .../{dvb/frontends => dvb-frontends}/ves1x93.h     |    0
 .../{dvb/frontends => dvb-frontends}/z0194a.h      |    0
 .../{dvb/frontends => dvb-frontends}/zl10036.c     |    0
 .../{dvb/frontends => dvb-frontends}/zl10036.h     |    0
 .../{dvb/frontends => dvb-frontends}/zl10039.c     |    0
 .../{dvb/frontends => dvb-frontends}/zl10039.h     |    0
 .../{dvb/frontends => dvb-frontends}/zl10353.c     |    0
 .../{dvb/frontends => dvb-frontends}/zl10353.h     |    0
 .../frontends => dvb-frontends}/zl10353_priv.h     |    0
 drivers/media/dvb/Kconfig                          |   91 -
 drivers/media/dvb/Makefile                         |   21 -
 drivers/media/dvb/b2c2/Kconfig                     |   45 -
 drivers/media/dvb/b2c2/Makefile                    |   16 -
 drivers/media/dvb/bt8xx/Kconfig                    |   22 -
 drivers/media/dvb/bt8xx/Makefile                   |    6 -
 drivers/media/dvb/dm1105/Makefile                  |    3 -
 drivers/media/dvb/dvb-usb/Kconfig                  |  440 --
 drivers/media/dvb/dvb-usb/Makefile                 |  121 -
 drivers/media/dvb/dvb-usb/af9015.c                 | 1952 ---------
 drivers/media/dvb/dvb-usb/it913x.c                 |  931 -----
 drivers/media/dvb/dvb-usb/mxl111sf.c               | 1835 ---------
 drivers/media/dvb/frontends/ec100_priv.h           |   39 -
 drivers/media/dvb/ngene/Kconfig                    |   13 -
 drivers/media/dvb/pluto2/Makefile                  |    3 -
 drivers/media/dvb/siano/Kconfig                    |   34 -
 drivers/media/dvb/ttusb-budget/Makefile            |    3 -
 drivers/media/{dvb => }/firewire/Kconfig           |    0
 drivers/media/{dvb => }/firewire/Makefile          |    4 +-
 drivers/media/{dvb => }/firewire/firedtv-avc.c     |    0
 drivers/media/{dvb => }/firewire/firedtv-ci.c      |    0
 drivers/media/{dvb => }/firewire/firedtv-dvb.c     |    0
 drivers/media/{dvb => }/firewire/firedtv-fe.c      |    0
 drivers/media/{dvb => }/firewire/firedtv-fw.c      |    0
 drivers/media/{dvb => }/firewire/firedtv-rc.c      |    0
 drivers/media/{dvb => }/firewire/firedtv.h         |    0
 drivers/media/i2c/Kconfig                          |  591 +++
 drivers/media/i2c/Makefile                         |   67 +
 drivers/media/i2c/ad9389b.c                        | 1328 ++++++
 drivers/media/{video => i2c}/adp1653.c             |    2 +-
 drivers/media/{video => i2c}/adv7170.c             |    0
 drivers/media/{video => i2c}/adv7175.c             |    0
 drivers/media/{video => i2c}/adv7180.c             |    0
 drivers/media/{video => i2c}/adv7183.c             |    0
 drivers/media/{video => i2c}/adv7183_regs.h        |    0
 drivers/media/{video => i2c}/adv7343.c             |    0
 drivers/media/{video => i2c}/adv7343_regs.h        |    0
 drivers/media/{video => i2c}/adv7393.c             |    0
 drivers/media/{video => i2c}/adv7393_regs.h        |    0
 drivers/media/i2c/adv7604.c                        | 1959 +++++++++
 drivers/media/{video => i2c}/ak881x.c              |    0
 drivers/media/{video => i2c}/aptina-pll.c          |    0
 drivers/media/{video => i2c}/aptina-pll.h          |    0
 drivers/media/{video => i2c}/as3645a.c             |    2 +-
 drivers/media/{video => i2c}/bt819.c               |    0
 drivers/media/{video => i2c}/bt856.c               |    0
 drivers/media/{video => i2c}/bt866.c               |    0
 drivers/media/{video => i2c}/btcx-risc.c           |    0
 drivers/media/{video => i2c}/btcx-risc.h           |    0
 drivers/media/{video => i2c}/cs5345.c              |    0
 drivers/media/{video => i2c}/cs53l32a.c            |    0
 drivers/media/{video => i2c}/cx2341x.c             |    0
 drivers/media/{video => i2c}/cx25840/Kconfig       |    0
 drivers/media/{video => i2c}/cx25840/Makefile      |    2 +-
 .../media/{video => i2c}/cx25840/cx25840-audio.c   |    0
 .../media/{video => i2c}/cx25840/cx25840-core.c    |    0
 .../media/{video => i2c}/cx25840/cx25840-core.h    |    0
 .../{video => i2c}/cx25840/cx25840-firmware.c      |   15 +-
 drivers/media/{video => i2c}/cx25840/cx25840-ir.c  |    0
 drivers/media/{video => i2c}/cx25840/cx25840-vbi.c |    3 +-
 drivers/media/{video => i2c}/ir-kbd-i2c.c          |    0
 drivers/media/{video => i2c}/ks0127.c              |   13 +-
 drivers/media/{video => i2c}/ks0127.h              |    0
 drivers/media/{video => i2c}/m52790.c              |    0
 drivers/media/{video => i2c}/m5mols/Kconfig        |    0
 drivers/media/{video => i2c}/m5mols/Makefile       |    0
 drivers/media/{video => i2c}/m5mols/m5mols.h       |   22 +-
 .../media/{video => i2c}/m5mols/m5mols_capture.c   |    0
 .../media/{video => i2c}/m5mols/m5mols_controls.c  |    4 +-
 drivers/media/{video => i2c}/m5mols/m5mols_core.c  |   90 +-
 drivers/media/{video => i2c}/m5mols/m5mols_reg.h   |    0
 drivers/media/{video => i2c}/msp3400-driver.c      |   40 +-
 drivers/media/{video => i2c}/msp3400-driver.h      |    0
 drivers/media/{video => i2c}/msp3400-kthreads.c    |    0
 drivers/media/{video => i2c}/mt9m032.c             |    2 +-
 drivers/media/{video => i2c}/mt9p031.c             |   12 +-
 drivers/media/{video => i2c}/mt9t001.c             |    0
 drivers/media/{video => i2c}/mt9v011.c             |    0
 drivers/media/{video => i2c}/mt9v032.c             |  100 +-
 drivers/media/{video => i2c}/noon010pc30.c         |    0
 drivers/media/{video => i2c}/ov7670.c              |    0
 drivers/media/i2c/s5k4ecgx.c                       | 1036 +++++
 drivers/media/{video => i2c}/s5k6aa.c              |   20 +-
 drivers/media/{video => i2c}/saa6588.c             |    0
 drivers/media/{video => i2c}/saa7110.c             |    0
 drivers/media/{video => i2c}/saa7115.c             |    3 +-
 drivers/media/{video => i2c}/saa711x_regs.h        |    0
 drivers/media/{video => i2c}/saa7127.c             |    7 +-
 drivers/media/{video => i2c}/saa717x.c             |    0
 drivers/media/{video => i2c}/saa7185.c             |    0
 drivers/media/{video => i2c}/saa7191.c             |    0
 drivers/media/{video => i2c}/saa7191.h             |    0
 drivers/media/{video => i2c}/smiapp-pll.c          |    2 +-
 drivers/media/{video => i2c}/smiapp-pll.h          |    2 +-
 drivers/media/{video => i2c}/smiapp/Kconfig        |    0
 drivers/media/{video => i2c}/smiapp/Makefile       |    2 +-
 drivers/media/{video => i2c}/smiapp/smiapp-core.c  |   83 +-
 .../media/{video => i2c}/smiapp/smiapp-limits.c    |    2 +-
 .../media/{video => i2c}/smiapp/smiapp-limits.h    |    2 +-
 drivers/media/{video => i2c}/smiapp/smiapp-quirk.c |   22 +-
 drivers/media/{video => i2c}/smiapp/smiapp-quirk.h |    2 +-
 .../media/{video => i2c}/smiapp/smiapp-reg-defs.h  |    2 +-
 drivers/media/{video => i2c}/smiapp/smiapp-reg.h   |    2 +-
 drivers/media/{video => i2c}/smiapp/smiapp-regs.c  |    2 +-
 drivers/media/{video => i2c}/smiapp/smiapp-regs.h  |    0
 drivers/media/{video => i2c}/smiapp/smiapp.h       |    2 +-
 drivers/media/i2c/soc_camera/Kconfig               |   89 +
 drivers/media/i2c/soc_camera/Makefile              |   14 +
 drivers/media/{video => i2c/soc_camera}/imx074.c   |   30 +-
 drivers/media/{video => i2c/soc_camera}/mt9m001.c  |   28 +-
 drivers/media/{video => i2c/soc_camera}/mt9m111.c  |  118 +-
 drivers/media/{video => i2c/soc_camera}/mt9t031.c  |   50 +-
 drivers/media/{video => i2c/soc_camera}/mt9t112.c  |   25 +-
 drivers/media/{video => i2c/soc_camera}/mt9v022.c  |   52 +-
 drivers/media/{video => i2c/soc_camera}/ov2640.c   |   20 +-
 drivers/media/{video => i2c/soc_camera}/ov5642.c   |   51 +-
 drivers/media/{video => i2c/soc_camera}/ov6650.c   |   60 +-
 drivers/media/{video => i2c/soc_camera}/ov772x.c   |  447 ++-
 drivers/media/{video => i2c/soc_camera}/ov9640.c   |   27 +-
 drivers/media/{video => i2c/soc_camera}/ov9640.h   |    0
 drivers/media/{video => i2c/soc_camera}/ov9740.c   |   47 +-
 .../media/{video => i2c/soc_camera}/rj54n1cb0c.c   |   31 +-
 drivers/media/{video => i2c/soc_camera}/tw9910.c   |   21 +-
 drivers/media/{video => i2c}/sr030pc30.c           |    0
 drivers/media/{video => i2c}/tcm825x.c             |    2 +-
 drivers/media/{video => i2c}/tcm825x.h             |    2 +-
 drivers/media/{video => i2c}/tda7432.c             |    0
 drivers/media/{video => i2c}/tda9840.c             |    0
 drivers/media/{video => i2c}/tea6415c.c            |    4 +-
 drivers/media/{video => i2c}/tea6415c.h            |    0
 drivers/media/{video => i2c}/tea6420.c             |    0
 drivers/media/{video => i2c}/tea6420.h             |    0
 drivers/media/{video => i2c}/ths7303.c             |    0
 drivers/media/{video => i2c}/tlv320aic23b.c        |    0
 drivers/media/{video => i2c}/tvaudio.c             |   17 +-
 drivers/media/{video => i2c}/tveeprom.c            |    0
 drivers/media/{video => i2c}/tvp514x.c             |    2 +-
 drivers/media/{video => i2c}/tvp514x_regs.h        |    2 +-
 drivers/media/{video => i2c}/tvp5150.c             |    4 +-
 drivers/media/{video => i2c}/tvp5150_reg.h         |    0
 drivers/media/{video => i2c}/tvp7002.c             |    0
 drivers/media/{video => i2c}/tvp7002_reg.h         |    0
 drivers/media/{video => i2c}/upd64031a.c           |    0
 drivers/media/{video => i2c}/upd64083.c            |    0
 drivers/media/{video => i2c}/vp27smpx.c            |    0
 drivers/media/{video => i2c}/vpx3220.c             |    0
 drivers/media/{video => i2c}/vs6624.c              |    0
 drivers/media/{video => i2c}/vs6624_regs.h         |    0
 drivers/media/{video => i2c}/wm8739.c              |    0
 drivers/media/{video => i2c}/wm8775.c              |    0
 drivers/media/media-device.c                       |    4 +-
 drivers/media/media-devnode.c                      |   14 +-
 drivers/media/mmc/Kconfig                          |    2 +
 drivers/media/mmc/Makefile                         |    1 +
 drivers/media/mmc/siano/Kconfig                    |   10 +
 drivers/media/mmc/siano/Makefile                   |    6 +
 drivers/media/{dvb => mmc}/siano/smssdio.c         |    0
 drivers/media/parport/Kconfig                      |   52 +
 drivers/media/parport/Makefile                     |    4 +
 drivers/media/{video => parport}/bw-qcam.c         |    0
 drivers/media/{video => parport}/c-qcam.c          |    0
 drivers/media/{video => parport}/pms.c             |    0
 drivers/media/{video => parport}/w9966.c           |    0
 drivers/media/pci/Kconfig                          |   47 +
 drivers/media/pci/Makefile                         |   26 +
 drivers/media/pci/b2c2/Kconfig                     |   15 +
 drivers/media/pci/b2c2/Makefile                    |    9 +
 drivers/media/{dvb => pci}/b2c2/flexcop-dma.c      |    0
 drivers/media/{dvb => pci}/b2c2/flexcop-pci.c      |    0
 drivers/media/pci/bt8xx/Kconfig                    |   43 +
 drivers/media/pci/bt8xx/Makefile                   |   11 +
 drivers/media/{video => pci}/bt8xx/bt848.h         |    0
 drivers/media/{dvb => pci}/bt8xx/bt878.c           |    0
 drivers/media/{dvb => pci}/bt8xx/bt878.h           |    0
 .../media/{video => pci}/bt8xx/bttv-audio-hook.c   |    0
 .../media/{video => pci}/bt8xx/bttv-audio-hook.h   |    0
 drivers/media/{video => pci}/bt8xx/bttv-cards.c    |    0
 drivers/media/{video => pci}/bt8xx/bttv-driver.c   |   16 +-
 drivers/media/{video => pci}/bt8xx/bttv-gpio.c     |    0
 drivers/media/{video => pci}/bt8xx/bttv-i2c.c      |    0
 drivers/media/{video => pci}/bt8xx/bttv-if.c       |    0
 drivers/media/{video => pci}/bt8xx/bttv-input.c    |    0
 drivers/media/{video => pci}/bt8xx/bttv-risc.c     |    0
 drivers/media/{video => pci}/bt8xx/bttv-vbi.c      |    0
 drivers/media/{video => pci}/bt8xx/bttv.h          |    0
 drivers/media/{video => pci}/bt8xx/bttvp.h         |    0
 drivers/media/{dvb => pci}/bt8xx/dst.c             |    0
 drivers/media/{dvb => pci}/bt8xx/dst_ca.c          |    3 +-
 drivers/media/{dvb => pci}/bt8xx/dst_ca.h          |    0
 drivers/media/{dvb => pci}/bt8xx/dst_common.h      |    0
 drivers/media/{dvb => pci}/bt8xx/dst_priv.h        |    0
 drivers/media/{dvb => pci}/bt8xx/dvb-bt8xx.c       |    0
 drivers/media/{dvb => pci}/bt8xx/dvb-bt8xx.h       |    0
 drivers/media/{video => pci}/cx18/Kconfig          |   14 +-
 drivers/media/{video => pci}/cx18/Makefile         |    6 +-
 drivers/media/{video => pci}/cx18/cx18-alsa-main.c |    0
 .../media/{video => pci}/cx18/cx18-alsa-mixer.c    |    0
 .../media/{video => pci}/cx18/cx18-alsa-mixer.h    |    0
 drivers/media/{video => pci}/cx18/cx18-alsa-pcm.c  |    0
 drivers/media/{video => pci}/cx18/cx18-alsa-pcm.h  |    0
 drivers/media/{video => pci}/cx18/cx18-alsa.h      |    0
 drivers/media/{video => pci}/cx18/cx18-audio.c     |    0
 drivers/media/{video => pci}/cx18/cx18-audio.h     |    0
 drivers/media/{video => pci}/cx18/cx18-av-audio.c  |    0
 drivers/media/{video => pci}/cx18/cx18-av-core.c   |    0
 drivers/media/{video => pci}/cx18/cx18-av-core.h   |    0
 .../media/{video => pci}/cx18/cx18-av-firmware.c   |    2 +
 drivers/media/{video => pci}/cx18/cx18-av-vbi.c    |    4 +-
 drivers/media/{video => pci}/cx18/cx18-cards.c     |    0
 drivers/media/{video => pci}/cx18/cx18-cards.h     |    0
 drivers/media/{video => pci}/cx18/cx18-controls.c  |    0
 drivers/media/{video => pci}/cx18/cx18-controls.h  |    0
 drivers/media/{video => pci}/cx18/cx18-driver.c    |    1 +
 drivers/media/{video => pci}/cx18/cx18-driver.h    |    0
 drivers/media/{video => pci}/cx18/cx18-dvb.c       |    6 +-
 drivers/media/{video => pci}/cx18/cx18-dvb.h       |    0
 drivers/media/{video => pci}/cx18/cx18-fileops.c   |    0
 drivers/media/{video => pci}/cx18/cx18-fileops.h   |    0
 drivers/media/{video => pci}/cx18/cx18-firmware.c  |   10 +-
 drivers/media/{video => pci}/cx18/cx18-firmware.h  |    0
 drivers/media/{video => pci}/cx18/cx18-gpio.c      |    0
 drivers/media/{video => pci}/cx18/cx18-gpio.h      |    0
 drivers/media/{video => pci}/cx18/cx18-i2c.c       |    0
 drivers/media/{video => pci}/cx18/cx18-i2c.h       |    0
 drivers/media/{video => pci}/cx18/cx18-io.c        |    0
 drivers/media/{video => pci}/cx18/cx18-io.h        |    0
 drivers/media/{video => pci}/cx18/cx18-ioctl.c     |    8 +-
 drivers/media/{video => pci}/cx18/cx18-ioctl.h     |    0
 drivers/media/{video => pci}/cx18/cx18-irq.c       |    0
 drivers/media/{video => pci}/cx18/cx18-irq.h       |    0
 drivers/media/{video => pci}/cx18/cx18-mailbox.c   |    0
 drivers/media/{video => pci}/cx18/cx18-mailbox.h   |    0
 drivers/media/{video => pci}/cx18/cx18-queue.c     |    0
 drivers/media/{video => pci}/cx18/cx18-queue.h     |    0
 drivers/media/{video => pci}/cx18/cx18-scb.c       |    0
 drivers/media/{video => pci}/cx18/cx18-scb.h       |    0
 drivers/media/{video => pci}/cx18/cx18-streams.c   |   15 +-
 drivers/media/{video => pci}/cx18/cx18-streams.h   |    0
 drivers/media/{video => pci}/cx18/cx18-vbi.c       |    0
 drivers/media/{video => pci}/cx18/cx18-vbi.h       |    0
 drivers/media/{video => pci}/cx18/cx18-version.h   |    0
 drivers/media/{video => pci}/cx18/cx18-video.c     |    0
 drivers/media/{video => pci}/cx18/cx18-video.h     |    0
 drivers/media/{video => pci}/cx18/cx23418.h        |    0
 drivers/media/pci/cx23885/Kconfig                  |   50 +
 drivers/media/{video => pci}/cx23885/Makefile      |    8 +-
 drivers/media/{video => pci}/cx23885/altera-ci.c   |    4 +-
 drivers/media/{video => pci}/cx23885/altera-ci.h   |    0
 drivers/media/{video => pci}/cx23885/cimax2.c      |    0
 drivers/media/{video => pci}/cx23885/cimax2.h      |    0
 drivers/media/{video => pci}/cx23885/cx23885-417.c |    2 +
 .../media/{video => pci}/cx23885/cx23885-alsa.c    |    0
 drivers/media/{video => pci}/cx23885/cx23885-av.c  |    0
 drivers/media/{video => pci}/cx23885/cx23885-av.h  |    0
 .../media/{video => pci}/cx23885/cx23885-cards.c   |   16 +-
 .../media/{video => pci}/cx23885/cx23885-core.c    |    0
 drivers/media/{video => pci}/cx23885/cx23885-dvb.c |   59 +-
 .../media/{video => pci}/cx23885/cx23885-f300.c    |    0
 .../media/{video => pci}/cx23885/cx23885-f300.h    |    0
 drivers/media/{video => pci}/cx23885/cx23885-i2c.c |    0
 .../media/{video => pci}/cx23885/cx23885-input.c   |    9 +
 .../media/{video => pci}/cx23885/cx23885-input.h   |    0
 .../media/{video => pci}/cx23885/cx23885-ioctl.c   |    0
 .../media/{video => pci}/cx23885/cx23885-ioctl.h   |    0
 drivers/media/{video => pci}/cx23885/cx23885-ir.c  |    0
 drivers/media/{video => pci}/cx23885/cx23885-ir.h  |    0
 drivers/media/{video => pci}/cx23885/cx23885-reg.h |    0
 drivers/media/{video => pci}/cx23885/cx23885-vbi.c |    0
 .../media/{video => pci}/cx23885/cx23885-video.c   |    2 +-
 drivers/media/{video => pci}/cx23885/cx23885.h     |    1 +
 drivers/media/{video => pci}/cx23885/cx23888-ir.c  |    0
 drivers/media/{video => pci}/cx23885/cx23888-ir.h  |    0
 .../media/{video => pci}/cx23885/netup-eeprom.c    |    0
 .../media/{video => pci}/cx23885/netup-eeprom.h    |    0
 drivers/media/{video => pci}/cx23885/netup-init.c  |    0
 drivers/media/{video => pci}/cx23885/netup-init.h  |    0
 drivers/media/{video => pci}/cx25821/Kconfig       |    0
 drivers/media/{video => pci}/cx25821/Makefile      |    8 +-
 .../media/{video => pci}/cx25821/cx25821-alsa.c    |    0
 .../cx25821/cx25821-audio-upstream.c               |    0
 .../cx25821/cx25821-audio-upstream.h               |    0
 .../media/{video => pci}/cx25821/cx25821-audio.h   |    0
 .../{video => pci}/cx25821/cx25821-biffuncs.h      |    0
 .../media/{video => pci}/cx25821/cx25821-cards.c   |    0
 .../media/{video => pci}/cx25821/cx25821-core.c    |    0
 .../media/{video => pci}/cx25821/cx25821-gpio.c    |    0
 drivers/media/{video => pci}/cx25821/cx25821-i2c.c |    0
 .../cx25821/cx25821-medusa-defines.h               |    0
 .../{video => pci}/cx25821/cx25821-medusa-reg.h    |    0
 .../{video => pci}/cx25821/cx25821-medusa-video.c  |    0
 .../{video => pci}/cx25821/cx25821-medusa-video.h  |    0
 drivers/media/{video => pci}/cx25821/cx25821-reg.h |    0
 .../media/{video => pci}/cx25821/cx25821-sram.h    |    0
 .../cx25821/cx25821-video-upstream-ch2.c           |    0
 .../cx25821/cx25821-video-upstream-ch2.h           |    0
 .../cx25821/cx25821-video-upstream.c               |    0
 .../cx25821/cx25821-video-upstream.h               |    0
 .../media/{video => pci}/cx25821/cx25821-video.c   |    2 +-
 .../media/{video => pci}/cx25821/cx25821-video.h   |    2 +-
 drivers/media/{video => pci}/cx25821/cx25821.h     |    0
 drivers/media/{video => pci}/cx88/Kconfig          |   36 +-
 drivers/media/{video => pci}/cx88/Makefile         |    8 +-
 drivers/media/{video => pci}/cx88/cx88-alsa.c      |    2 +-
 drivers/media/{video => pci}/cx88/cx88-blackbird.c |    2 +-
 drivers/media/{video => pci}/cx88/cx88-cards.c     |    4 +-
 drivers/media/{video => pci}/cx88/cx88-core.c      |    2 +-
 drivers/media/{video => pci}/cx88/cx88-dsp.c       |    0
 drivers/media/{video => pci}/cx88/cx88-dvb.c       |    2 +-
 drivers/media/{video => pci}/cx88/cx88-i2c.c       |    0
 drivers/media/{video => pci}/cx88/cx88-input.c     |    0
 drivers/media/{video => pci}/cx88/cx88-mpeg.c      |    0
 drivers/media/{video => pci}/cx88/cx88-reg.h       |    0
 drivers/media/{video => pci}/cx88/cx88-tvaudio.c   |    0
 drivers/media/{video => pci}/cx88/cx88-vbi.c       |    0
 drivers/media/{video => pci}/cx88/cx88-video.c     |    2 +-
 .../media/{video => pci}/cx88/cx88-vp3054-i2c.c    |    0
 .../media/{video => pci}/cx88/cx88-vp3054-i2c.h    |    0
 drivers/media/{video => pci}/cx88/cx88.h           |    2 +-
 drivers/media/{dvb => pci}/ddbridge/Kconfig        |   10 +-
 drivers/media/{dvb => pci}/ddbridge/Makefile       |    6 +-
 .../media/{dvb => pci}/ddbridge/ddbridge-core.c    |   15 +-
 .../media/{dvb => pci}/ddbridge/ddbridge-regs.h    |    0
 drivers/media/{dvb => pci}/ddbridge/ddbridge.h     |    0
 drivers/media/{dvb => pci}/dm1105/Kconfig          |   14 +-
 drivers/media/pci/dm1105/Makefile                  |    3 +
 drivers/media/{dvb => pci}/dm1105/dm1105.c         |    0
 drivers/media/{video => pci}/ivtv/Kconfig          |   16 +
 drivers/media/{video => pci}/ivtv/Makefile         |   10 +-
 drivers/media/pci/ivtv/ivtv-alsa-main.c            |  303 ++
 drivers/media/pci/ivtv/ivtv-alsa-mixer.c           |  175 +
 drivers/media/pci/ivtv/ivtv-alsa-mixer.h           |   23 +
 drivers/media/pci/ivtv/ivtv-alsa-pcm.c             |  356 ++
 drivers/media/pci/ivtv/ivtv-alsa-pcm.h             |   27 +
 drivers/media/pci/ivtv/ivtv-alsa.h                 |   75 +
 drivers/media/{video => pci}/ivtv/ivtv-cards.c     |    0
 drivers/media/{video => pci}/ivtv/ivtv-cards.h     |    0
 drivers/media/{video => pci}/ivtv/ivtv-controls.c  |    0
 drivers/media/{video => pci}/ivtv/ivtv-controls.h  |    0
 drivers/media/{video => pci}/ivtv/ivtv-driver.c    |   38 +
 drivers/media/{video => pci}/ivtv/ivtv-driver.h    |   11 +
 drivers/media/{video => pci}/ivtv/ivtv-fileops.c   |   61 +-
 drivers/media/{video => pci}/ivtv/ivtv-fileops.h   |    4 +-
 drivers/media/{video => pci}/ivtv/ivtv-firmware.c  |    4 +
 drivers/media/{video => pci}/ivtv/ivtv-firmware.h  |    0
 drivers/media/{video => pci}/ivtv/ivtv-gpio.c      |    0
 drivers/media/{video => pci}/ivtv/ivtv-gpio.h      |    0
 drivers/media/{video => pci}/ivtv/ivtv-i2c.c       |    0
 drivers/media/{video => pci}/ivtv/ivtv-i2c.h       |    0
 drivers/media/{video => pci}/ivtv/ivtv-ioctl.c     |  108 +-
 drivers/media/{video => pci}/ivtv/ivtv-ioctl.h     |    0
 drivers/media/{video => pci}/ivtv/ivtv-irq.c       |   50 +
 drivers/media/{video => pci}/ivtv/ivtv-irq.h       |    0
 drivers/media/{video => pci}/ivtv/ivtv-mailbox.c   |    0
 drivers/media/{video => pci}/ivtv/ivtv-mailbox.h   |    0
 drivers/media/{video => pci}/ivtv/ivtv-queue.c     |    0
 drivers/media/{video => pci}/ivtv/ivtv-queue.h     |    0
 drivers/media/{video => pci}/ivtv/ivtv-routing.c   |    0
 drivers/media/{video => pci}/ivtv/ivtv-routing.h   |    0
 drivers/media/{video => pci}/ivtv/ivtv-streams.c   |   51 +-
 drivers/media/{video => pci}/ivtv/ivtv-streams.h   |    0
 drivers/media/{video => pci}/ivtv/ivtv-udma.c      |    0
 drivers/media/{video => pci}/ivtv/ivtv-udma.h      |    0
 drivers/media/{video => pci}/ivtv/ivtv-vbi.c       |    0
 drivers/media/{video => pci}/ivtv/ivtv-vbi.h       |    0
 drivers/media/{video => pci}/ivtv/ivtv-version.h   |    0
 drivers/media/{video => pci}/ivtv/ivtv-yuv.c       |    0
 drivers/media/{video => pci}/ivtv/ivtv-yuv.h       |    0
 drivers/media/{video => pci}/ivtv/ivtvfb.c         |    0
 drivers/media/{dvb => pci}/mantis/Kconfig          |   20 +-
 drivers/media/{dvb => pci}/mantis/Makefile         |    2 +-
 drivers/media/{dvb => pci}/mantis/hopper_cards.c   |    0
 drivers/media/{dvb => pci}/mantis/hopper_vp3028.c  |    0
 drivers/media/{dvb => pci}/mantis/hopper_vp3028.h  |    0
 drivers/media/{dvb => pci}/mantis/mantis_ca.c      |    0
 drivers/media/{dvb => pci}/mantis/mantis_ca.h      |    0
 drivers/media/{dvb => pci}/mantis/mantis_cards.c   |    2 +-
 drivers/media/{dvb => pci}/mantis/mantis_common.h  |    0
 drivers/media/{dvb => pci}/mantis/mantis_core.c    |    2 +-
 drivers/media/{dvb => pci}/mantis/mantis_core.h    |    0
 drivers/media/{dvb => pci}/mantis/mantis_dma.c     |    0
 drivers/media/{dvb => pci}/mantis/mantis_dma.h     |    0
 drivers/media/{dvb => pci}/mantis/mantis_dvb.c     |    6 +-
 drivers/media/{dvb => pci}/mantis/mantis_dvb.h     |    0
 drivers/media/{dvb => pci}/mantis/mantis_evm.c     |    0
 drivers/media/{dvb => pci}/mantis/mantis_hif.c     |    0
 drivers/media/{dvb => pci}/mantis/mantis_hif.h     |    0
 drivers/media/{dvb => pci}/mantis/mantis_i2c.c     |    0
 drivers/media/{dvb => pci}/mantis/mantis_i2c.h     |    0
 drivers/media/{dvb => pci}/mantis/mantis_input.c   |    0
 drivers/media/{dvb => pci}/mantis/mantis_ioc.c     |    0
 drivers/media/{dvb => pci}/mantis/mantis_ioc.h     |    0
 drivers/media/{dvb => pci}/mantis/mantis_link.h    |    0
 drivers/media/{dvb => pci}/mantis/mantis_pci.c     |    0
 drivers/media/{dvb => pci}/mantis/mantis_pci.h     |    0
 drivers/media/{dvb => pci}/mantis/mantis_pcmcia.c  |    0
 drivers/media/{dvb => pci}/mantis/mantis_reg.h     |    0
 drivers/media/{dvb => pci}/mantis/mantis_uart.c    |    0
 drivers/media/{dvb => pci}/mantis/mantis_uart.h    |    0
 drivers/media/{dvb => pci}/mantis/mantis_vp1033.c  |    0
 drivers/media/{dvb => pci}/mantis/mantis_vp1033.h  |    0
 drivers/media/{dvb => pci}/mantis/mantis_vp1034.c  |    0
 drivers/media/{dvb => pci}/mantis/mantis_vp1034.h  |    0
 drivers/media/{dvb => pci}/mantis/mantis_vp1041.c  |    0
 drivers/media/{dvb => pci}/mantis/mantis_vp1041.h  |    0
 drivers/media/{dvb => pci}/mantis/mantis_vp2033.c  |    0
 drivers/media/{dvb => pci}/mantis/mantis_vp2033.h  |    0
 drivers/media/{dvb => pci}/mantis/mantis_vp2040.c  |    0
 drivers/media/{dvb => pci}/mantis/mantis_vp2040.h  |    0
 drivers/media/{dvb => pci}/mantis/mantis_vp3028.c  |    0
 drivers/media/{dvb => pci}/mantis/mantis_vp3028.h  |    0
 drivers/media/{dvb => pci}/mantis/mantis_vp3030.c  |    0
 drivers/media/{dvb => pci}/mantis/mantis_vp3030.h  |    0
 drivers/media/pci/meye/Kconfig                     |   13 +
 drivers/media/pci/meye/Makefile                    |    1 +
 drivers/media/{video => pci/meye}/meye.c           |    0
 drivers/media/{video => pci/meye}/meye.h           |    0
 drivers/media/pci/ngene/Kconfig                    |   13 +
 drivers/media/{dvb => pci}/ngene/Makefile          |    6 +-
 drivers/media/{dvb => pci}/ngene/ngene-cards.c     |  263 ++
 drivers/media/{dvb => pci}/ngene/ngene-core.c      |   14 +-
 drivers/media/{dvb => pci}/ngene/ngene-dvb.c       |    0
 drivers/media/{dvb => pci}/ngene/ngene-i2c.c       |    0
 drivers/media/{dvb => pci}/ngene/ngene.h           |    0
 drivers/media/{dvb => pci}/pluto2/Kconfig          |    0
 drivers/media/pci/pluto2/Makefile                  |    3 +
 drivers/media/{dvb => pci}/pluto2/pluto2.c         |    0
 drivers/media/{dvb => pci}/pt1/Kconfig             |    0
 drivers/media/{dvb => pci}/pt1/Makefile            |    2 +-
 drivers/media/{dvb => pci}/pt1/pt1.c               |    0
 drivers/media/{dvb => pci}/pt1/va1j5jf8007s.c      |   11 +-
 drivers/media/{dvb => pci}/pt1/va1j5jf8007s.h      |    0
 drivers/media/{dvb => pci}/pt1/va1j5jf8007t.c      |    0
 drivers/media/{dvb => pci}/pt1/va1j5jf8007t.h      |    0
 drivers/media/{video => pci}/saa7134/Kconfig       |   40 +-
 drivers/media/{video => pci}/saa7134/Makefile      |   10 +-
 drivers/media/{video => pci}/saa7134/saa6752hs.c   |    0
 .../media/{video => pci}/saa7134/saa7134-alsa.c    |    0
 .../media/{video => pci}/saa7134/saa7134-cards.c   |    0
 .../media/{video => pci}/saa7134/saa7134-core.c    |    0
 drivers/media/{video => pci}/saa7134/saa7134-dvb.c |    4 +-
 .../media/{video => pci}/saa7134/saa7134-empress.c |    0
 drivers/media/{video => pci}/saa7134/saa7134-i2c.c |    0
 .../media/{video => pci}/saa7134/saa7134-input.c   |   10 +-
 drivers/media/{video => pci}/saa7134/saa7134-reg.h |    0
 drivers/media/{video => pci}/saa7134/saa7134-ts.c  |    0
 .../media/{video => pci}/saa7134/saa7134-tvaudio.c |    0
 drivers/media/{video => pci}/saa7134/saa7134-vbi.c |    0
 .../media/{video => pci}/saa7134/saa7134-video.c   |   38 +-
 drivers/media/{video => pci}/saa7134/saa7134.h     |    1 -
 drivers/media/pci/saa7146/Kconfig                  |   38 +
 drivers/media/pci/saa7146/Makefile                 |    5 +
 .../media/{video => pci/saa7146}/hexium_gemini.c   |    0
 .../media/{video => pci/saa7146}/hexium_orion.c    |    0
 drivers/media/{video => pci/saa7146}/mxb.c         |    2 +-
 drivers/media/{video => pci}/saa7164/Kconfig       |    8 +-
 drivers/media/{video => pci}/saa7164/Makefile      |    8 +-
 drivers/media/{video => pci}/saa7164/saa7164-api.c |   15 +-
 .../media/{video => pci}/saa7164/saa7164-buffer.c  |    0
 drivers/media/{video => pci}/saa7164/saa7164-bus.c |    0
 .../media/{video => pci}/saa7164/saa7164-cards.c   |    0
 drivers/media/{video => pci}/saa7164/saa7164-cmd.c |    0
 .../media/{video => pci}/saa7164/saa7164-core.c    |   46 +-
 drivers/media/{video => pci}/saa7164/saa7164-dvb.c |    0
 .../media/{video => pci}/saa7164/saa7164-encoder.c |    0
 drivers/media/{video => pci}/saa7164/saa7164-fw.c  |    0
 drivers/media/{video => pci}/saa7164/saa7164-i2c.c |    0
 drivers/media/{video => pci}/saa7164/saa7164-reg.h |    0
 .../media/{video => pci}/saa7164/saa7164-types.h   |    0
 drivers/media/{video => pci}/saa7164/saa7164-vbi.c |    0
 drivers/media/{video => pci}/saa7164/saa7164.h     |    1 -
 drivers/media/pci/sta2x11/Kconfig                  |   12 +
 drivers/media/pci/sta2x11/Makefile                 |    1 +
 drivers/media/{video => pci/sta2x11}/sta2x11_vip.c |    0
 drivers/media/{video => pci/sta2x11}/sta2x11_vip.h |    0
 drivers/media/{dvb => pci}/ttpci/Kconfig           |   84 +-
 drivers/media/{dvb => pci}/ttpci/Makefile          |    4 +-
 drivers/media/{dvb => pci}/ttpci/av7110.c          |    0
 drivers/media/{dvb => pci}/ttpci/av7110.h          |    0
 drivers/media/{dvb => pci}/ttpci/av7110_av.c       |    0
 drivers/media/{dvb => pci}/ttpci/av7110_av.h       |    0
 drivers/media/{dvb => pci}/ttpci/av7110_ca.c       |    0
 drivers/media/{dvb => pci}/ttpci/av7110_ca.h       |    0
 drivers/media/{dvb => pci}/ttpci/av7110_hw.c       |    0
 drivers/media/{dvb => pci}/ttpci/av7110_hw.h       |    0
 drivers/media/{dvb => pci}/ttpci/av7110_ipack.c    |    0
 drivers/media/{dvb => pci}/ttpci/av7110_ipack.h    |    0
 drivers/media/{dvb => pci}/ttpci/av7110_ir.c       |    0
 drivers/media/{dvb => pci}/ttpci/av7110_v4l.c      |    2 +-
 drivers/media/{dvb => pci}/ttpci/budget-av.c       |    0
 drivers/media/{dvb => pci}/ttpci/budget-ci.c       |    0
 drivers/media/{dvb => pci}/ttpci/budget-core.c     |    0
 drivers/media/{dvb => pci}/ttpci/budget-patch.c    |    0
 drivers/media/{dvb => pci}/ttpci/budget.c          |   60 +
 drivers/media/{dvb => pci}/ttpci/budget.h          |    0
 drivers/media/{dvb => pci}/ttpci/ttpci-eeprom.c    |    0
 drivers/media/{dvb => pci}/ttpci/ttpci-eeprom.h    |    0
 drivers/media/{video => pci}/zoran/Kconfig         |   30 +-
 drivers/media/{video => pci}/zoran/Makefile        |    0
 drivers/media/{video => pci}/zoran/videocodec.c    |    0
 drivers/media/{video => pci}/zoran/videocodec.h    |    0
 drivers/media/{video => pci}/zoran/zoran.h         |    0
 drivers/media/{video => pci}/zoran/zoran_card.c    |    4 +
 drivers/media/{video => pci}/zoran/zoran_card.h    |    0
 drivers/media/{video => pci}/zoran/zoran_device.c  |    0
 drivers/media/{video => pci}/zoran/zoran_device.h  |    0
 drivers/media/{video => pci}/zoran/zoran_driver.c  |    8 +-
 drivers/media/{video => pci}/zoran/zoran_procfs.c  |    0
 drivers/media/{video => pci}/zoran/zoran_procfs.h  |    0
 drivers/media/{video => pci}/zoran/zr36016.c       |    0
 drivers/media/{video => pci}/zoran/zr36016.h       |    0
 drivers/media/{video => pci}/zoran/zr36050.c       |    0
 drivers/media/{video => pci}/zoran/zr36050.h       |    0
 drivers/media/{video => pci}/zoran/zr36057.h       |    0
 drivers/media/{video => pci}/zoran/zr36060.c       |    0
 drivers/media/{video => pci}/zoran/zr36060.h       |    0
 drivers/media/platform/Kconfig                     |  223 +
 drivers/media/platform/Makefile                    |   50 +
 drivers/media/{video => platform}/arv.c            |    0
 drivers/media/{video => platform}/blackfin/Kconfig |    0
 .../media/{video => platform}/blackfin/Makefile    |    0
 .../{video => platform}/blackfin/bfin_capture.c    |   18 +-
 drivers/media/{video => platform}/blackfin/ppi.c   |    0
 drivers/media/platform/coda.c                      | 2049 ++++++++++
 drivers/media/platform/coda.h                      |  238 ++
 drivers/media/{video => platform}/davinci/Kconfig  |    4 +-
 drivers/media/{video => platform}/davinci/Makefile |    0
 .../{video => platform}/davinci/ccdc_hw_device.h   |    0
 .../media/{video => platform}/davinci/dm355_ccdc.c |    2 +-
 .../{video => platform}/davinci/dm355_ccdc_regs.h  |    0
 .../{video => platform}/davinci/dm644x_ccdc.c      |    2 +-
 .../{video => platform}/davinci/dm644x_ccdc_regs.h |    0
 drivers/media/{video => platform}/davinci/isif.c   |    2 +-
 .../media/{video => platform}/davinci/isif_regs.h  |    0
 drivers/media/{video => platform}/davinci/vpbe.c   |    0
 .../{video => platform}/davinci/vpbe_display.c     |   25 +-
 .../media/{video => platform}/davinci/vpbe_osd.c   |    0
 .../{video => platform}/davinci/vpbe_osd_regs.h    |    0
 .../media/{video => platform}/davinci/vpbe_venc.c  |    0
 .../{video => platform}/davinci/vpbe_venc_regs.h   |    0
 .../{video => platform}/davinci/vpfe_capture.c     |   19 +-
 drivers/media/{video => platform}/davinci/vpif.c   |   18 +-
 drivers/media/{video => platform}/davinci/vpif.h   |    4 +-
 .../{video => platform}/davinci/vpif_capture.c     |  146 +-
 .../{video => platform}/davinci/vpif_capture.h     |    4 +-
 .../{video => platform}/davinci/vpif_display.c     |  141 +-
 .../{video => platform}/davinci/vpif_display.h     |    4 +-
 drivers/media/{video => platform}/davinci/vpss.c   |    2 +-
 drivers/media/platform/exynos-gsc/Makefile         |    3 +
 drivers/media/platform/exynos-gsc/gsc-core.c       | 1252 ++++++
 drivers/media/platform/exynos-gsc/gsc-core.h       |  527 +++
 drivers/media/platform/exynos-gsc/gsc-m2m.c        |  770 ++++
 drivers/media/platform/exynos-gsc/gsc-regs.c       |  425 ++
 drivers/media/platform/exynos-gsc/gsc-regs.h       |  172 +
 drivers/media/{video => platform}/fsl-viu.c        |   29 +-
 drivers/media/{video => platform}/indycam.c        |    0
 drivers/media/{video => platform}/indycam.h        |    0
 drivers/media/platform/m2m-deinterlace.c           | 1124 ++++++
 .../media/{video => platform}/marvell-ccic/Kconfig |    0
 .../{video => platform}/marvell-ccic/Makefile      |    0
 .../{video => platform}/marvell-ccic/cafe-driver.c |    0
 .../{video => platform}/marvell-ccic/mcam-core.c   |    0
 .../{video => platform}/marvell-ccic/mcam-core.h   |    0
 .../{video => platform}/marvell-ccic/mmp-driver.c  |    0
 .../media/{video => platform}/mem2mem_testdev.c    |   44 +-
 drivers/media/{video => platform}/mx2_emmaprp.c    |   78 +-
 drivers/media/{video => platform}/omap/Kconfig     |    0
 drivers/media/{video => platform}/omap/Makefile    |    2 +-
 drivers/media/{video => platform}/omap/omap_vout.c |    5 +-
 .../{video => platform}/omap/omap_vout_vrfb.c      |    0
 .../{video => platform}/omap/omap_vout_vrfb.h      |    0
 .../media/{video => platform}/omap/omap_voutdef.h  |    0
 .../media/{video => platform}/omap/omap_voutlib.c  |    0
 .../media/{video => platform}/omap/omap_voutlib.h  |    0
 .../media/{video => platform}/omap24xxcam-dma.c    |    2 +-
 drivers/media/{video => platform}/omap24xxcam.c    |    2 +-
 drivers/media/{video => platform}/omap24xxcam.h    |    2 +-
 .../media/{video => platform}/omap3isp/Makefile    |    0
 .../{video => platform}/omap3isp/cfa_coef_table.h  |   16 +-
 .../{video => platform}/omap3isp/gamma_table.h     |    0
 drivers/media/{video => platform}/omap3isp/isp.c   |   53 +-
 drivers/media/{video => platform}/omap3isp/isp.h   |   11 +-
 .../media/{video => platform}/omap3isp/ispccdc.c   |  238 +-
 .../media/{video => platform}/omap3isp/ispccdc.h   |   37 -
 .../media/{video => platform}/omap3isp/ispccp2.c   |    0
 .../media/{video => platform}/omap3isp/ispccp2.h   |    0
 .../media/{video => platform}/omap3isp/ispcsi2.c   |   27 +-
 .../media/{video => platform}/omap3isp/ispcsi2.h   |    0
 .../media/{video => platform}/omap3isp/ispcsiphy.c |    0
 .../media/{video => platform}/omap3isp/ispcsiphy.h |    0
 .../media/{video => platform}/omap3isp/isph3a.h    |    0
 .../{video => platform}/omap3isp/isph3a_aewb.c     |   10 +-
 .../media/{video => platform}/omap3isp/isph3a_af.c |   10 +-
 .../media/{video => platform}/omap3isp/isphist.c   |    6 +-
 .../media/{video => platform}/omap3isp/isphist.h   |    0
 .../{video => platform}/omap3isp/isppreview.c      |  707 ++--
 .../{video => platform}/omap3isp/isppreview.h      |    1 +
 .../media/{video => platform}/omap3isp/ispqueue.c  |   15 +-
 .../media/{video => platform}/omap3isp/ispqueue.h  |    0
 .../media/{video => platform}/omap3isp/ispreg.h    |    0
 .../{video => platform}/omap3isp/ispresizer.c      |    8 +-
 .../{video => platform}/omap3isp/ispresizer.h      |    0
 .../media/{video => platform}/omap3isp/ispstat.c   |    4 +-
 .../media/{video => platform}/omap3isp/ispstat.h   |    4 +-
 .../media/{video => platform}/omap3isp/ispvideo.c  |   66 +-
 .../media/{video => platform}/omap3isp/ispvideo.h  |    6 +-
 .../omap3isp/luma_enhance_table.h                  |    0
 .../omap3isp/noise_filter_table.h                  |    0
 drivers/media/{video => platform}/s5p-fimc/Kconfig |    2 +-
 .../media/{video => platform}/s5p-fimc/Makefile    |    0
 .../{video => platform}/s5p-fimc/fimc-capture.c    |   58 +-
 .../media/{video => platform}/s5p-fimc/fimc-core.c |    0
 .../media/{video => platform}/s5p-fimc/fimc-core.h |    7 +-
 .../{video => platform}/s5p-fimc/fimc-lite-reg.c   |    8 +-
 .../{video => platform}/s5p-fimc/fimc-lite-reg.h   |    0
 .../media/{video => platform}/s5p-fimc/fimc-lite.c |   70 +-
 .../media/{video => platform}/s5p-fimc/fimc-lite.h |    6 +-
 .../media/{video => platform}/s5p-fimc/fimc-m2m.c  |   47 +-
 .../{video => platform}/s5p-fimc/fimc-mdevice.c    |   79 +-
 .../{video => platform}/s5p-fimc/fimc-mdevice.h    |   14 +-
 .../media/{video => platform}/s5p-fimc/fimc-reg.c  |    6 +-
 .../media/{video => platform}/s5p-fimc/fimc-reg.h  |    0
 .../media/{video => platform}/s5p-fimc/mipi-csis.c |  160 +-
 .../media/{video => platform}/s5p-fimc/mipi-csis.h |    0
 drivers/media/{video => platform}/s5p-g2d/Makefile |    0
 drivers/media/{video => platform}/s5p-g2d/g2d-hw.c |    0
 .../media/{video => platform}/s5p-g2d/g2d-regs.h   |    0
 drivers/media/{video => platform}/s5p-g2d/g2d.c    |   32 +-
 drivers/media/{video => platform}/s5p-g2d/g2d.h    |    0
 .../media/{video => platform}/s5p-jpeg/Makefile    |    0
 .../media/{video => platform}/s5p-jpeg/jpeg-core.c |   41 +-
 .../media/{video => platform}/s5p-jpeg/jpeg-core.h |    2 +-
 .../media/{video => platform}/s5p-jpeg/jpeg-hw.h   |    2 +-
 .../media/{video => platform}/s5p-jpeg/jpeg-regs.h |    2 +-
 drivers/media/{video => platform}/s5p-mfc/Makefile |    0
 .../media/{video => platform}/s5p-mfc/regs-mfc.h   |    0
 .../media/{video => platform}/s5p-mfc/s5p_mfc.c    |  127 +-
 .../{video => platform}/s5p-mfc/s5p_mfc_cmd.c      |    2 +-
 .../{video => platform}/s5p-mfc/s5p_mfc_cmd.h      |    2 +-
 .../{video => platform}/s5p-mfc/s5p_mfc_common.h   |   10 +-
 .../{video => platform}/s5p-mfc/s5p_mfc_ctrl.c     |   10 +-
 .../{video => platform}/s5p-mfc/s5p_mfc_ctrl.h     |    2 +-
 .../{video => platform}/s5p-mfc/s5p_mfc_debug.h    |    2 +-
 .../{video => platform}/s5p-mfc/s5p_mfc_dec.c      |   34 +-
 .../{video => platform}/s5p-mfc/s5p_mfc_dec.h      |    2 +-
 .../{video => platform}/s5p-mfc/s5p_mfc_enc.c      |  142 +-
 .../{video => platform}/s5p-mfc/s5p_mfc_enc.h      |    2 +-
 .../{video => platform}/s5p-mfc/s5p_mfc_intr.c     |    2 +-
 .../{video => platform}/s5p-mfc/s5p_mfc_intr.h     |    2 +-
 .../{video => platform}/s5p-mfc/s5p_mfc_opr.c      |   50 +-
 .../{video => platform}/s5p-mfc/s5p_mfc_opr.h      |    2 +-
 .../media/{video => platform}/s5p-mfc/s5p_mfc_pm.c |    2 +-
 .../media/{video => platform}/s5p-mfc/s5p_mfc_pm.h |    2 +-
 .../{video => platform}/s5p-mfc/s5p_mfc_shm.c      |    2 +-
 .../{video => platform}/s5p-mfc/s5p_mfc_shm.h      |    2 +-
 drivers/media/{video => platform}/s5p-tv/Kconfig   |    2 +-
 drivers/media/{video => platform}/s5p-tv/Makefile  |    2 +-
 .../media/{video => platform}/s5p-tv/hdmi_drv.c    |    6 +-
 .../media/{video => platform}/s5p-tv/hdmiphy_drv.c |    0
 drivers/media/{video => platform}/s5p-tv/mixer.h   |    0
 .../media/{video => platform}/s5p-tv/mixer_drv.c   |    8 +-
 .../{video => platform}/s5p-tv/mixer_grp_layer.c   |    0
 .../media/{video => platform}/s5p-tv/mixer_reg.c   |    0
 .../media/{video => platform}/s5p-tv/mixer_video.c |   41 +-
 .../{video => platform}/s5p-tv/mixer_vp_layer.c    |    0
 .../media/{video => platform}/s5p-tv/regs-hdmi.h   |    0
 .../media/{video => platform}/s5p-tv/regs-mixer.h  |    0
 .../media/{video => platform}/s5p-tv/regs-sdo.h    |    2 +-
 drivers/media/{video => platform}/s5p-tv/regs-vp.h |    0
 drivers/media/{video => platform}/s5p-tv/sdo_drv.c |   10 +-
 .../media/{video => platform}/s5p-tv/sii9234_drv.c |   17 +-
 drivers/media/{video => platform}/sh_vou.c         |   30 +-
 drivers/media/platform/soc_camera/Kconfig          |   87 +
 drivers/media/platform/soc_camera/Makefile         |   14 +
 .../{video => platform/soc_camera}/atmel-isi.c     |    0
 .../{video => platform/soc_camera}/mx1_camera.c    |    0
 .../{video => platform/soc_camera}/mx2_camera.c    |  193 +-
 .../{video => platform/soc_camera}/mx3_camera.c    |    4 +-
 .../{video => platform/soc_camera}/omap1_camera.c  |    2 +-
 .../{video => platform/soc_camera}/pxa_camera.c    |    0
 .../soc_camera}/sh_mobile_ceu_camera.c             |    4 +-
 .../soc_camera}/sh_mobile_csi2.c                   |    0
 .../{video => platform/soc_camera}/soc_camera.c    |  205 +-
 .../soc_camera}/soc_camera_platform.c              |   11 +-
 .../{video => platform/soc_camera}/soc_mediabus.c  |    0
 drivers/media/{video => platform}/timblogiw.c      |    0
 drivers/media/{video => platform}/via-camera.c     |    0
 drivers/media/{video => platform}/via-camera.h     |    0
 drivers/media/{video => platform}/vino.c           |    2 +-
 drivers/media/{video => platform}/vino.h           |    0
 drivers/media/{video => platform}/vivi.c           |   56 +-
 drivers/media/radio/radio-keene.c                  |    2 +-
 drivers/media/radio/radio-miropcm20.c              |    2 +-
 drivers/media/radio/radio-mr800.c                  |    5 +-
 drivers/media/radio/radio-sf16fmi.c                |    2 +-
 drivers/media/radio/radio-shark.c                  |   44 +-
 drivers/media/radio/radio-shark2.c                 |   52 +-
 drivers/media/radio/radio-si4713.c                 |   11 +-
 drivers/media/radio/radio-tea5764.c                |   15 +-
 drivers/media/radio/radio-tea5777.c                |  205 +-
 drivers/media/radio/radio-tea5777.h                |    3 +
 drivers/media/radio/radio-timb.c                   |   10 +-
 drivers/media/radio/radio-wl1273.c                 |   32 +-
 drivers/media/radio/saa7706h.c                     |   15 +-
 drivers/media/radio/si470x/radio-si470x-common.c   |    7 +-
 drivers/media/radio/si470x/radio-si470x-i2c.c      |   23 +-
 drivers/media/radio/si4713-i2c.c                   |    4 +-
 drivers/media/radio/wl128x/fmdrv_v4l2.c            |   47 +-
 drivers/media/rc/Kconfig                           |   32 +-
 drivers/media/rc/Makefile                          |    2 +
 drivers/media/rc/ati_remote.c                      |   15 +-
 drivers/media/rc/fintek-cir.c                      |   11 +-
 drivers/media/rc/iguanair.c                        |  247 +-
 drivers/media/rc/ir-lirc-codec.c                   |   35 +-
 drivers/media/rc/ir-nec-decoder.c                  |    4 +-
 drivers/media/rc/ir-raw.c                          |    6 +-
 drivers/media/rc/ir-rx51.c                         |  498 +++
 drivers/media/rc/ite-cir.c                         |    2 +-
 drivers/media/rc/keymaps/rc-tt-1500.c              |    2 +-
 drivers/media/rc/mceusb.c                          |   30 +-
 drivers/media/rc/rc-loopback.c                     |   12 -
 drivers/media/rc/redrat3.c                         |    5 +-
 drivers/media/rc/ttusbir.c                         |  447 +++
 drivers/media/rc/winbond-cir.c                     |   49 +-
 drivers/media/{common => }/tuners/Kconfig          |  105 +-
 drivers/media/{common => }/tuners/Makefile         |    6 +-
 drivers/media/tuners/e4000.c                       |  409 ++
 drivers/media/tuners/e4000.h                       |   52 +
 drivers/media/tuners/e4000_priv.h                  |  147 +
 drivers/media/{common => }/tuners/fc0011.c         |    0
 drivers/media/{common => }/tuners/fc0011.h         |    0
 drivers/media/{common => }/tuners/fc0012-priv.h    |    0
 drivers/media/{common => }/tuners/fc0012.c         |    0
 drivers/media/{common => }/tuners/fc0012.h         |    0
 drivers/media/{common => }/tuners/fc0013-priv.h    |    0
 drivers/media/{common => }/tuners/fc0013.c         |    0
 drivers/media/{common => }/tuners/fc0013.h         |    0
 drivers/media/{common => }/tuners/fc001x-common.h  |    0
 drivers/media/tuners/fc2580.c                      |  529 +++
 drivers/media/tuners/fc2580.h                      |   52 +
 drivers/media/tuners/fc2580_priv.h                 |  134 +
 drivers/media/{common => }/tuners/max2165.c        |    0
 drivers/media/{common => }/tuners/max2165.h        |    0
 drivers/media/{common => }/tuners/max2165_priv.h   |    0
 drivers/media/{common => }/tuners/mc44s803.c       |    9 +-
 drivers/media/{common => }/tuners/mc44s803.h       |    0
 drivers/media/{common => }/tuners/mc44s803_priv.h  |    0
 drivers/media/{common => }/tuners/mt2060.c         |    0
 drivers/media/{common => }/tuners/mt2060.h         |    0
 drivers/media/{common => }/tuners/mt2060_priv.h    |    0
 drivers/media/{common => }/tuners/mt2063.c         |    0
 drivers/media/{common => }/tuners/mt2063.h         |    0
 drivers/media/{common => }/tuners/mt20xx.c         |    0
 drivers/media/{common => }/tuners/mt20xx.h         |    0
 drivers/media/{common => }/tuners/mt2131.c         |    0
 drivers/media/{common => }/tuners/mt2131.h         |    0
 drivers/media/{common => }/tuners/mt2131_priv.h    |    0
 drivers/media/{common => }/tuners/mt2266.c         |    0
 drivers/media/{common => }/tuners/mt2266.h         |    0
 drivers/media/{common => }/tuners/mxl5005s.c       |   11 +
 drivers/media/{common => }/tuners/mxl5005s.h       |    0
 drivers/media/{common => }/tuners/mxl5007t.c       |    0
 drivers/media/{common => }/tuners/mxl5007t.h       |    0
 drivers/media/{common => }/tuners/qt1010.c         |   66 +-
 drivers/media/{common => }/tuners/qt1010.h         |    0
 drivers/media/{common => }/tuners/qt1010_priv.h    |    0
 drivers/media/{common => }/tuners/tda18212.c       |   37 +-
 drivers/media/{common => }/tuners/tda18212.h       |    0
 drivers/media/{common => }/tuners/tda18218.c       |   52 +-
 drivers/media/{common => }/tuners/tda18218.h       |    0
 drivers/media/{common => }/tuners/tda18218_priv.h  |   13 +-
 .../media/{common => }/tuners/tda18271-common.c    |   10 +-
 drivers/media/{common => }/tuners/tda18271-fe.c    |   19 +-
 drivers/media/{common => }/tuners/tda18271-maps.c  |    0
 drivers/media/{common => }/tuners/tda18271-priv.h  |    0
 drivers/media/{common => }/tuners/tda18271.h       |    5 +
 drivers/media/{common => }/tuners/tda827x.c        |    0
 drivers/media/{common => }/tuners/tda827x.h        |    0
 drivers/media/{common => }/tuners/tda8290.c        |    0
 drivers/media/{common => }/tuners/tda8290.h        |    0
 drivers/media/{common => }/tuners/tda9887.c        |    0
 drivers/media/{common => }/tuners/tda9887.h        |    0
 drivers/media/{common => }/tuners/tea5761.c        |    0
 drivers/media/{common => }/tuners/tea5761.h        |    0
 drivers/media/{common => }/tuners/tea5767.c        |    0
 drivers/media/{common => }/tuners/tea5767.h        |    0
 drivers/media/{common => }/tuners/tua9001.c        |  105 +-
 drivers/media/{common => }/tuners/tua9001.h        |   20 +
 drivers/media/{common => }/tuners/tua9001_priv.h   |    0
 drivers/media/{common => }/tuners/tuner-i2c.h      |    0
 drivers/media/{common => }/tuners/tuner-simple.c   |    0
 drivers/media/{common => }/tuners/tuner-simple.h   |    0
 drivers/media/{common => }/tuners/tuner-types.c    |    0
 .../media/{common => }/tuners/tuner-xc2028-types.h |    0
 drivers/media/{common => }/tuners/tuner-xc2028.c   |    7 +-
 drivers/media/{common => }/tuners/tuner-xc2028.h   |    0
 drivers/media/{common => }/tuners/xc4000.c         |    3 +-
 drivers/media/{common => }/tuners/xc4000.h         |    0
 drivers/media/{common => }/tuners/xc5000.c         |  161 +-
 drivers/media/{common => }/tuners/xc5000.h         |    0
 drivers/media/usb/Kconfig                          |   54 +
 drivers/media/usb/Makefile                         |   22 +
 drivers/media/{video => usb}/au0828/Kconfig        |   11 +-
 drivers/media/{video => usb}/au0828/Makefile       |    6 +-
 drivers/media/{video => usb}/au0828/au0828-cards.c |    4 +-
 drivers/media/{video => usb}/au0828/au0828-cards.h |    0
 drivers/media/{video => usb}/au0828/au0828-core.c  |   59 +-
 drivers/media/{video => usb}/au0828/au0828-dvb.c   |   54 +-
 drivers/media/{video => usb}/au0828/au0828-i2c.c   |   21 +-
 drivers/media/{video => usb}/au0828/au0828-reg.h   |    1 +
 drivers/media/{video => usb}/au0828/au0828-vbi.c   |    0
 drivers/media/{video => usb}/au0828/au0828-video.c |   78 +-
 drivers/media/{video => usb}/au0828/au0828.h       |    2 +
 drivers/media/usb/b2c2/Kconfig                     |   15 +
 drivers/media/usb/b2c2/Makefile                    |    5 +
 drivers/media/{dvb => usb}/b2c2/flexcop-usb.c      |    5 +-
 drivers/media/{dvb => usb}/b2c2/flexcop-usb.h      |    0
 drivers/media/{video => usb}/cpia2/Kconfig         |    0
 drivers/media/{video => usb}/cpia2/Makefile        |    0
 drivers/media/{video => usb}/cpia2/cpia2.h         |    0
 drivers/media/{video => usb}/cpia2/cpia2_core.c    |    6 +-
 .../media/{video => usb}/cpia2/cpia2_registers.h   |    0
 drivers/media/{video => usb}/cpia2/cpia2_usb.c     |    0
 drivers/media/{video => usb}/cpia2/cpia2_v4l.c     |   44 +-
 drivers/media/{video => usb}/cx231xx/Kconfig       |    8 +-
 drivers/media/{video => usb}/cx231xx/Makefile      |   11 +-
 drivers/media/{video => usb}/cx231xx/cx231xx-417.c |    2 +
 .../media/{video => usb}/cx231xx/cx231xx-audio.c   |    0
 .../media/{video => usb}/cx231xx/cx231xx-avcore.c  |    0
 .../media/{video => usb}/cx231xx/cx231xx-cards.c   |    0
 .../{video => usb}/cx231xx/cx231xx-conf-reg.h      |    0
 .../media/{video => usb}/cx231xx/cx231xx-core.c    |    0
 drivers/media/{video => usb}/cx231xx/cx231xx-dif.h |    0
 drivers/media/{video => usb}/cx231xx/cx231xx-dvb.c |    0
 drivers/media/{video => usb}/cx231xx/cx231xx-i2c.c |    0
 .../media/{video => usb}/cx231xx/cx231xx-input.c   |    0
 .../media/{video => usb}/cx231xx/cx231xx-pcb-cfg.c |    0
 .../media/{video => usb}/cx231xx/cx231xx-pcb-cfg.h |    0
 drivers/media/{video => usb}/cx231xx/cx231xx-reg.h |    0
 drivers/media/{video => usb}/cx231xx/cx231xx-vbi.c |    0
 drivers/media/{video => usb}/cx231xx/cx231xx-vbi.h |    0
 .../media/{video => usb}/cx231xx/cx231xx-video.c   |   51 +-
 drivers/media/{video => usb}/cx231xx/cx231xx.h     |    0
 drivers/media/usb/dvb-usb-v2/Kconfig               |  149 +
 drivers/media/usb/dvb-usb-v2/Makefile              |   49 +
 drivers/media/usb/dvb-usb-v2/af9015.c              | 1454 +++++++
 .../media/{dvb/dvb-usb => usb/dvb-usb-v2}/af9015.h |   55 +-
 .../media/{dvb/dvb-usb => usb/dvb-usb-v2}/af9035.c |  884 ++--
 .../media/{dvb/dvb-usb => usb/dvb-usb-v2}/af9035.h |   10 +-
 .../media/{dvb/dvb-usb => usb/dvb-usb-v2}/anysee.c |  671 ++--
 .../media/{dvb/dvb-usb => usb/dvb-usb-v2}/anysee.h |   10 +-
 .../media/{dvb/dvb-usb => usb/dvb-usb-v2}/au6610.c |  123 +-
 .../media/{dvb/dvb-usb => usb/dvb-usb-v2}/au6610.h |   13 +-
 .../media/{dvb/dvb-usb => usb/dvb-usb-v2}/az6007.c |  410 +-
 .../media/{dvb/dvb-usb => usb/dvb-usb-v2}/ce6230.c |  188 +-
 .../media/{dvb/dvb-usb => usb/dvb-usb-v2}/ce6230.h |   33 +-
 drivers/media/usb/dvb-usb-v2/cypress_firmware.c    |  134 +
 drivers/media/usb/dvb-usb-v2/cypress_firmware.h    |   31 +
 drivers/media/usb/dvb-usb-v2/dvb_usb.h             |  403 ++
 drivers/media/usb/dvb-usb-v2/dvb_usb_common.h      |   35 +
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c        | 1049 +++++
 drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c         |   77 +
 .../media/{dvb/dvb-usb => usb/dvb-usb-v2}/ec168.c  |  326 +-
 .../media/{dvb/dvb-usb => usb/dvb-usb-v2}/ec168.h  |   24 +-
 .../media/{dvb/dvb-usb => usb/dvb-usb-v2}/gl861.c  |  132 +-
 .../media/{dvb/dvb-usb => usb/dvb-usb-v2}/gl861.h  |    5 +-
 drivers/media/usb/dvb-usb-v2/it913x.c              |  799 ++++
 .../{dvb/dvb-usb => usb/dvb-usb-v2}/lmedm04.c      |  586 ++-
 .../{dvb/dvb-usb => usb/dvb-usb-v2}/lmedm04.h      |    0
 .../dvb-usb => usb/dvb-usb-v2}/mxl111sf-demod.c    |    0
 .../dvb-usb => usb/dvb-usb-v2}/mxl111sf-demod.h    |    0
 .../dvb-usb => usb/dvb-usb-v2}/mxl111sf-gpio.c     |    0
 .../dvb-usb => usb/dvb-usb-v2}/mxl111sf-gpio.h     |    0
 .../{dvb/dvb-usb => usb/dvb-usb-v2}/mxl111sf-i2c.c |    0
 .../{dvb/dvb-usb => usb/dvb-usb-v2}/mxl111sf-i2c.h |    0
 .../{dvb/dvb-usb => usb/dvb-usb-v2}/mxl111sf-phy.c |    0
 .../{dvb/dvb-usb => usb/dvb-usb-v2}/mxl111sf-phy.h |    0
 .../{dvb/dvb-usb => usb/dvb-usb-v2}/mxl111sf-reg.h |    0
 .../dvb-usb => usb/dvb-usb-v2}/mxl111sf-tuner.c    |    2 +
 .../dvb-usb => usb/dvb-usb-v2}/mxl111sf-tuner.h    |    0
 drivers/media/usb/dvb-usb-v2/mxl111sf.c            | 1431 +++++++
 .../{dvb/dvb-usb => usb/dvb-usb-v2}/mxl111sf.h     |   22 +-
 .../{dvb/dvb-usb => usb/dvb-usb-v2}/rtl28xxu.c     | 1196 +++---
 .../{dvb/dvb-usb => usb/dvb-usb-v2}/rtl28xxu.h     |   29 +-
 drivers/media/usb/dvb-usb-v2/usb_urb.c             |  358 ++
 drivers/media/usb/dvb-usb/Kconfig                  |  313 ++
 drivers/media/usb/dvb-usb/Makefile                 |   83 +
 drivers/media/{dvb => usb}/dvb-usb/a800.c          |    0
 drivers/media/{dvb => usb}/dvb-usb/af9005-fe.c     |    0
 drivers/media/{dvb => usb}/dvb-usb/af9005-remote.c |    0
 drivers/media/{dvb => usb}/dvb-usb/af9005-script.h |    0
 drivers/media/{dvb => usb}/dvb-usb/af9005.c        |    0
 drivers/media/{dvb => usb}/dvb-usb/af9005.h        |    0
 drivers/media/{dvb => usb}/dvb-usb/az6027.c        |    0
 drivers/media/{dvb => usb}/dvb-usb/az6027.h        |    0
 .../media/{dvb => usb}/dvb-usb/cinergyT2-core.c    |    0
 drivers/media/{dvb => usb}/dvb-usb/cinergyT2-fe.c  |    0
 drivers/media/{dvb => usb}/dvb-usb/cinergyT2.h     |    0
 drivers/media/{dvb => usb}/dvb-usb/cxusb.c         |    0
 drivers/media/{dvb => usb}/dvb-usb/cxusb.h         |    0
 drivers/media/{dvb => usb}/dvb-usb/dib0700.h       |    0
 drivers/media/{dvb => usb}/dvb-usb/dib0700_core.c  |    6 +-
 .../media/{dvb => usb}/dvb-usb/dib0700_devices.c   |    0
 drivers/media/{dvb => usb}/dvb-usb/dib07x0.h       |    0
 drivers/media/{dvb => usb}/dvb-usb/dibusb-common.c |    0
 drivers/media/{dvb => usb}/dvb-usb/dibusb-mb.c     |    0
 drivers/media/{dvb => usb}/dvb-usb/dibusb-mc.c     |    0
 drivers/media/{dvb => usb}/dvb-usb/dibusb.h        |    0
 drivers/media/{dvb => usb}/dvb-usb/digitv.c        |    0
 drivers/media/{dvb => usb}/dvb-usb/digitv.h        |    0
 drivers/media/{dvb => usb}/dvb-usb/dtt200u-fe.c    |    0
 drivers/media/{dvb => usb}/dvb-usb/dtt200u.c       |    0
 drivers/media/{dvb => usb}/dvb-usb/dtt200u.h       |    0
 drivers/media/{dvb => usb}/dvb-usb/dtv5100.c       |    0
 drivers/media/{dvb => usb}/dvb-usb/dtv5100.h       |    0
 .../media/{dvb => usb}/dvb-usb/dvb-usb-common.h    |    0
 drivers/media/{dvb => usb}/dvb-usb/dvb-usb-dvb.c   |    1 -
 .../media/{dvb => usb}/dvb-usb/dvb-usb-firmware.c  |    0
 drivers/media/{dvb => usb}/dvb-usb/dvb-usb-i2c.c   |    0
 drivers/media/{dvb => usb}/dvb-usb/dvb-usb-init.c  |    0
 .../media/{dvb => usb}/dvb-usb/dvb-usb-remote.c    |    0
 drivers/media/{dvb => usb}/dvb-usb/dvb-usb-urb.c   |    0
 drivers/media/{dvb => usb}/dvb-usb/dvb-usb.h       |    2 -
 drivers/media/{dvb => usb}/dvb-usb/dw2102.c        |    0
 drivers/media/{dvb => usb}/dvb-usb/dw2102.h        |    0
 drivers/media/{dvb => usb}/dvb-usb/friio-fe.c      |    0
 drivers/media/{dvb => usb}/dvb-usb/friio.c         |    0
 drivers/media/{dvb => usb}/dvb-usb/friio.h         |    0
 drivers/media/{dvb => usb}/dvb-usb/gp8psk-fe.c     |    0
 drivers/media/{dvb => usb}/dvb-usb/gp8psk.c        |    0
 drivers/media/{dvb => usb}/dvb-usb/gp8psk.h        |    0
 drivers/media/{dvb => usb}/dvb-usb/m920x.c         |    0
 drivers/media/{dvb => usb}/dvb-usb/m920x.h         |    0
 drivers/media/{dvb => usb}/dvb-usb/nova-t-usb2.c   |    0
 drivers/media/{dvb => usb}/dvb-usb/opera1.c        |    0
 drivers/media/{dvb => usb}/dvb-usb/pctv452e.c      |    7 +-
 .../media/{dvb => usb}/dvb-usb/technisat-usb2.c    |    0
 drivers/media/{dvb => usb}/dvb-usb/ttusb2.c        |    2 +-
 drivers/media/{dvb => usb}/dvb-usb/ttusb2.h        |    0
 drivers/media/{dvb => usb}/dvb-usb/umt-010.c       |    0
 drivers/media/{dvb => usb}/dvb-usb/usb-urb.c       |    0
 drivers/media/{dvb => usb}/dvb-usb/vp702x-fe.c     |    0
 drivers/media/{dvb => usb}/dvb-usb/vp702x.c        |    0
 drivers/media/{dvb => usb}/dvb-usb/vp702x.h        |    0
 drivers/media/{dvb => usb}/dvb-usb/vp7045-fe.c     |    0
 drivers/media/{dvb => usb}/dvb-usb/vp7045.c        |    0
 drivers/media/{dvb => usb}/dvb-usb/vp7045.h        |    0
 drivers/media/{video => usb}/em28xx/Kconfig        |   28 +-
 drivers/media/{video => usb}/em28xx/Makefile       |   10 +-
 drivers/media/{video => usb}/em28xx/em28xx-audio.c |    1 -
 drivers/media/{video => usb}/em28xx/em28xx-cards.c |   22 +-
 drivers/media/{video => usb}/em28xx/em28xx-core.c  |    4 -
 drivers/media/{video => usb}/em28xx/em28xx-dvb.c   |   60 +-
 drivers/media/{video => usb}/em28xx/em28xx-i2c.c   |    0
 drivers/media/{video => usb}/em28xx/em28xx-input.c |    0
 drivers/media/{video => usb}/em28xx/em28xx-reg.h   |    0
 drivers/media/{video => usb}/em28xx/em28xx-vbi.c   |    0
 drivers/media/{video => usb}/em28xx/em28xx-video.c |   56 +-
 drivers/media/{video => usb}/em28xx/em28xx.h       |    0
 drivers/media/{video => usb}/gspca/Kconfig         |    6 +-
 drivers/media/{video => usb}/gspca/Makefile        |    0
 .../{video => usb}/gspca/autogain_functions.c      |    0
 .../{video => usb}/gspca/autogain_functions.h      |    0
 drivers/media/{video => usb}/gspca/benq.c          |    0
 drivers/media/{video => usb}/gspca/conex.c         |    0
 drivers/media/{video => usb}/gspca/cpia1.c         |    2 +-
 drivers/media/{video => usb}/gspca/etoms.c         |    0
 drivers/media/{video => usb}/gspca/finepix.c       |   18 +-
 drivers/media/{video => usb}/gspca/gl860/Kconfig   |    0
 drivers/media/{video => usb}/gspca/gl860/Makefile  |    2 +-
 .../{video => usb}/gspca/gl860/gl860-mi1320.c      |    0
 .../{video => usb}/gspca/gl860/gl860-mi2020.c      |    0
 .../{video => usb}/gspca/gl860/gl860-ov2640.c      |    0
 .../{video => usb}/gspca/gl860/gl860-ov9655.c      |    0
 drivers/media/{video => usb}/gspca/gl860/gl860.c   |    0
 drivers/media/{video => usb}/gspca/gl860/gl860.h   |    0
 drivers/media/{video => usb}/gspca/gspca.c         |   14 +-
 drivers/media/{video => usb}/gspca/gspca.h         |    8 +-
 drivers/media/{video => usb}/gspca/jeilinj.c       |    2 +-
 drivers/media/{video => usb}/gspca/jl2005bcd.c     |   18 +-
 drivers/media/{video => usb}/gspca/jpeg.h          |    0
 drivers/media/{video => usb}/gspca/kinect.c        |    0
 drivers/media/{video => usb}/gspca/konica.c        |    0
 drivers/media/{video => usb}/gspca/m5602/Kconfig   |    0
 drivers/media/{video => usb}/gspca/m5602/Makefile  |    2 +-
 .../{video => usb}/gspca/m5602/m5602_bridge.h      |    0
 .../media/{video => usb}/gspca/m5602/m5602_core.c  |    0
 .../{video => usb}/gspca/m5602/m5602_mt9m111.c     |    0
 .../{video => usb}/gspca/m5602/m5602_mt9m111.h     |    0
 .../{video => usb}/gspca/m5602/m5602_ov7660.c      |    0
 .../{video => usb}/gspca/m5602/m5602_ov7660.h      |    0
 .../{video => usb}/gspca/m5602/m5602_ov9650.c      |    0
 .../{video => usb}/gspca/m5602/m5602_ov9650.h      |    0
 .../{video => usb}/gspca/m5602/m5602_po1030.c      |    0
 .../{video => usb}/gspca/m5602/m5602_po1030.h      |    0
 .../{video => usb}/gspca/m5602/m5602_s5k4aa.c      |    0
 .../{video => usb}/gspca/m5602/m5602_s5k4aa.h      |    0
 .../{video => usb}/gspca/m5602/m5602_s5k83a.c      |    0
 .../{video => usb}/gspca/m5602/m5602_s5k83a.h      |    0
 .../{video => usb}/gspca/m5602/m5602_sensor.h      |    0
 drivers/media/{video => usb}/gspca/mars.c          |    0
 drivers/media/{video => usb}/gspca/mr97310a.c      |    0
 drivers/media/{video => usb}/gspca/nw80x.c         |    0
 drivers/media/{video => usb}/gspca/ov519.c         |   18 +-
 drivers/media/{video => usb}/gspca/ov534.c         |    0
 drivers/media/{video => usb}/gspca/ov534_9.c       |    0
 drivers/media/{video => usb}/gspca/pac207.c        |    0
 drivers/media/{video => usb}/gspca/pac7302.c       |   47 +-
 drivers/media/{video => usb}/gspca/pac7311.c       |    0
 drivers/media/{video => usb}/gspca/pac_common.h    |    0
 drivers/media/{video => usb}/gspca/se401.c         |    0
 drivers/media/{video => usb}/gspca/se401.h         |    0
 drivers/media/{video => usb}/gspca/sn9c2028.c      |    0
 drivers/media/{video => usb}/gspca/sn9c2028.h      |    0
 drivers/media/{video => usb}/gspca/sn9c20x.c       |    2 +
 drivers/media/{video => usb}/gspca/sonixb.c        |    0
 drivers/media/{video => usb}/gspca/sonixj.c        |    2 +
 drivers/media/{video => usb}/gspca/spca1528.c      |    0
 drivers/media/{video => usb}/gspca/spca500.c       |    0
 drivers/media/{video => usb}/gspca/spca501.c       |    0
 drivers/media/{video => usb}/gspca/spca505.c       |    0
 drivers/media/{video => usb}/gspca/spca506.c       |    0
 drivers/media/{video => usb}/gspca/spca508.c       |    0
 drivers/media/{video => usb}/gspca/spca561.c       |    0
 drivers/media/{video => usb}/gspca/sq905.c         |   19 +-
 drivers/media/{video => usb}/gspca/sq905c.c        |   25 +-
 drivers/media/{video => usb}/gspca/sq930x.c        |   10 +-
 drivers/media/{video => usb}/gspca/stk014.c        |    0
 drivers/media/{video => usb}/gspca/stv0680.c       |    0
 drivers/media/{video => usb}/gspca/stv06xx/Kconfig |    0
 .../media/{video => usb}/gspca/stv06xx/Makefile    |    2 +-
 .../media/{video => usb}/gspca/stv06xx/stv06xx.c   |    0
 .../media/{video => usb}/gspca/stv06xx/stv06xx.h   |    0
 .../{video => usb}/gspca/stv06xx/stv06xx_hdcs.c    |    0
 .../{video => usb}/gspca/stv06xx/stv06xx_hdcs.h    |    0
 .../{video => usb}/gspca/stv06xx/stv06xx_pb0100.c  |    0
 .../{video => usb}/gspca/stv06xx/stv06xx_pb0100.h  |    0
 .../{video => usb}/gspca/stv06xx/stv06xx_sensor.h  |    0
 .../{video => usb}/gspca/stv06xx/stv06xx_st6422.c  |    0
 .../{video => usb}/gspca/stv06xx/stv06xx_st6422.h  |    0
 .../{video => usb}/gspca/stv06xx/stv06xx_vv6410.c  |    0
 .../{video => usb}/gspca/stv06xx/stv06xx_vv6410.h  |    0
 drivers/media/{video => usb}/gspca/sunplus.c       |    0
 drivers/media/{video => usb}/gspca/t613.c          |    0
 drivers/media/{video => usb}/gspca/topro.c         |    2 +-
 drivers/media/{video => usb}/gspca/tv8532.c        |    0
 drivers/media/{video => usb}/gspca/vc032x.c        |    7 +-
 drivers/media/{video => usb}/gspca/vicam.c         |   17 +-
 drivers/media/{video => usb}/gspca/w996Xcf.c       |    0
 drivers/media/{video => usb}/gspca/xirlink_cit.c   |    4 +-
 drivers/media/{video => usb}/gspca/zc3xx-reg.h     |    0
 drivers/media/{video => usb}/gspca/zc3xx.c         |   17 +-
 drivers/media/{video => usb}/hdpvr/Kconfig         |    0
 drivers/media/{video => usb}/hdpvr/Makefile        |    2 +-
 drivers/media/{video => usb}/hdpvr/hdpvr-control.c |    0
 drivers/media/{video => usb}/hdpvr/hdpvr-core.c    |    0
 drivers/media/{video => usb}/hdpvr/hdpvr-i2c.c     |    0
 drivers/media/{video => usb}/hdpvr/hdpvr-video.c   |    2 +-
 drivers/media/{video => usb}/hdpvr/hdpvr.h         |    0
 drivers/media/{video => usb}/pvrusb2/Kconfig       |   14 +-
 drivers/media/{video => usb}/pvrusb2/Makefile      |    8 +-
 .../media/{video => usb}/pvrusb2/pvrusb2-audio.c   |    0
 .../media/{video => usb}/pvrusb2/pvrusb2-audio.h   |    0
 .../media/{video => usb}/pvrusb2/pvrusb2-context.c |    0
 .../media/{video => usb}/pvrusb2/pvrusb2-context.h |    0
 .../{video => usb}/pvrusb2/pvrusb2-cs53l32a.c      |    0
 .../{video => usb}/pvrusb2/pvrusb2-cs53l32a.h      |    0
 .../media/{video => usb}/pvrusb2/pvrusb2-ctrl.c    |    0
 .../media/{video => usb}/pvrusb2/pvrusb2-ctrl.h    |    0
 .../{video => usb}/pvrusb2/pvrusb2-cx2584x-v4l.c   |    0
 .../{video => usb}/pvrusb2/pvrusb2-cx2584x-v4l.h   |    0
 .../media/{video => usb}/pvrusb2/pvrusb2-debug.h   |    0
 .../{video => usb}/pvrusb2/pvrusb2-debugifc.c      |    0
 .../{video => usb}/pvrusb2/pvrusb2-debugifc.h      |    0
 .../media/{video => usb}/pvrusb2/pvrusb2-devattr.c |   17 +-
 .../media/{video => usb}/pvrusb2/pvrusb2-devattr.h |    0
 drivers/media/{video => usb}/pvrusb2/pvrusb2-dvb.c |    0
 drivers/media/{video => usb}/pvrusb2/pvrusb2-dvb.h |    0
 .../media/{video => usb}/pvrusb2/pvrusb2-eeprom.c  |    0
 .../media/{video => usb}/pvrusb2/pvrusb2-eeprom.h  |    0
 .../media/{video => usb}/pvrusb2/pvrusb2-encoder.c |    0
 .../media/{video => usb}/pvrusb2/pvrusb2-encoder.h |    0
 .../media/{video => usb}/pvrusb2/pvrusb2-fx2-cmd.h |    0
 .../{video => usb}/pvrusb2/pvrusb2-hdw-internal.h  |    0
 drivers/media/{video => usb}/pvrusb2/pvrusb2-hdw.c |    0
 drivers/media/{video => usb}/pvrusb2/pvrusb2-hdw.h |    0
 .../{video => usb}/pvrusb2/pvrusb2-i2c-core.c      |    0
 .../{video => usb}/pvrusb2/pvrusb2-i2c-core.h      |    0
 drivers/media/{video => usb}/pvrusb2/pvrusb2-io.c  |    0
 drivers/media/{video => usb}/pvrusb2/pvrusb2-io.h  |    0
 .../media/{video => usb}/pvrusb2/pvrusb2-ioread.c  |    0
 .../media/{video => usb}/pvrusb2/pvrusb2-ioread.h  |    0
 .../media/{video => usb}/pvrusb2/pvrusb2-main.c    |    0
 drivers/media/{video => usb}/pvrusb2/pvrusb2-std.c |    0
 drivers/media/{video => usb}/pvrusb2/pvrusb2-std.h |    0
 .../media/{video => usb}/pvrusb2/pvrusb2-sysfs.c   |    0
 .../media/{video => usb}/pvrusb2/pvrusb2-sysfs.h   |    0
 .../media/{video => usb}/pvrusb2/pvrusb2-util.h    |    0
 .../media/{video => usb}/pvrusb2/pvrusb2-v4l2.c    |    4 +-
 .../media/{video => usb}/pvrusb2/pvrusb2-v4l2.h    |    0
 .../{video => usb}/pvrusb2/pvrusb2-video-v4l.c     |    0
 .../{video => usb}/pvrusb2/pvrusb2-video-v4l.h     |    0
 .../media/{video => usb}/pvrusb2/pvrusb2-wm8775.c  |    0
 .../media/{video => usb}/pvrusb2/pvrusb2-wm8775.h  |    0
 drivers/media/{video => usb}/pvrusb2/pvrusb2.h     |    0
 drivers/media/{video => usb}/pwc/Kconfig           |    0
 drivers/media/{video => usb}/pwc/Makefile          |    2 +-
 drivers/media/{video => usb}/pwc/philips.txt       |    0
 drivers/media/{video => usb}/pwc/pwc-ctrl.c        |    0
 drivers/media/{video => usb}/pwc/pwc-dec1.c        |    0
 drivers/media/{video => usb}/pwc/pwc-dec1.h        |    0
 drivers/media/{video => usb}/pwc/pwc-dec23.c       |    0
 drivers/media/{video => usb}/pwc/pwc-dec23.h       |    0
 drivers/media/{video => usb}/pwc/pwc-if.c          |    3 +-
 drivers/media/{video => usb}/pwc/pwc-kiara.c       |    0
 drivers/media/{video => usb}/pwc/pwc-kiara.h       |    0
 drivers/media/{video => usb}/pwc/pwc-misc.c        |    0
 drivers/media/{video => usb}/pwc/pwc-nala.h        |    0
 drivers/media/{video => usb}/pwc/pwc-timon.c       |    0
 drivers/media/{video => usb}/pwc/pwc-timon.h       |    0
 drivers/media/{video => usb}/pwc/pwc-uncompress.c  |    0
 drivers/media/{video => usb}/pwc/pwc-v4l.c         |    0
 drivers/media/{video => usb}/pwc/pwc.h             |    0
 drivers/media/usb/s2255/Kconfig                    |    9 +
 drivers/media/usb/s2255/Makefile                   |    2 +
 drivers/media/{video => usb/s2255}/s2255drv.c      |   45 +-
 drivers/media/usb/siano/Kconfig                    |   10 +
 drivers/media/usb/siano/Makefile                   |    6 +
 drivers/media/{dvb => usb}/siano/smsusb.c          |    0
 drivers/media/{video => usb}/sn9c102/Kconfig       |    0
 drivers/media/{video => usb}/sn9c102/Makefile      |    0
 drivers/media/{video => usb}/sn9c102/sn9c102.h     |    0
 .../media/{video => usb}/sn9c102/sn9c102_config.h  |    0
 .../media/{video => usb}/sn9c102/sn9c102_core.c    |    0
 .../{video => usb}/sn9c102/sn9c102_devtable.h      |    0
 .../media/{video => usb}/sn9c102/sn9c102_hv7131d.c |    0
 .../media/{video => usb}/sn9c102/sn9c102_hv7131r.c |    0
 .../media/{video => usb}/sn9c102/sn9c102_mi0343.c  |    0
 .../media/{video => usb}/sn9c102/sn9c102_mi0360.c  |    0
 .../media/{video => usb}/sn9c102/sn9c102_mt9v111.c |    0
 .../media/{video => usb}/sn9c102/sn9c102_ov7630.c  |    0
 .../media/{video => usb}/sn9c102/sn9c102_ov7660.c  |    0
 .../media/{video => usb}/sn9c102/sn9c102_pas106b.c |    0
 .../{video => usb}/sn9c102/sn9c102_pas202bcb.c     |    0
 .../media/{video => usb}/sn9c102/sn9c102_sensor.h  |    0
 .../{video => usb}/sn9c102/sn9c102_tas5110c1b.c    |    0
 .../{video => usb}/sn9c102/sn9c102_tas5110d.c      |    0
 .../{video => usb}/sn9c102/sn9c102_tas5130d1b.c    |    0
 drivers/media/usb/stk1160/Kconfig                  |   20 +
 drivers/media/usb/stk1160/Makefile                 |   11 +
 drivers/media/usb/stk1160/stk1160-ac97.c           |  152 +
 drivers/media/usb/stk1160/stk1160-core.c           |  430 ++
 drivers/media/usb/stk1160/stk1160-i2c.c            |  294 ++
 drivers/media/usb/stk1160/stk1160-reg.h            |   93 +
 drivers/media/usb/stk1160/stk1160-v4l.c            |  739 ++++
 drivers/media/usb/stk1160/stk1160-video.c          |  522 +++
 drivers/media/usb/stk1160/stk1160.h                |  208 +
 drivers/media/usb/stkwebcam/Kconfig                |   13 +
 drivers/media/usb/stkwebcam/Makefile               |    4 +
 .../media/{video => usb/stkwebcam}/stk-sensor.c    |    0
 .../media/{video => usb/stkwebcam}/stk-webcam.c    |    0
 .../media/{video => usb/stkwebcam}/stk-webcam.h    |    0
 drivers/media/{video => usb}/tlg2300/Kconfig       |    0
 drivers/media/usb/tlg2300/Makefile                 |    9 +
 drivers/media/{video => usb}/tlg2300/pd-alsa.c     |    4 +
 drivers/media/{video => usb}/tlg2300/pd-common.h   |    0
 drivers/media/{video => usb}/tlg2300/pd-dvb.c      |    0
 drivers/media/{video => usb}/tlg2300/pd-main.c     |    0
 drivers/media/{video => usb}/tlg2300/pd-radio.c    |    2 +-
 drivers/media/{video => usb}/tlg2300/pd-video.c    |    2 +-
 drivers/media/{video => usb}/tlg2300/vendorcmds.h  |    0
 drivers/media/{video => usb}/tm6000/Kconfig        |    0
 drivers/media/{video => usb}/tm6000/Makefile       |    8 +-
 drivers/media/{video => usb}/tm6000/tm6000-alsa.c  |    3 +-
 drivers/media/{video => usb}/tm6000/tm6000-cards.c |    0
 drivers/media/{video => usb}/tm6000/tm6000-core.c  |    0
 drivers/media/{video => usb}/tm6000/tm6000-dvb.c   |    0
 drivers/media/{video => usb}/tm6000/tm6000-i2c.c   |    0
 drivers/media/{video => usb}/tm6000/tm6000-input.c |    3 +-
 drivers/media/{video => usb}/tm6000/tm6000-regs.h  |    0
 drivers/media/{video => usb}/tm6000/tm6000-stds.c  |    0
 .../media/{video => usb}/tm6000/tm6000-usb-isoc.h  |    0
 drivers/media/{video => usb}/tm6000/tm6000-video.c |   54 +-
 drivers/media/{video => usb}/tm6000/tm6000.h       |    0
 drivers/media/{dvb => usb}/ttusb-budget/Kconfig    |   14 +-
 drivers/media/usb/ttusb-budget/Makefile            |    3 +
 .../{dvb => usb}/ttusb-budget/dvb-ttusb-budget.c   |    0
 drivers/media/{dvb => usb}/ttusb-dec/Kconfig       |    0
 drivers/media/{dvb => usb}/ttusb-dec/Makefile      |    2 +-
 drivers/media/{dvb => usb}/ttusb-dec/ttusb_dec.c   |    0
 drivers/media/{dvb => usb}/ttusb-dec/ttusbdecfe.c  |    0
 drivers/media/{dvb => usb}/ttusb-dec/ttusbdecfe.h  |    0
 drivers/media/{video => usb}/usbvision/Kconfig     |    2 +-
 drivers/media/{video => usb}/usbvision/Makefile    |    4 +-
 .../{video => usb}/usbvision/usbvision-cards.c     |    0
 .../{video => usb}/usbvision/usbvision-cards.h     |    0
 .../{video => usb}/usbvision/usbvision-core.c      |    0
 .../media/{video => usb}/usbvision/usbvision-i2c.c |    0
 .../{video => usb}/usbvision/usbvision-video.c     |   44 +-
 drivers/media/{video => usb}/usbvision/usbvision.h |    0
 drivers/media/{video => usb}/uvc/Kconfig           |    0
 drivers/media/{video => usb}/uvc/Makefile          |    0
 drivers/media/{video => usb}/uvc/uvc_ctrl.c        |    0
 drivers/media/{video => usb}/uvc/uvc_debugfs.c     |    0
 drivers/media/{video => usb}/uvc/uvc_driver.c      |   42 +-
 drivers/media/{video => usb}/uvc/uvc_entity.c      |    0
 drivers/media/{video => usb}/uvc/uvc_isight.c      |    0
 drivers/media/{video => usb}/uvc/uvc_queue.c       |    0
 drivers/media/{video => usb}/uvc/uvc_status.c      |    0
 drivers/media/{video => usb}/uvc/uvc_v4l2.c        |    0
 drivers/media/{video => usb}/uvc/uvc_video.c       |   30 +-
 drivers/media/{video => usb}/uvc/uvcvideo.h        |    9 +
 drivers/media/usb/zr364xx/Kconfig                  |   14 +
 drivers/media/usb/zr364xx/Makefile                 |    2 +
 drivers/media/{video => usb/zr364xx}/zr364xx.c     |    0
 drivers/media/v4l2-core/Kconfig                    |   81 +
 drivers/media/v4l2-core/Makefile                   |   35 +
 drivers/media/{video => v4l2-core}/tuner-core.c    |    0
 drivers/media/{video => v4l2-core}/v4l2-common.c   |  362 +-
 .../{video => v4l2-core}/v4l2-compat-ioctl32.c     |   65 +-
 drivers/media/{video => v4l2-core}/v4l2-ctrls.c    |  201 +-
 drivers/media/{video => v4l2-core}/v4l2-dev.c      |  277 +-
 drivers/media/{video => v4l2-core}/v4l2-device.c   |    2 +-
 drivers/media/{video => v4l2-core}/v4l2-event.c    |    4 +-
 drivers/media/{video => v4l2-core}/v4l2-fh.c       |    0
 .../media/{video => v4l2-core}/v4l2-int-device.c   |    0
 drivers/media/{video => v4l2-core}/v4l2-ioctl.c    |  242 +-
 drivers/media/{video => v4l2-core}/v4l2-mem2mem.c  |    6 +-
 drivers/media/{video => v4l2-core}/v4l2-subdev.c   |    6 +
 drivers/media/{video => v4l2-core}/videobuf-core.c |    0
 .../{video => v4l2-core}/videobuf-dma-contig.c     |    0
 .../media/{video => v4l2-core}/videobuf-dma-sg.c   |    0
 drivers/media/{video => v4l2-core}/videobuf-dvb.c  |   11 +-
 .../media/{video => v4l2-core}/videobuf-vmalloc.c  |    0
 .../media/{video => v4l2-core}/videobuf2-core.c    |   44 +-
 .../{video => v4l2-core}/videobuf2-dma-contig.c    |    0
 .../media/{video => v4l2-core}/videobuf2-dma-sg.c  |    0
 .../media/{video => v4l2-core}/videobuf2-memops.c  |    0
 .../media/{video => v4l2-core}/videobuf2-vmalloc.c |    1 +
 drivers/media/video/Kconfig                        | 1263 ------
 drivers/media/video/Makefile                       |  218 -
 drivers/media/video/bt8xx/Kconfig                  |   27 -
 drivers/media/video/bt8xx/Makefile                 |   13 -
 drivers/media/video/cx23885/Kconfig                |   46 -
 drivers/media/video/tlg2300/Makefile               |    9 -
 drivers/staging/media/Kconfig                      |    2 -
 drivers/staging/media/Makefile                     |    1 -
 drivers/staging/media/as102/Makefile               |    2 +-
 drivers/staging/media/cxd2099/Makefile             |    6 +-
 drivers/staging/media/cxd2099/cxd2099.c            |   13 +-
 drivers/staging/media/dt3155v4l/dt3155v4l.c        |   29 +-
 drivers/staging/media/easycap/Kconfig              |   30 -
 drivers/staging/media/easycap/Makefile             |   10 -
 drivers/staging/media/easycap/README               |  141 -
 drivers/staging/media/easycap/easycap.h            |  567 ---
 drivers/staging/media/easycap/easycap_ioctl.c      | 2443 -----------
 drivers/staging/media/easycap/easycap_low.c        |  968 -----
 drivers/staging/media/easycap/easycap_main.c       | 4239 --------------------
 drivers/staging/media/easycap/easycap_settings.c   |  696 ----
 drivers/staging/media/easycap/easycap_sound.c      |  750 ----
 drivers/staging/media/easycap/easycap_testcard.c   |  155 -
 drivers/staging/media/go7007/Makefile              |    6 +-
 drivers/staging/media/go7007/go7007-v4l2.c         |    4 +-
 drivers/staging/media/lirc/Kconfig                 |    6 -
 drivers/staging/media/lirc/Makefile                |    1 -
 drivers/staging/media/lirc/lirc_ene0100.h          |  169 -
 drivers/staging/media/lirc/lirc_igorplugusb.c      |    4 +-
 drivers/staging/media/lirc/lirc_ttusbir.c          |  376 --
 drivers/staging/media/lirc/lirc_zilog.c            |    3 +-
 include/linux/Kbuild                               |    1 +
 include/linux/dvb/frontend.h                       |   61 +-
 include/linux/dvb/version.h                        |    2 +-
 include/linux/omap3isp.h                           |    6 +-
 include/linux/v4l2-common.h                        |    8 +-
 include/linux/v4l2-controls.h                      |  761 ++++
 include/linux/v4l2-subdev.h                        |   10 +
 include/linux/videodev2.h                          |  726 +---
 include/media/ad9389b.h                            |   49 +
 include/media/adv7604.h                            |  153 +
 include/media/ir-rx51.h                            |   10 +
 include/media/mt9v032.h                            |    3 +
 include/media/omap3isp.h                           |   14 +-
 include/media/s5k4ecgx.h                           |   37 +
 include/media/s5p_fimc.h                           |   18 +
 include/media/saa7146.h                            |    4 -
 include/media/soc_camera.h                         |   16 +-
 include/media/v4l2-chip-ident.h                    |    6 +
 include/media/v4l2-common.h                        |   17 +-
 include/media/v4l2-ctrls.h                         |   43 +-
 include/media/v4l2-dev.h                           |   12 +-
 include/media/v4l2-event.h                         |    4 +-
 include/media/v4l2-ioctl.h                         |   26 +-
 include/media/v4l2-mem2mem.h                       |    4 +-
 include/media/v4l2-subdev.h                        |    8 +-
 include/media/videobuf-dvb.h                       |    4 +-
 include/media/videobuf2-core.h                     |    2 +-
 include/sound/tea575x-tuner.h                      |    4 +
 sound/i2c/other/tea575x-tuner.c                    |  205 +-
 sound/pci/Kconfig                                  |    4 +-
 1671 files changed, 39036 insertions(+), 26499 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-yvu420m.xml
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-subdev-g-edid.xml
 create mode 100644 arch/arm/plat-mxc/devices/platform-imx27-coda.c
 create mode 100644 drivers/media/common/b2c2/Kconfig
 create mode 100644 drivers/media/common/b2c2/Makefile
 rename drivers/media/{dvb => common}/b2c2/flexcop-common.h (100%)
 rename drivers/media/{dvb => common}/b2c2/flexcop-eeprom.c (100%)
 rename drivers/media/{dvb => common}/b2c2/flexcop-fe-tuner.c (100%)
 rename drivers/media/{dvb => common}/b2c2/flexcop-hw-filter.c (100%)
 rename drivers/media/{dvb => common}/b2c2/flexcop-i2c.c (100%)
 rename drivers/media/{dvb => common}/b2c2/flexcop-misc.c (100%)
 rename drivers/media/{dvb => common}/b2c2/flexcop-reg.h (100%)
 rename drivers/media/{dvb => common}/b2c2/flexcop-sram.c (100%)
 rename drivers/media/{dvb => common}/b2c2/flexcop.c (99%)
 rename drivers/media/{dvb => common}/b2c2/flexcop.h (100%)
 rename drivers/media/{dvb => common}/b2c2/flexcop_ibi_value_be.h (100%)
 rename drivers/media/{dvb => common}/b2c2/flexcop_ibi_value_le.h (100%)
 create mode 100644 drivers/media/common/saa7146/Kconfig
 create mode 100644 drivers/media/common/saa7146/Makefile
 rename drivers/media/common/{ => saa7146}/saa7146_core.c (98%)
 rename drivers/media/common/{ => saa7146}/saa7146_fops.c (94%)
 rename drivers/media/common/{ => saa7146}/saa7146_hlp.c (100%)
 rename drivers/media/common/{ => saa7146}/saa7146_i2c.c (100%)
 rename drivers/media/common/{ => saa7146}/saa7146_vbi.c (100%)
 rename drivers/media/common/{ => saa7146}/saa7146_video.c (99%)
 create mode 100644 drivers/media/common/siano/Kconfig
 rename drivers/media/{dvb => common}/siano/Makefile (57%)
 rename drivers/media/{dvb => common}/siano/sms-cards.c (100%)
 rename drivers/media/{dvb => common}/siano/sms-cards.h (100%)
 rename drivers/media/{dvb => common}/siano/smscoreapi.c (100%)
 rename drivers/media/{dvb => common}/siano/smscoreapi.h (100%)
 rename drivers/media/{dvb => common}/siano/smsdvb.c (100%)
 rename drivers/media/{dvb => common}/siano/smsendian.c (100%)
 rename drivers/media/{dvb => common}/siano/smsendian.h (100%)
 rename drivers/media/{dvb => common}/siano/smsir.c (100%)
 rename drivers/media/{dvb => common}/siano/smsir.h (100%)
 create mode 100644 drivers/media/dvb-core/Kconfig
 rename drivers/media/{dvb => }/dvb-core/Makefile (100%)
 rename drivers/media/{dvb => }/dvb-core/demux.h (100%)
 rename drivers/media/{dvb => }/dvb-core/dmxdev.c (99%)
 rename drivers/media/{dvb => }/dvb-core/dmxdev.h (100%)
 rename drivers/media/{dvb/dvb-usb => dvb-core}/dvb-usb-ids.h (99%)
 rename drivers/media/{dvb => }/dvb-core/dvb_ca_en50221.c (100%)
 rename drivers/media/{dvb => }/dvb-core/dvb_ca_en50221.h (100%)
 rename drivers/media/{dvb => }/dvb-core/dvb_demux.c (98%)
 rename drivers/media/{dvb => }/dvb-core/dvb_demux.h (100%)
 rename drivers/media/{dvb => }/dvb-core/dvb_filter.c (100%)
 rename drivers/media/{dvb => }/dvb-core/dvb_filter.h (100%)
 rename drivers/media/{dvb => }/dvb-core/dvb_frontend.c (89%)
 rename drivers/media/{dvb => }/dvb-core/dvb_frontend.h (98%)
 rename drivers/media/{dvb => }/dvb-core/dvb_math.c (100%)
 rename drivers/media/{dvb => }/dvb-core/dvb_math.h (100%)
 rename drivers/media/{dvb => }/dvb-core/dvb_net.c (100%)
 rename drivers/media/{dvb => }/dvb-core/dvb_net.h (100%)
 rename drivers/media/{dvb => }/dvb-core/dvb_ringbuffer.c (100%)
 rename drivers/media/{dvb => }/dvb-core/dvb_ringbuffer.h (100%)
 rename drivers/media/{dvb => }/dvb-core/dvbdev.c (99%)
 rename drivers/media/{dvb => }/dvb-core/dvbdev.h (80%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/Kconfig (83%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/Makefile (92%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/a8293.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/a8293.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/af9013.c (86%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/af9013.h (97%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/af9013_priv.h (98%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/af9033.c (87%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/af9033.h (94%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/af9033_priv.h (92%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/atbm8830.c (99%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/atbm8830.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/atbm8830_priv.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/au8522.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/au8522_common.c (93%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/au8522_decoder.c (98%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/au8522_dig.c (95%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/au8522_priv.h (93%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/bcm3510.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/bcm3510.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/bcm3510_priv.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/bsbe1-d01a.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/bsbe1.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/bsru6.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/cx22700.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/cx22700.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/cx22702.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/cx22702.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/cx24110.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/cx24110.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/cx24113.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/cx24113.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/cx24116.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/cx24116.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/cx24123.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/cx24123.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/cxd2820r.h (92%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/cxd2820r_c.c (89%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/cxd2820r_core.c (70%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/cxd2820r_priv.h (89%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/cxd2820r_t.c (91%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/cxd2820r_t2.c (91%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/dib0070.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/dib0070.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/dib0090.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/dib0090.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/dib3000.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/dib3000mb.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/dib3000mb_priv.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/dib3000mc.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/dib3000mc.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/dib7000m.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/dib7000m.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/dib7000p.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/dib7000p.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/dib8000.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/dib8000.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/dib9000.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/dib9000.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/dibx000_common.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/dibx000_common.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/drxd.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/drxd_firm.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/drxd_firm.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/drxd_hard.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/drxd_map_firm.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/drxk.h (95%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/drxk_hard.c (99%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/drxk_hard.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/drxk_map.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/ds3000.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/ds3000.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/dvb-pll.c (96%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/dvb-pll.h (97%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/dvb_dummy_fe.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/dvb_dummy_fe.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/ec100.c (87%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/ec100.h (95%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/eds1547.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/hd29l2.c (89%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/hd29l2.h (96%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/hd29l2_priv.h (96%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/isl6405.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/isl6405.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/isl6421.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/isl6421.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/isl6423.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/isl6423.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/it913x-fe-priv.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/it913x-fe.c (99%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/it913x-fe.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/itd1000.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/itd1000.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/itd1000_priv.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/ix2505v.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/ix2505v.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/l64781.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/l64781.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/lg2160.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/lg2160.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/lgdt3305.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/lgdt3305.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/lgdt330x.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/lgdt330x.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/lgdt330x_priv.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/lgs8gl5.c (99%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/lgs8gl5.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/lgs8gxx.c (99%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/lgs8gxx.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/lgs8gxx_priv.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/lnbh24.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/lnbp21.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/lnbp21.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/lnbp22.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/lnbp22.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/m88rs2000.c (99%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/m88rs2000.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/mb86a16.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/mb86a16.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/mb86a16_priv.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/mb86a20s.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/mb86a20s.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/mt312.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/mt312.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/mt312_priv.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/mt352.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/mt352.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/mt352_priv.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/nxt200x.c (93%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/nxt200x.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/nxt6000.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/nxt6000.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/nxt6000_priv.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/or51132.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/or51132.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/or51211.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/or51211.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/rtl2830.c (88%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/rtl2830.h (90%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/rtl2830_priv.h (75%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/rtl2832.c (77%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/rtl2832.h (84%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/rtl2832_priv.h (55%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/s5h1409.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/s5h1409.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/s5h1411.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/s5h1411.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/s5h1420.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/s5h1420.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/s5h1420_priv.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/s5h1432.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/s5h1432.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/s921.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/s921.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/si21xx.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/si21xx.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/sp8870.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/sp8870.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/sp887x.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/sp887x.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stb0899_algo.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stb0899_cfg.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stb0899_drv.c (99%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stb0899_drv.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stb0899_priv.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stb0899_reg.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stb6000.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stb6000.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stb6100.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stb6100.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stb6100_cfg.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stb6100_proc.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv0288.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv0288.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv0297.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv0297.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv0299.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv0299.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv0367.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv0367.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv0367_priv.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv0367_regs.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv0900.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv0900_core.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv0900_init.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv0900_priv.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv0900_reg.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv0900_sw.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv090x.c (99%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv090x.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv090x_priv.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv090x_reg.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv6110.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv6110.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv6110x.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv6110x.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv6110x_priv.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/stv6110x_reg.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tda10021.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tda10023.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tda1002x.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tda10048.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tda10048.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tda1004x.c (99%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tda1004x.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tda10071.c (99%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tda10071.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tda10071_priv.h (98%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tda10086.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tda10086.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tda18271c2dd.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tda18271c2dd.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tda18271c2dd_maps.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tda665x.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tda665x.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tda8083.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tda8083.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tda8261.c (86%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tda8261.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tda8261_cfg.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tda826x.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tda826x.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tdhd1.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tua6100.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/tua6100.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/ves1820.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/ves1820.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/ves1x93.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/ves1x93.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/z0194a.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/zl10036.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/zl10036.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/zl10039.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/zl10039.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/zl10353.c (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/zl10353.h (100%)
 rename drivers/media/{dvb/frontends => dvb-frontends}/zl10353_priv.h (100%)
 delete mode 100644 drivers/media/dvb/Kconfig
 delete mode 100644 drivers/media/dvb/Makefile
 delete mode 100644 drivers/media/dvb/b2c2/Kconfig
 delete mode 100644 drivers/media/dvb/b2c2/Makefile
 delete mode 100644 drivers/media/dvb/bt8xx/Kconfig
 delete mode 100644 drivers/media/dvb/bt8xx/Makefile
 delete mode 100644 drivers/media/dvb/dm1105/Makefile
 delete mode 100644 drivers/media/dvb/dvb-usb/Kconfig
 delete mode 100644 drivers/media/dvb/dvb-usb/Makefile
 delete mode 100644 drivers/media/dvb/dvb-usb/af9015.c
 delete mode 100644 drivers/media/dvb/dvb-usb/it913x.c
 delete mode 100644 drivers/media/dvb/dvb-usb/mxl111sf.c
 delete mode 100644 drivers/media/dvb/frontends/ec100_priv.h
 delete mode 100644 drivers/media/dvb/ngene/Kconfig
 delete mode 100644 drivers/media/dvb/pluto2/Makefile
 delete mode 100644 drivers/media/dvb/siano/Kconfig
 delete mode 100644 drivers/media/dvb/ttusb-budget/Makefile
 rename drivers/media/{dvb => }/firewire/Kconfig (100%)
 rename drivers/media/{dvb => }/firewire/Makefile (51%)
 rename drivers/media/{dvb => }/firewire/firedtv-avc.c (100%)
 rename drivers/media/{dvb => }/firewire/firedtv-ci.c (100%)
 rename drivers/media/{dvb => }/firewire/firedtv-dvb.c (100%)
 rename drivers/media/{dvb => }/firewire/firedtv-fe.c (100%)
 rename drivers/media/{dvb => }/firewire/firedtv-fw.c (100%)
 rename drivers/media/{dvb => }/firewire/firedtv-rc.c (100%)
 rename drivers/media/{dvb => }/firewire/firedtv.h (100%)
 create mode 100644 drivers/media/i2c/Kconfig
 create mode 100644 drivers/media/i2c/Makefile
 create mode 100644 drivers/media/i2c/ad9389b.c
 rename drivers/media/{video => i2c}/adp1653.c (99%)
 rename drivers/media/{video => i2c}/adv7170.c (100%)
 rename drivers/media/{video => i2c}/adv7175.c (100%)
 rename drivers/media/{video => i2c}/adv7180.c (100%)
 rename drivers/media/{video => i2c}/adv7183.c (100%)
 rename drivers/media/{video => i2c}/adv7183_regs.h (100%)
 rename drivers/media/{video => i2c}/adv7343.c (100%)
 rename drivers/media/{video => i2c}/adv7343_regs.h (100%)
 rename drivers/media/{video => i2c}/adv7393.c (100%)
 rename drivers/media/{video => i2c}/adv7393_regs.h (100%)
 create mode 100644 drivers/media/i2c/adv7604.c
 rename drivers/media/{video => i2c}/ak881x.c (100%)
 rename drivers/media/{video => i2c}/aptina-pll.c (100%)
 rename drivers/media/{video => i2c}/aptina-pll.h (100%)
 rename drivers/media/{video => i2c}/as3645a.c (99%)
 rename drivers/media/{video => i2c}/bt819.c (100%)
 rename drivers/media/{video => i2c}/bt856.c (100%)
 rename drivers/media/{video => i2c}/bt866.c (100%)
 rename drivers/media/{video => i2c}/btcx-risc.c (100%)
 rename drivers/media/{video => i2c}/btcx-risc.h (100%)
 rename drivers/media/{video => i2c}/cs5345.c (100%)
 rename drivers/media/{video => i2c}/cs53l32a.c (100%)
 rename drivers/media/{video => i2c}/cx2341x.c (100%)
 rename drivers/media/{video => i2c}/cx25840/Kconfig (100%)
 rename drivers/media/{video => i2c}/cx25840/Makefile (80%)
 rename drivers/media/{video => i2c}/cx25840/cx25840-audio.c (100%)
 rename drivers/media/{video => i2c}/cx25840/cx25840-core.c (100%)
 rename drivers/media/{video => i2c}/cx25840/cx25840-core.h (100%)
 rename drivers/media/{video => i2c}/cx25840/cx25840-firmware.c (92%)
 rename drivers/media/{video => i2c}/cx25840/cx25840-ir.c (100%)
 rename drivers/media/{video => i2c}/cx25840/cx25840-vbi.c (98%)
 rename drivers/media/{video => i2c}/ir-kbd-i2c.c (100%)
 rename drivers/media/{video => i2c}/ks0127.c (99%)
 rename drivers/media/{video => i2c}/ks0127.h (100%)
 rename drivers/media/{video => i2c}/m52790.c (100%)
 rename drivers/media/{video => i2c}/m5mols/Kconfig (100%)
 rename drivers/media/{video => i2c}/m5mols/Makefile (100%)
 rename drivers/media/{video => i2c}/m5mols/m5mols.h (98%)
 rename drivers/media/{video => i2c}/m5mols/m5mols_capture.c (100%)
 rename drivers/media/{video => i2c}/m5mols/m5mols_controls.c (99%)
 rename drivers/media/{video => i2c}/m5mols/m5mols_core.c (95%)
 rename drivers/media/{video => i2c}/m5mols/m5mols_reg.h (100%)
 rename drivers/media/{video => i2c}/msp3400-driver.c (98%)
 rename drivers/media/{video => i2c}/msp3400-driver.h (100%)
 rename drivers/media/{video => i2c}/msp3400-kthreads.c (100%)
 rename drivers/media/{video => i2c}/mt9m032.c (99%)
 rename drivers/media/{video => i2c}/mt9p031.c (98%)
 rename drivers/media/{video => i2c}/mt9t001.c (100%)
 rename drivers/media/{video => i2c}/mt9v011.c (100%)
 rename drivers/media/{video => i2c}/mt9v032.c (88%)
 rename drivers/media/{video => i2c}/noon010pc30.c (100%)
 rename drivers/media/{video => i2c}/ov7670.c (100%)
 create mode 100644 drivers/media/i2c/s5k4ecgx.c
 rename drivers/media/{video => i2c}/s5k6aa.c (99%)
 rename drivers/media/{video => i2c}/saa6588.c (100%)
 rename drivers/media/{video => i2c}/saa7110.c (100%)
 rename drivers/media/{video => i2c}/saa7115.c (99%)
 rename drivers/media/{video => i2c}/saa711x_regs.h (100%)
 rename drivers/media/{video => i2c}/saa7127.c (99%)
 rename drivers/media/{video => i2c}/saa717x.c (100%)
 rename drivers/media/{video => i2c}/saa7185.c (100%)
 rename drivers/media/{video => i2c}/saa7191.c (100%)
 rename drivers/media/{video => i2c}/saa7191.h (100%)
 rename drivers/media/{video => i2c}/smiapp-pll.c (99%)
 rename drivers/media/{video => i2c}/smiapp-pll.h (98%)
 rename drivers/media/{video => i2c}/smiapp/Kconfig (100%)
 rename drivers/media/{video => i2c}/smiapp/Makefile (78%)
 rename drivers/media/{video => i2c}/smiapp/smiapp-core.c (98%)
 rename drivers/media/{video => i2c}/smiapp/smiapp-limits.c (99%)
 rename drivers/media/{video => i2c}/smiapp/smiapp-limits.h (99%)
 rename drivers/media/{video => i2c}/smiapp/smiapp-quirk.c (94%)
 rename drivers/media/{video => i2c}/smiapp/smiapp-quirk.h (98%)
 rename drivers/media/{video => i2c}/smiapp/smiapp-reg-defs.h (99%)
 rename drivers/media/{video => i2c}/smiapp/smiapp-reg.h (98%)
 rename drivers/media/{video => i2c}/smiapp/smiapp-regs.c (99%)
 rename drivers/media/{video => i2c}/smiapp/smiapp-regs.h (100%)
 rename drivers/media/{video => i2c}/smiapp/smiapp.h (99%)
 create mode 100644 drivers/media/i2c/soc_camera/Kconfig
 create mode 100644 drivers/media/i2c/soc_camera/Makefile
 rename drivers/media/{video => i2c/soc_camera}/imx074.c (95%)
 rename drivers/media/{video => i2c/soc_camera}/mt9m001.c (97%)
 rename drivers/media/{video => i2c/soc_camera}/mt9m111.c (95%)
 rename drivers/media/{video => i2c/soc_camera}/mt9t031.c (97%)
 rename drivers/media/{video => i2c/soc_camera}/mt9t112.c (98%)
 rename drivers/media/{video => i2c/soc_camera}/mt9v022.c (93%)
 rename drivers/media/{video => i2c/soc_camera}/ov2640.c (98%)
 rename drivers/media/{video => i2c/soc_camera}/ov5642.c (96%)
 rename drivers/media/{video => i2c/soc_camera}/ov6650.c (95%)
 rename drivers/media/{video => i2c/soc_camera}/ov772x.c (81%)
 rename drivers/media/{video => i2c/soc_camera}/ov9640.c (97%)
 rename drivers/media/{video => i2c/soc_camera}/ov9640.h (100%)
 rename drivers/media/{video => i2c/soc_camera}/ov9740.c (97%)
 rename drivers/media/{video => i2c/soc_camera}/rj54n1cb0c.c (98%)
 rename drivers/media/{video => i2c/soc_camera}/tw9910.c (98%)
 rename drivers/media/{video => i2c}/sr030pc30.c (100%)
 rename drivers/media/{video => i2c}/tcm825x.c (99%)
 rename drivers/media/{video => i2c}/tcm825x.h (99%)
 rename drivers/media/{video => i2c}/tda7432.c (100%)
 rename drivers/media/{video => i2c}/tda9840.c (100%)
 rename drivers/media/{video => i2c}/tea6415c.c (99%)
 rename drivers/media/{video => i2c}/tea6415c.h (100%)
 rename drivers/media/{video => i2c}/tea6420.c (100%)
 rename drivers/media/{video => i2c}/tea6420.h (100%)
 rename drivers/media/{video => i2c}/ths7303.c (100%)
 rename drivers/media/{video => i2c}/tlv320aic23b.c (100%)
 rename drivers/media/{video => i2c}/tvaudio.c (99%)
 rename drivers/media/{video => i2c}/tveeprom.c (100%)
 rename drivers/media/{video => i2c}/tvp514x.c (99%)
 rename drivers/media/{video => i2c}/tvp514x_regs.h (99%)
 rename drivers/media/{video => i2c}/tvp5150.c (99%)
 rename drivers/media/{video => i2c}/tvp5150_reg.h (100%)
 rename drivers/media/{video => i2c}/tvp7002.c (100%)
 rename drivers/media/{video => i2c}/tvp7002_reg.h (100%)
 rename drivers/media/{video => i2c}/upd64031a.c (100%)
 rename drivers/media/{video => i2c}/upd64083.c (100%)
 rename drivers/media/{video => i2c}/vp27smpx.c (100%)
 rename drivers/media/{video => i2c}/vpx3220.c (100%)
 rename drivers/media/{video => i2c}/vs6624.c (100%)
 rename drivers/media/{video => i2c}/vs6624_regs.h (100%)
 rename drivers/media/{video => i2c}/wm8739.c (100%)
 rename drivers/media/{video => i2c}/wm8775.c (100%)
 create mode 100644 drivers/media/mmc/Kconfig
 create mode 100644 drivers/media/mmc/Makefile
 create mode 100644 drivers/media/mmc/siano/Kconfig
 create mode 100644 drivers/media/mmc/siano/Makefile
 rename drivers/media/{dvb => mmc}/siano/smssdio.c (100%)
 create mode 100644 drivers/media/parport/Kconfig
 create mode 100644 drivers/media/parport/Makefile
 rename drivers/media/{video => parport}/bw-qcam.c (100%)
 rename drivers/media/{video => parport}/c-qcam.c (100%)
 rename drivers/media/{video => parport}/pms.c (100%)
 rename drivers/media/{video => parport}/w9966.c (100%)
 create mode 100644 drivers/media/pci/Kconfig
 create mode 100644 drivers/media/pci/Makefile
 create mode 100644 drivers/media/pci/b2c2/Kconfig
 create mode 100644 drivers/media/pci/b2c2/Makefile
 rename drivers/media/{dvb => pci}/b2c2/flexcop-dma.c (100%)
 rename drivers/media/{dvb => pci}/b2c2/flexcop-pci.c (100%)
 create mode 100644 drivers/media/pci/bt8xx/Kconfig
 create mode 100644 drivers/media/pci/bt8xx/Makefile
 rename drivers/media/{video => pci}/bt8xx/bt848.h (100%)
 rename drivers/media/{dvb => pci}/bt8xx/bt878.c (100%)
 rename drivers/media/{dvb => pci}/bt8xx/bt878.h (100%)
 rename drivers/media/{video => pci}/bt8xx/bttv-audio-hook.c (100%)
 rename drivers/media/{video => pci}/bt8xx/bttv-audio-hook.h (100%)
 rename drivers/media/{video => pci}/bt8xx/bttv-cards.c (100%)
 rename drivers/media/{video => pci}/bt8xx/bttv-driver.c (99%)
 rename drivers/media/{video => pci}/bt8xx/bttv-gpio.c (100%)
 rename drivers/media/{video => pci}/bt8xx/bttv-i2c.c (100%)
 rename drivers/media/{video => pci}/bt8xx/bttv-if.c (100%)
 rename drivers/media/{video => pci}/bt8xx/bttv-input.c (100%)
 rename drivers/media/{video => pci}/bt8xx/bttv-risc.c (100%)
 rename drivers/media/{video => pci}/bt8xx/bttv-vbi.c (100%)
 rename drivers/media/{video => pci}/bt8xx/bttv.h (100%)
 rename drivers/media/{video => pci}/bt8xx/bttvp.h (100%)
 rename drivers/media/{dvb => pci}/bt8xx/dst.c (100%)
 rename drivers/media/{dvb => pci}/bt8xx/dst_ca.c (99%)
 rename drivers/media/{dvb => pci}/bt8xx/dst_ca.h (100%)
 rename drivers/media/{dvb => pci}/bt8xx/dst_common.h (100%)
 rename drivers/media/{dvb => pci}/bt8xx/dst_priv.h (100%)
 rename drivers/media/{dvb => pci}/bt8xx/dvb-bt8xx.c (100%)
 rename drivers/media/{dvb => pci}/bt8xx/dvb-bt8xx.h (100%)
 rename drivers/media/{video => pci}/cx18/Kconfig (68%)
 rename drivers/media/{video => pci}/cx18/Makefile (78%)
 rename drivers/media/{video => pci}/cx18/cx18-alsa-main.c (100%)
 rename drivers/media/{video => pci}/cx18/cx18-alsa-mixer.c (100%)
 rename drivers/media/{video => pci}/cx18/cx18-alsa-mixer.h (100%)
 rename drivers/media/{video => pci}/cx18/cx18-alsa-pcm.c (100%)
 rename drivers/media/{video => pci}/cx18/cx18-alsa-pcm.h (100%)
 rename drivers/media/{video => pci}/cx18/cx18-alsa.h (100%)
 rename drivers/media/{video => pci}/cx18/cx18-audio.c (100%)
 rename drivers/media/{video => pci}/cx18/cx18-audio.h (100%)
 rename drivers/media/{video => pci}/cx18/cx18-av-audio.c (100%)
 rename drivers/media/{video => pci}/cx18/cx18-av-core.c (100%)
 rename drivers/media/{video => pci}/cx18/cx18-av-core.h (100%)
 rename drivers/media/{video => pci}/cx18/cx18-av-firmware.c (99%)
 rename drivers/media/{video => pci}/cx18/cx18-av-vbi.c (99%)
 rename drivers/media/{video => pci}/cx18/cx18-cards.c (100%)
 rename drivers/media/{video => pci}/cx18/cx18-cards.h (100%)
 rename drivers/media/{video => pci}/cx18/cx18-controls.c (100%)
 rename drivers/media/{video => pci}/cx18/cx18-controls.h (100%)
 rename drivers/media/{video => pci}/cx18/cx18-driver.c (99%)
 rename drivers/media/{video => pci}/cx18/cx18-driver.h (100%)
 rename drivers/media/{video => pci}/cx18/cx18-dvb.c (99%)
 rename drivers/media/{video => pci}/cx18/cx18-dvb.h (100%)
 rename drivers/media/{video => pci}/cx18/cx18-fileops.c (100%)
 rename drivers/media/{video => pci}/cx18/cx18-fileops.h (100%)
 rename drivers/media/{video => pci}/cx18/cx18-firmware.c (98%)
 rename drivers/media/{video => pci}/cx18/cx18-firmware.h (100%)
 rename drivers/media/{video => pci}/cx18/cx18-gpio.c (100%)
 rename drivers/media/{video => pci}/cx18/cx18-gpio.h (100%)
 rename drivers/media/{video => pci}/cx18/cx18-i2c.c (100%)
 rename drivers/media/{video => pci}/cx18/cx18-i2c.h (100%)
 rename drivers/media/{video => pci}/cx18/cx18-io.c (100%)
 rename drivers/media/{video => pci}/cx18/cx18-io.h (100%)
 rename drivers/media/{video => pci}/cx18/cx18-ioctl.c (99%)
 rename drivers/media/{video => pci}/cx18/cx18-ioctl.h (100%)
 rename drivers/media/{video => pci}/cx18/cx18-irq.c (100%)
 rename drivers/media/{video => pci}/cx18/cx18-irq.h (100%)
 rename drivers/media/{video => pci}/cx18/cx18-mailbox.c (100%)
 rename drivers/media/{video => pci}/cx18/cx18-mailbox.h (100%)
 rename drivers/media/{video => pci}/cx18/cx18-queue.c (100%)
 rename drivers/media/{video => pci}/cx18/cx18-queue.h (100%)
 rename drivers/media/{video => pci}/cx18/cx18-scb.c (100%)
 rename drivers/media/{video => pci}/cx18/cx18-scb.h (100%)
 rename drivers/media/{video => pci}/cx18/cx18-streams.c (98%)
 rename drivers/media/{video => pci}/cx18/cx18-streams.h (100%)
 rename drivers/media/{video => pci}/cx18/cx18-vbi.c (100%)
 rename drivers/media/{video => pci}/cx18/cx18-vbi.h (100%)
 rename drivers/media/{video => pci}/cx18/cx18-version.h (100%)
 rename drivers/media/{video => pci}/cx18/cx18-video.c (100%)
 rename drivers/media/{video => pci}/cx18/cx18-video.h (100%)
 rename drivers/media/{video => pci}/cx18/cx23418.h (100%)
 create mode 100644 drivers/media/pci/cx23885/Kconfig
 rename drivers/media/{video => pci}/cx23885/Makefile (72%)
 rename drivers/media/{video => pci}/cx23885/altera-ci.c (99%)
 rename drivers/media/{video => pci}/cx23885/altera-ci.h (100%)
 rename drivers/media/{video => pci}/cx23885/cimax2.c (100%)
 rename drivers/media/{video => pci}/cx23885/cimax2.h (100%)
 rename drivers/media/{video => pci}/cx23885/cx23885-417.c (99%)
 rename drivers/media/{video => pci}/cx23885/cx23885-alsa.c (100%)
 rename drivers/media/{video => pci}/cx23885/cx23885-av.c (100%)
 rename drivers/media/{video => pci}/cx23885/cx23885-av.h (100%)
 rename drivers/media/{video => pci}/cx23885/cx23885-cards.c (98%)
 rename drivers/media/{video => pci}/cx23885/cx23885-core.c (100%)
 rename drivers/media/{video => pci}/cx23885/cx23885-dvb.c (95%)
 rename drivers/media/{video => pci}/cx23885/cx23885-f300.c (100%)
 rename drivers/media/{video => pci}/cx23885/cx23885-f300.h (100%)
 rename drivers/media/{video => pci}/cx23885/cx23885-i2c.c (100%)
 rename drivers/media/{video => pci}/cx23885/cx23885-input.c (96%)
 rename drivers/media/{video => pci}/cx23885/cx23885-input.h (100%)
 rename drivers/media/{video => pci}/cx23885/cx23885-ioctl.c (100%)
 rename drivers/media/{video => pci}/cx23885/cx23885-ioctl.h (100%)
 rename drivers/media/{video => pci}/cx23885/cx23885-ir.c (100%)
 rename drivers/media/{video => pci}/cx23885/cx23885-ir.h (100%)
 rename drivers/media/{video => pci}/cx23885/cx23885-reg.h (100%)
 rename drivers/media/{video => pci}/cx23885/cx23885-vbi.c (100%)
 rename drivers/media/{video => pci}/cx23885/cx23885-video.c (99%)
 rename drivers/media/{video => pci}/cx23885/cx23885.h (99%)
 rename drivers/media/{video => pci}/cx23885/cx23888-ir.c (100%)
 rename drivers/media/{video => pci}/cx23885/cx23888-ir.h (100%)
 rename drivers/media/{video => pci}/cx23885/netup-eeprom.c (100%)
 rename drivers/media/{video => pci}/cx23885/netup-eeprom.h (100%)
 rename drivers/media/{video => pci}/cx23885/netup-init.c (100%)
 rename drivers/media/{video => pci}/cx23885/netup-init.h (100%)
 rename drivers/media/{video => pci}/cx25821/Kconfig (100%)
 rename drivers/media/{video => pci}/cx25821/Makefile (67%)
 rename drivers/media/{video => pci}/cx25821/cx25821-alsa.c (100%)
 rename drivers/media/{video => pci}/cx25821/cx25821-audio-upstream.c (100%)
 rename drivers/media/{video => pci}/cx25821/cx25821-audio-upstream.h (100%)
 rename drivers/media/{video => pci}/cx25821/cx25821-audio.h (100%)
 rename drivers/media/{video => pci}/cx25821/cx25821-biffuncs.h (100%)
 rename drivers/media/{video => pci}/cx25821/cx25821-cards.c (100%)
 rename drivers/media/{video => pci}/cx25821/cx25821-core.c (100%)
 rename drivers/media/{video => pci}/cx25821/cx25821-gpio.c (100%)
 rename drivers/media/{video => pci}/cx25821/cx25821-i2c.c (100%)
 rename drivers/media/{video => pci}/cx25821/cx25821-medusa-defines.h (100%)
 rename drivers/media/{video => pci}/cx25821/cx25821-medusa-reg.h (100%)
 rename drivers/media/{video => pci}/cx25821/cx25821-medusa-video.c (100%)
 rename drivers/media/{video => pci}/cx25821/cx25821-medusa-video.h (100%)
 rename drivers/media/{video => pci}/cx25821/cx25821-reg.h (100%)
 rename drivers/media/{video => pci}/cx25821/cx25821-sram.h (100%)
 rename drivers/media/{video => pci}/cx25821/cx25821-video-upstream-ch2.c (100%)
 rename drivers/media/{video => pci}/cx25821/cx25821-video-upstream-ch2.h (100%)
 rename drivers/media/{video => pci}/cx25821/cx25821-video-upstream.c (100%)
 rename drivers/media/{video => pci}/cx25821/cx25821-video-upstream.h (100%)
 rename drivers/media/{video => pci}/cx25821/cx25821-video.c (99%)
 rename drivers/media/{video => pci}/cx25821/cx25821-video.h (99%)
 rename drivers/media/{video => pci}/cx25821/cx25821.h (100%)
 rename drivers/media/{video => pci}/cx88/Kconfig (70%)
 rename drivers/media/{video => pci}/cx88/Makefile (73%)
 rename drivers/media/{video => pci}/cx88/cx88-alsa.c (99%)
 rename drivers/media/{video => pci}/cx88/cx88-blackbird.c (99%)
 rename drivers/media/{video => pci}/cx88/cx88-cards.c (99%)
 rename drivers/media/{video => pci}/cx88/cx88-core.c (99%)
 rename drivers/media/{video => pci}/cx88/cx88-dsp.c (100%)
 rename drivers/media/{video => pci}/cx88/cx88-dvb.c (99%)
 rename drivers/media/{video => pci}/cx88/cx88-i2c.c (100%)
 rename drivers/media/{video => pci}/cx88/cx88-input.c (100%)
 rename drivers/media/{video => pci}/cx88/cx88-mpeg.c (100%)
 rename drivers/media/{video => pci}/cx88/cx88-reg.h (100%)
 rename drivers/media/{video => pci}/cx88/cx88-tvaudio.c (100%)
 rename drivers/media/{video => pci}/cx88/cx88-vbi.c (100%)
 rename drivers/media/{video => pci}/cx88/cx88-video.c (99%)
 rename drivers/media/{video => pci}/cx88/cx88-vp3054-i2c.c (100%)
 rename drivers/media/{video => pci}/cx88/cx88-vp3054-i2c.h (100%)
 rename drivers/media/{video => pci}/cx88/cx88.h (99%)
 rename drivers/media/{dvb => pci}/ddbridge/Kconfig (60%)
 rename drivers/media/{dvb => pci}/ddbridge/Makefile (61%)
 rename drivers/media/{dvb => pci}/ddbridge/ddbridge-core.c (99%)
 rename drivers/media/{dvb => pci}/ddbridge/ddbridge-regs.h (100%)
 rename drivers/media/{dvb => pci}/ddbridge/ddbridge.h (100%)
 rename drivers/media/{dvb => pci}/dm1105/Kconfig (57%)
 create mode 100644 drivers/media/pci/dm1105/Makefile
 rename drivers/media/{dvb => pci}/dm1105/dm1105.c (100%)
 rename drivers/media/{video => pci}/ivtv/Kconfig (67%)
 rename drivers/media/{video => pci}/ivtv/Makefile (53%)
 create mode 100644 drivers/media/pci/ivtv/ivtv-alsa-main.c
 create mode 100644 drivers/media/pci/ivtv/ivtv-alsa-mixer.c
 create mode 100644 drivers/media/pci/ivtv/ivtv-alsa-mixer.h
 create mode 100644 drivers/media/pci/ivtv/ivtv-alsa-pcm.c
 create mode 100644 drivers/media/pci/ivtv/ivtv-alsa-pcm.h
 create mode 100644 drivers/media/pci/ivtv/ivtv-alsa.h
 rename drivers/media/{video => pci}/ivtv/ivtv-cards.c (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-cards.h (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-controls.c (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-controls.h (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-driver.c (97%)
 rename drivers/media/{video => pci}/ivtv/ivtv-driver.h (98%)
 rename drivers/media/{video => pci}/ivtv/ivtv-fileops.c (96%)
 rename drivers/media/{video => pci}/ivtv/ivtv-fileops.h (94%)
 rename drivers/media/{video => pci}/ivtv/ivtv-firmware.c (98%)
 rename drivers/media/{video => pci}/ivtv/ivtv-firmware.h (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-gpio.c (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-gpio.h (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-i2c.c (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-i2c.h (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-ioctl.c (95%)
 rename drivers/media/{video => pci}/ivtv/ivtv-ioctl.h (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-irq.c (95%)
 rename drivers/media/{video => pci}/ivtv/ivtv-irq.h (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-mailbox.c (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-mailbox.h (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-queue.c (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-queue.h (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-routing.c (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-routing.h (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-streams.c (95%)
 rename drivers/media/{video => pci}/ivtv/ivtv-streams.h (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-udma.c (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-udma.h (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-vbi.c (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-vbi.h (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-version.h (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-yuv.c (100%)
 rename drivers/media/{video => pci}/ivtv/ivtv-yuv.h (100%)
 rename drivers/media/{video => pci}/ivtv/ivtvfb.c (100%)
 rename drivers/media/{dvb => pci}/mantis/Kconfig (62%)
 rename drivers/media/{dvb => pci}/mantis/Makefile (88%)
 rename drivers/media/{dvb => pci}/mantis/hopper_cards.c (100%)
 rename drivers/media/{dvb => pci}/mantis/hopper_vp3028.c (100%)
 rename drivers/media/{dvb => pci}/mantis/hopper_vp3028.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_ca.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_ca.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_cards.c (99%)
 rename drivers/media/{dvb => pci}/mantis/mantis_common.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_core.c (99%)
 rename drivers/media/{dvb => pci}/mantis/mantis_core.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_dma.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_dma.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_dvb.c (98%)
 rename drivers/media/{dvb => pci}/mantis/mantis_dvb.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_evm.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_hif.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_hif.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_i2c.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_i2c.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_input.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_ioc.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_ioc.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_link.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_pci.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_pci.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_pcmcia.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_reg.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_uart.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_uart.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_vp1033.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_vp1033.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_vp1034.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_vp1034.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_vp1041.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_vp1041.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_vp2033.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_vp2033.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_vp2040.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_vp2040.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_vp3028.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_vp3028.h (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_vp3030.c (100%)
 rename drivers/media/{dvb => pci}/mantis/mantis_vp3030.h (100%)
 create mode 100644 drivers/media/pci/meye/Kconfig
 create mode 100644 drivers/media/pci/meye/Makefile
 rename drivers/media/{video => pci/meye}/meye.c (100%)
 rename drivers/media/{video => pci/meye}/meye.h (100%)
 create mode 100644 drivers/media/pci/ngene/Kconfig
 rename drivers/media/{dvb => pci}/ngene/Makefile (63%)
 rename drivers/media/{dvb => pci}/ngene/ngene-cards.c (71%)
 rename drivers/media/{dvb => pci}/ngene/ngene-core.c (98%)
 rename drivers/media/{dvb => pci}/ngene/ngene-dvb.c (100%)
 rename drivers/media/{dvb => pci}/ngene/ngene-i2c.c (100%)
 rename drivers/media/{dvb => pci}/ngene/ngene.h (100%)
 rename drivers/media/{dvb => pci}/pluto2/Kconfig (100%)
 create mode 100644 drivers/media/pci/pluto2/Makefile
 rename drivers/media/{dvb => pci}/pluto2/pluto2.c (100%)
 rename drivers/media/{dvb => pci}/pt1/Kconfig (100%)
 rename drivers/media/{dvb => pci}/pt1/Makefile (56%)
 rename drivers/media/{dvb => pci}/pt1/pt1.c (100%)
 rename drivers/media/{dvb => pci}/pt1/va1j5jf8007s.c (98%)
 rename drivers/media/{dvb => pci}/pt1/va1j5jf8007s.h (100%)
 rename drivers/media/{dvb => pci}/pt1/va1j5jf8007t.c (100%)
 rename drivers/media/{dvb => pci}/pt1/va1j5jf8007t.h (100%)
 rename drivers/media/{video => pci}/saa7134/Kconfig (56%)
 rename drivers/media/{video => pci}/saa7134/Makefile (54%)
 rename drivers/media/{video => pci}/saa7134/saa6752hs.c (100%)
 rename drivers/media/{video => pci}/saa7134/saa7134-alsa.c (100%)
 rename drivers/media/{video => pci}/saa7134/saa7134-cards.c (100%)
 rename drivers/media/{video => pci}/saa7134/saa7134-core.c (100%)
 rename drivers/media/{video => pci}/saa7134/saa7134-dvb.c (99%)
 rename drivers/media/{video => pci}/saa7134/saa7134-empress.c (100%)
 rename drivers/media/{video => pci}/saa7134/saa7134-i2c.c (100%)
 rename drivers/media/{video => pci}/saa7134/saa7134-input.c (99%)
 rename drivers/media/{video => pci}/saa7134/saa7134-reg.h (100%)
 rename drivers/media/{video => pci}/saa7134/saa7134-ts.c (100%)
 rename drivers/media/{video => pci}/saa7134/saa7134-tvaudio.c (100%)
 rename drivers/media/{video => pci}/saa7134/saa7134-vbi.c (100%)
 rename drivers/media/{video => pci}/saa7134/saa7134-video.c (98%)
 rename drivers/media/{video => pci}/saa7134/saa7134.h (99%)
 create mode 100644 drivers/media/pci/saa7146/Kconfig
 create mode 100644 drivers/media/pci/saa7146/Makefile
 rename drivers/media/{video => pci/saa7146}/hexium_gemini.c (100%)
 rename drivers/media/{video => pci/saa7146}/hexium_orion.c (100%)
 rename drivers/media/{video => pci/saa7146}/mxb.c (99%)
 rename drivers/media/{video => pci}/saa7164/Kconfig (62%)
 rename drivers/media/{video => pci}/saa7164/Makefile (57%)
 rename drivers/media/{video => pci}/saa7164/saa7164-api.c (98%)
 rename drivers/media/{video => pci}/saa7164/saa7164-buffer.c (100%)
 rename drivers/media/{video => pci}/saa7164/saa7164-bus.c (100%)
 rename drivers/media/{video => pci}/saa7164/saa7164-cards.c (100%)
 rename drivers/media/{video => pci}/saa7164/saa7164-cmd.c (100%)
 rename drivers/media/{video => pci}/saa7164/saa7164-core.c (96%)
 rename drivers/media/{video => pci}/saa7164/saa7164-dvb.c (100%)
 rename drivers/media/{video => pci}/saa7164/saa7164-encoder.c (100%)
 rename drivers/media/{video => pci}/saa7164/saa7164-fw.c (100%)
 rename drivers/media/{video => pci}/saa7164/saa7164-i2c.c (100%)
 rename drivers/media/{video => pci}/saa7164/saa7164-reg.h (100%)
 rename drivers/media/{video => pci}/saa7164/saa7164-types.h (100%)
 rename drivers/media/{video => pci}/saa7164/saa7164-vbi.c (100%)
 rename drivers/media/{video => pci}/saa7164/saa7164.h (99%)
 create mode 100644 drivers/media/pci/sta2x11/Kconfig
 create mode 100644 drivers/media/pci/sta2x11/Makefile
 rename drivers/media/{video => pci/sta2x11}/sta2x11_vip.c (100%)
 rename drivers/media/{video => pci/sta2x11}/sta2x11_vip.h (100%)
 rename drivers/media/{dvb => pci}/ttpci/Kconfig (66%)
 rename drivers/media/{dvb => pci}/ttpci/Makefile (82%)
 rename drivers/media/{dvb => pci}/ttpci/av7110.c (100%)
 rename drivers/media/{dvb => pci}/ttpci/av7110.h (100%)
 rename drivers/media/{dvb => pci}/ttpci/av7110_av.c (100%)
 rename drivers/media/{dvb => pci}/ttpci/av7110_av.h (100%)
 rename drivers/media/{dvb => pci}/ttpci/av7110_ca.c (100%)
 rename drivers/media/{dvb => pci}/ttpci/av7110_ca.h (100%)
 rename drivers/media/{dvb => pci}/ttpci/av7110_hw.c (100%)
 rename drivers/media/{dvb => pci}/ttpci/av7110_hw.h (100%)
 rename drivers/media/{dvb => pci}/ttpci/av7110_ipack.c (100%)
 rename drivers/media/{dvb => pci}/ttpci/av7110_ipack.h (100%)
 rename drivers/media/{dvb => pci}/ttpci/av7110_ir.c (100%)
 rename drivers/media/{dvb => pci}/ttpci/av7110_v4l.c (99%)
 rename drivers/media/{dvb => pci}/ttpci/budget-av.c (100%)
 rename drivers/media/{dvb => pci}/ttpci/budget-ci.c (100%)
 rename drivers/media/{dvb => pci}/ttpci/budget-core.c (100%)
 rename drivers/media/{dvb => pci}/ttpci/budget-patch.c (100%)
 rename drivers/media/{dvb => pci}/ttpci/budget.c (91%)
 rename drivers/media/{dvb => pci}/ttpci/budget.h (100%)
 rename drivers/media/{dvb => pci}/ttpci/ttpci-eeprom.c (100%)
 rename drivers/media/{dvb => pci}/ttpci/ttpci-eeprom.h (100%)
 rename drivers/media/{video => pci}/zoran/Kconfig (71%)
 rename drivers/media/{video => pci}/zoran/Makefile (100%)
 rename drivers/media/{video => pci}/zoran/videocodec.c (100%)
 rename drivers/media/{video => pci}/zoran/videocodec.h (100%)
 rename drivers/media/{video => pci}/zoran/zoran.h (100%)
 rename drivers/media/{video => pci}/zoran/zoran_card.c (99%)
 rename drivers/media/{video => pci}/zoran/zoran_card.h (100%)
 rename drivers/media/{video => pci}/zoran/zoran_device.c (100%)
 rename drivers/media/{video => pci}/zoran/zoran_device.h (100%)
 rename drivers/media/{video => pci}/zoran/zoran_driver.c (99%)
 rename drivers/media/{video => pci}/zoran/zoran_procfs.c (100%)
 rename drivers/media/{video => pci}/zoran/zoran_procfs.h (100%)
 rename drivers/media/{video => pci}/zoran/zr36016.c (100%)
 rename drivers/media/{video => pci}/zoran/zr36016.h (100%)
 rename drivers/media/{video => pci}/zoran/zr36050.c (100%)
 rename drivers/media/{video => pci}/zoran/zr36050.h (100%)
 rename drivers/media/{video => pci}/zoran/zr36057.h (100%)
 rename drivers/media/{video => pci}/zoran/zr36060.c (100%)
 rename drivers/media/{video => pci}/zoran/zr36060.h (100%)
 create mode 100644 drivers/media/platform/Kconfig
 create mode 100644 drivers/media/platform/Makefile
 rename drivers/media/{video => platform}/arv.c (100%)
 rename drivers/media/{video => platform}/blackfin/Kconfig (100%)
 rename drivers/media/{video => platform}/blackfin/Makefile (100%)
 rename drivers/media/{video => platform}/blackfin/bfin_capture.c (98%)
 rename drivers/media/{video => platform}/blackfin/ppi.c (100%)
 create mode 100644 drivers/media/platform/coda.c
 create mode 100644 drivers/media/platform/coda.h
 rename drivers/media/{video => platform}/davinci/Kconfig (97%)
 rename drivers/media/{video => platform}/davinci/Makefile (100%)
 rename drivers/media/{video => platform}/davinci/ccdc_hw_device.h (100%)
 rename drivers/media/{video => platform}/davinci/dm355_ccdc.c (99%)
 rename drivers/media/{video => platform}/davinci/dm355_ccdc_regs.h (100%)
 rename drivers/media/{video => platform}/davinci/dm644x_ccdc.c (99%)
 rename drivers/media/{video => platform}/davinci/dm644x_ccdc_regs.h (100%)
 rename drivers/media/{video => platform}/davinci/isif.c (99%)
 rename drivers/media/{video => platform}/davinci/isif_regs.h (100%)
 rename drivers/media/{video => platform}/davinci/vpbe.c (100%)
 rename drivers/media/{video => platform}/davinci/vpbe_display.c (98%)
 rename drivers/media/{video => platform}/davinci/vpbe_osd.c (100%)
 rename drivers/media/{video => platform}/davinci/vpbe_osd_regs.h (100%)
 rename drivers/media/{video => platform}/davinci/vpbe_venc.c (100%)
 rename drivers/media/{video => platform}/davinci/vpbe_venc_regs.h (100%)
 rename drivers/media/{video => platform}/davinci/vpfe_capture.c (99%)
 rename drivers/media/{video => platform}/davinci/vpif.c (96%)
 rename drivers/media/{video => platform}/davinci/vpif.h (99%)
 rename drivers/media/{video => platform}/davinci/vpif_capture.c (95%)
 rename drivers/media/{video => platform}/davinci/vpif_capture.h (98%)
 rename drivers/media/{video => platform}/davinci/vpif_display.c (94%)
 rename drivers/media/{video => platform}/davinci/vpif_display.h (98%)
 rename drivers/media/{video => platform}/davinci/vpss.c (99%)
 create mode 100644 drivers/media/platform/exynos-gsc/Makefile
 create mode 100644 drivers/media/platform/exynos-gsc/gsc-core.c
 create mode 100644 drivers/media/platform/exynos-gsc/gsc-core.h
 create mode 100644 drivers/media/platform/exynos-gsc/gsc-m2m.c
 create mode 100644 drivers/media/platform/exynos-gsc/gsc-regs.c
 create mode 100644 drivers/media/platform/exynos-gsc/gsc-regs.h
 rename drivers/media/{video => platform}/fsl-viu.c (98%)
 rename drivers/media/{video => platform}/indycam.c (100%)
 rename drivers/media/{video => platform}/indycam.h (100%)
 create mode 100644 drivers/media/platform/m2m-deinterlace.c
 rename drivers/media/{video => platform}/marvell-ccic/Kconfig (100%)
 rename drivers/media/{video => platform}/marvell-ccic/Makefile (100%)
 rename drivers/media/{video => platform}/marvell-ccic/cafe-driver.c (100%)
 rename drivers/media/{video => platform}/marvell-ccic/mcam-core.c (100%)
 rename drivers/media/{video => platform}/marvell-ccic/mcam-core.h (100%)
 rename drivers/media/{video => platform}/marvell-ccic/mmp-driver.c (100%)
 rename drivers/media/{video => platform}/mem2mem_testdev.c (97%)
 rename drivers/media/{video => platform}/mx2_emmaprp.c (94%)
 rename drivers/media/{video => platform}/omap/Kconfig (100%)
 rename drivers/media/{video => platform}/omap/Makefile (81%)
 rename drivers/media/{video => platform}/omap/omap_vout.c (99%)
 rename drivers/media/{video => platform}/omap/omap_vout_vrfb.c (100%)
 rename drivers/media/{video => platform}/omap/omap_vout_vrfb.h (100%)
 rename drivers/media/{video => platform}/omap/omap_voutdef.h (100%)
 rename drivers/media/{video => platform}/omap/omap_voutlib.c (100%)
 rename drivers/media/{video => platform}/omap/omap_voutlib.h (100%)
 rename drivers/media/{video => platform}/omap24xxcam-dma.c (99%)
 rename drivers/media/{video => platform}/omap24xxcam.c (99%)
 rename drivers/media/{video => platform}/omap24xxcam.h (99%)
 rename drivers/media/{video => platform}/omap3isp/Makefile (100%)
 rename drivers/media/{video => platform}/omap3isp/cfa_coef_table.h (91%)
 rename drivers/media/{video => platform}/omap3isp/gamma_table.h (100%)
 rename drivers/media/{video => platform}/omap3isp/isp.c (98%)
 rename drivers/media/{video => platform}/omap3isp/isp.h (97%)
 rename drivers/media/{video => platform}/omap3isp/ispccdc.c (93%)
 rename drivers/media/{video => platform}/omap3isp/ispccdc.h (83%)
 rename drivers/media/{video => platform}/omap3isp/ispccp2.c (100%)
 rename drivers/media/{video => platform}/omap3isp/ispccp2.h (100%)
 rename drivers/media/{video => platform}/omap3isp/ispcsi2.c (98%)
 rename drivers/media/{video => platform}/omap3isp/ispcsi2.h (100%)
 rename drivers/media/{video => platform}/omap3isp/ispcsiphy.c (100%)
 rename drivers/media/{video => platform}/omap3isp/ispcsiphy.h (100%)
 rename drivers/media/{video => platform}/omap3isp/isph3a.h (100%)
 rename drivers/media/{video => platform}/omap3isp/isph3a_aewb.c (96%)
 rename drivers/media/{video => platform}/omap3isp/isph3a_af.c (96%)
 rename drivers/media/{video => platform}/omap3isp/isphist.c (98%)
 rename drivers/media/{video => platform}/omap3isp/isphist.h (100%)
 rename drivers/media/{video => platform}/omap3isp/isppreview.c (89%)
 rename drivers/media/{video => platform}/omap3isp/isppreview.h (99%)
 rename drivers/media/{video => platform}/omap3isp/ispqueue.c (98%)
 rename drivers/media/{video => platform}/omap3isp/ispqueue.h (100%)
 rename drivers/media/{video => platform}/omap3isp/ispreg.h (100%)
 rename drivers/media/{video => platform}/omap3isp/ispresizer.c (99%)
 rename drivers/media/{video => platform}/omap3isp/ispresizer.h (100%)
 rename drivers/media/{video => platform}/omap3isp/ispstat.c (99%)
 rename drivers/media/{video => platform}/omap3isp/ispstat.h (97%)
 rename drivers/media/{video => platform}/omap3isp/ispvideo.c (96%)
 rename drivers/media/{video => platform}/omap3isp/ispvideo.h (97%)
 rename drivers/media/{video => platform}/omap3isp/luma_enhance_table.h (100%)
 rename drivers/media/{video => platform}/omap3isp/noise_filter_table.h (100%)
 rename drivers/media/{video => platform}/s5p-fimc/Kconfig (96%)
 rename drivers/media/{video => platform}/s5p-fimc/Makefile (100%)
 rename drivers/media/{video => platform}/s5p-fimc/fimc-capture.c (97%)
 rename drivers/media/{video => platform}/s5p-fimc/fimc-core.c (100%)
 rename drivers/media/{video => platform}/s5p-fimc/fimc-core.h (99%)
 rename drivers/media/{video => platform}/s5p-fimc/fimc-lite-reg.c (97%)
 rename drivers/media/{video => platform}/s5p-fimc/fimc-lite-reg.h (100%)
 rename drivers/media/{video => platform}/s5p-fimc/fimc-lite.c (97%)
 rename drivers/media/{video => platform}/s5p-fimc/fimc-lite.h (97%)
 rename drivers/media/{video => platform}/s5p-fimc/fimc-m2m.c (95%)
 rename drivers/media/{video => platform}/s5p-fimc/fimc-mdevice.c (92%)
 rename drivers/media/{video => platform}/s5p-fimc/fimc-mdevice.h (83%)
 rename drivers/media/{video => platform}/s5p-fimc/fimc-reg.c (99%)
 rename drivers/media/{video => platform}/s5p-fimc/fimc-reg.h (100%)
 rename drivers/media/{video => platform}/s5p-fimc/mipi-csis.c (82%)
 rename drivers/media/{video => platform}/s5p-fimc/mipi-csis.h (100%)
 rename drivers/media/{video => platform}/s5p-g2d/Makefile (100%)
 rename drivers/media/{video => platform}/s5p-g2d/g2d-hw.c (100%)
 rename drivers/media/{video => platform}/s5p-g2d/g2d-regs.h (100%)
 rename drivers/media/{video => platform}/s5p-g2d/g2d.c (96%)
 rename drivers/media/{video => platform}/s5p-g2d/g2d.h (100%)
 rename drivers/media/{video => platform}/s5p-jpeg/Makefile (100%)
 rename drivers/media/{video => platform}/s5p-jpeg/jpeg-core.c (98%)
 rename drivers/media/{video => platform}/s5p-jpeg/jpeg-core.h (98%)
 rename drivers/media/{video => platform}/s5p-jpeg/jpeg-hw.h (99%)
 rename drivers/media/{video => platform}/s5p-jpeg/jpeg-regs.h (98%)
 rename drivers/media/{video => platform}/s5p-mfc/Makefile (100%)
 rename drivers/media/{video => platform}/s5p-mfc/regs-mfc.h (100%)
 rename drivers/media/{video => platform}/s5p-mfc/s5p_mfc.c (93%)
 rename drivers/media/{video => platform}/s5p-mfc/s5p_mfc_cmd.c (98%)
 rename drivers/media/{video => platform}/s5p-mfc/s5p_mfc_cmd.h (93%)
 rename drivers/media/{video => platform}/s5p-mfc/s5p_mfc_common.h (98%)
 rename drivers/media/{video => platform}/s5p-mfc/s5p_mfc_ctrl.c (95%)
 rename drivers/media/{video => platform}/s5p-mfc/s5p_mfc_ctrl.h (93%)
 rename drivers/media/{video => platform}/s5p-mfc/s5p_mfc_debug.h (95%)
 rename drivers/media/{video => platform}/s5p-mfc/s5p_mfc_dec.c (97%)
 rename drivers/media/{video => platform}/s5p-mfc/s5p_mfc_dec.h (93%)
 rename drivers/media/{video => platform}/s5p-mfc/s5p_mfc_enc.c (95%)
 rename drivers/media/{video => platform}/s5p-mfc/s5p_mfc_enc.h (93%)
 rename drivers/media/{video => platform}/s5p-mfc/s5p_mfc_intr.c (97%)
 rename drivers/media/{video => platform}/s5p-mfc/s5p_mfc_intr.h (93%)
 rename drivers/media/{video => platform}/s5p-mfc/s5p_mfc_opr.c (97%)
 rename drivers/media/{video => platform}/s5p-mfc/s5p_mfc_opr.h (98%)
 rename drivers/media/{video => platform}/s5p-mfc/s5p_mfc_pm.c (98%)
 rename drivers/media/{video => platform}/s5p-mfc/s5p_mfc_pm.h (92%)
 rename drivers/media/{video => platform}/s5p-mfc/s5p_mfc_shm.c (96%)
 rename drivers/media/{video => platform}/s5p-mfc/s5p_mfc_shm.h (98%)
 rename drivers/media/{video => platform}/s5p-tv/Kconfig (98%)
 rename drivers/media/{video => platform}/s5p-tv/Makefile (92%)
 rename drivers/media/{video => platform}/s5p-tv/hdmi_drv.c (99%)
 rename drivers/media/{video => platform}/s5p-tv/hdmiphy_drv.c (100%)
 rename drivers/media/{video => platform}/s5p-tv/mixer.h (100%)
 rename drivers/media/{video => platform}/s5p-tv/mixer_drv.c (98%)
 rename drivers/media/{video => platform}/s5p-tv/mixer_grp_layer.c (100%)
 rename drivers/media/{video => platform}/s5p-tv/mixer_reg.c (100%)
 rename drivers/media/{video => platform}/s5p-tv/mixer_video.c (97%)
 rename drivers/media/{video => platform}/s5p-tv/mixer_vp_layer.c (100%)
 rename drivers/media/{video => platform}/s5p-tv/regs-hdmi.h (100%)
 rename drivers/media/{video => platform}/s5p-tv/regs-mixer.h (100%)
 rename drivers/media/{video => platform}/s5p-tv/regs-sdo.h (97%)
 rename drivers/media/{video => platform}/s5p-tv/regs-vp.h (100%)
 rename drivers/media/{video => platform}/s5p-tv/sdo_drv.c (98%)
 rename drivers/media/{video => platform}/s5p-tv/sii9234_drv.c (97%)
 rename drivers/media/{video => platform}/sh_vou.c (97%)
 create mode 100644 drivers/media/platform/soc_camera/Kconfig
 create mode 100644 drivers/media/platform/soc_camera/Makefile
 rename drivers/media/{video => platform/soc_camera}/atmel-isi.c (100%)
 rename drivers/media/{video => platform/soc_camera}/mx1_camera.c (100%)
 rename drivers/media/{video => platform/soc_camera}/mx2_camera.c (93%)
 rename drivers/media/{video => platform/soc_camera}/mx3_camera.c (99%)
 rename drivers/media/{video => platform/soc_camera}/omap1_camera.c (99%)
 rename drivers/media/{video => platform/soc_camera}/pxa_camera.c (100%)
 rename drivers/media/{video => platform/soc_camera}/sh_mobile_ceu_camera.c (99%)
 rename drivers/media/{video => platform/soc_camera}/sh_mobile_csi2.c (100%)
 rename drivers/media/{video => platform/soc_camera}/soc_camera.c (91%)
 rename drivers/media/{video => platform/soc_camera}/soc_camera_platform.c (94%)
 rename drivers/media/{video => platform/soc_camera}/soc_mediabus.c (100%)
 rename drivers/media/{video => platform}/timblogiw.c (100%)
 rename drivers/media/{video => platform}/via-camera.c (100%)
 rename drivers/media/{video => platform}/via-camera.h (100%)
 rename drivers/media/{video => platform}/vino.c (99%)
 rename drivers/media/{video => platform}/vino.h (100%)
 rename drivers/media/{video => platform}/vivi.c (97%)
 create mode 100644 drivers/media/rc/ir-rx51.c
 create mode 100644 drivers/media/rc/ttusbir.c
 rename drivers/media/{common => }/tuners/Kconfig (72%)
 rename drivers/media/{common => }/tuners/Makefile (88%)
 create mode 100644 drivers/media/tuners/e4000.c
 create mode 100644 drivers/media/tuners/e4000.h
 create mode 100644 drivers/media/tuners/e4000_priv.h
 rename drivers/media/{common => }/tuners/fc0011.c (100%)
 rename drivers/media/{common => }/tuners/fc0011.h (100%)
 rename drivers/media/{common => }/tuners/fc0012-priv.h (100%)
 rename drivers/media/{common => }/tuners/fc0012.c (100%)
 rename drivers/media/{common => }/tuners/fc0012.h (100%)
 rename drivers/media/{common => }/tuners/fc0013-priv.h (100%)
 rename drivers/media/{common => }/tuners/fc0013.c (100%)
 rename drivers/media/{common => }/tuners/fc0013.h (100%)
 rename drivers/media/{common => }/tuners/fc001x-common.h (100%)
 create mode 100644 drivers/media/tuners/fc2580.c
 create mode 100644 drivers/media/tuners/fc2580.h
 create mode 100644 drivers/media/tuners/fc2580_priv.h
 rename drivers/media/{common => }/tuners/max2165.c (100%)
 rename drivers/media/{common => }/tuners/max2165.h (100%)
 rename drivers/media/{common => }/tuners/max2165_priv.h (100%)
 rename drivers/media/{common => }/tuners/mc44s803.c (97%)
 rename drivers/media/{common => }/tuners/mc44s803.h (100%)
 rename drivers/media/{common => }/tuners/mc44s803_priv.h (100%)
 rename drivers/media/{common => }/tuners/mt2060.c (100%)
 rename drivers/media/{common => }/tuners/mt2060.h (100%)
 rename drivers/media/{common => }/tuners/mt2060_priv.h (100%)
 rename drivers/media/{common => }/tuners/mt2063.c (100%)
 rename drivers/media/{common => }/tuners/mt2063.h (100%)
 rename drivers/media/{common => }/tuners/mt20xx.c (100%)
 rename drivers/media/{common => }/tuners/mt20xx.h (100%)
 rename drivers/media/{common => }/tuners/mt2131.c (100%)
 rename drivers/media/{common => }/tuners/mt2131.h (100%)
 rename drivers/media/{common => }/tuners/mt2131_priv.h (100%)
 rename drivers/media/{common => }/tuners/mt2266.c (100%)
 rename drivers/media/{common => }/tuners/mt2266.h (100%)
 rename drivers/media/{common => }/tuners/mxl5005s.c (99%)
 rename drivers/media/{common => }/tuners/mxl5005s.h (100%)
 rename drivers/media/{common => }/tuners/mxl5007t.c (100%)
 rename drivers/media/{common => }/tuners/mxl5007t.h (100%)
 rename drivers/media/{common => }/tuners/qt1010.c (90%)
 rename drivers/media/{common => }/tuners/qt1010.h (100%)
 rename drivers/media/{common => }/tuners/qt1010_priv.h (100%)
 rename drivers/media/{common => }/tuners/tda18212.c (91%)
 rename drivers/media/{common => }/tuners/tda18212.h (100%)
 rename drivers/media/{common => }/tuners/tda18218.c (87%)
 rename drivers/media/{common => }/tuners/tda18218.h (100%)
 rename drivers/media/{common => }/tuners/tda18218_priv.h (90%)
 rename drivers/media/{common => }/tuners/tda18271-common.c (99%)
 rename drivers/media/{common => }/tuners/tda18271-fe.c (98%)
 rename drivers/media/{common => }/tuners/tda18271-maps.c (100%)
 rename drivers/media/{common => }/tuners/tda18271-priv.h (100%)
 rename drivers/media/{common => }/tuners/tda18271.h (95%)
 rename drivers/media/{common => }/tuners/tda827x.c (100%)
 rename drivers/media/{common => }/tuners/tda827x.h (100%)
 rename drivers/media/{common => }/tuners/tda8290.c (100%)
 rename drivers/media/{common => }/tuners/tda8290.h (100%)
 rename drivers/media/{common => }/tuners/tda9887.c (100%)
 rename drivers/media/{common => }/tuners/tda9887.h (100%)
 rename drivers/media/{common => }/tuners/tea5761.c (100%)
 rename drivers/media/{common => }/tuners/tea5761.h (100%)
 rename drivers/media/{common => }/tuners/tea5767.c (100%)
 rename drivers/media/{common => }/tuners/tea5767.h (100%)
 rename drivers/media/{common => }/tuners/tua9001.c (65%)
 rename drivers/media/{common => }/tuners/tua9001.h (78%)
 rename drivers/media/{common => }/tuners/tua9001_priv.h (100%)
 rename drivers/media/{common => }/tuners/tuner-i2c.h (100%)
 rename drivers/media/{common => }/tuners/tuner-simple.c (100%)
 rename drivers/media/{common => }/tuners/tuner-simple.h (100%)
 rename drivers/media/{common => }/tuners/tuner-types.c (100%)
 rename drivers/media/{common => }/tuners/tuner-xc2028-types.h (100%)
 rename drivers/media/{common => }/tuners/tuner-xc2028.c (99%)
 rename drivers/media/{common => }/tuners/tuner-xc2028.h (100%)
 rename drivers/media/{common => }/tuners/xc4000.c (99%)
 rename drivers/media/{common => }/tuners/xc4000.h (100%)
 rename drivers/media/{common => }/tuners/xc5000.c (88%)
 rename drivers/media/{common => }/tuners/xc5000.h (100%)
 create mode 100644 drivers/media/usb/Kconfig
 create mode 100644 drivers/media/usb/Makefile
 rename drivers/media/{video => usb}/au0828/Kconfig (54%)
 rename drivers/media/{video => usb}/au0828/Makefile (59%)
 rename drivers/media/{video => usb}/au0828/au0828-cards.c (99%)
 rename drivers/media/{video => usb}/au0828/au0828-cards.h (100%)
 rename drivers/media/{video => usb}/au0828/au0828-core.c (85%)
 rename drivers/media/{video => usb}/au0828/au0828-dvb.c (90%)
 rename drivers/media/{video => usb}/au0828/au0828-i2c.c (93%)
 rename drivers/media/{video => usb}/au0828/au0828-reg.h (98%)
 rename drivers/media/{video => usb}/au0828/au0828-vbi.c (100%)
 rename drivers/media/{video => usb}/au0828/au0828-video.c (96%)
 rename drivers/media/{video => usb}/au0828/au0828.h (98%)
 create mode 100644 drivers/media/usb/b2c2/Kconfig
 create mode 100644 drivers/media/usb/b2c2/Makefile
 rename drivers/media/{dvb => usb}/b2c2/flexcop-usb.c (99%)
 rename drivers/media/{dvb => usb}/b2c2/flexcop-usb.h (100%)
 rename drivers/media/{video => usb}/cpia2/Kconfig (100%)
 rename drivers/media/{video => usb}/cpia2/Makefile (100%)
 rename drivers/media/{video => usb}/cpia2/cpia2.h (100%)
 rename drivers/media/{video => usb}/cpia2/cpia2_core.c (99%)
 rename drivers/media/{video => usb}/cpia2/cpia2_registers.h (100%)
 rename drivers/media/{video => usb}/cpia2/cpia2_usb.c (100%)
 rename drivers/media/{video => usb}/cpia2/cpia2_v4l.c (97%)
 rename drivers/media/{video => usb}/cx231xx/Kconfig (86%)
 rename drivers/media/{video => usb}/cx231xx/Makefile (65%)
 rename drivers/media/{video => usb}/cx231xx/cx231xx-417.c (99%)
 rename drivers/media/{video => usb}/cx231xx/cx231xx-audio.c (100%)
 rename drivers/media/{video => usb}/cx231xx/cx231xx-avcore.c (100%)
 rename drivers/media/{video => usb}/cx231xx/cx231xx-cards.c (100%)
 rename drivers/media/{video => usb}/cx231xx/cx231xx-conf-reg.h (100%)
 rename drivers/media/{video => usb}/cx231xx/cx231xx-core.c (100%)
 rename drivers/media/{video => usb}/cx231xx/cx231xx-dif.h (100%)
 rename drivers/media/{video => usb}/cx231xx/cx231xx-dvb.c (100%)
 rename drivers/media/{video => usb}/cx231xx/cx231xx-i2c.c (100%)
 rename drivers/media/{video => usb}/cx231xx/cx231xx-input.c (100%)
 rename drivers/media/{video => usb}/cx231xx/cx231xx-pcb-cfg.c (100%)
 rename drivers/media/{video => usb}/cx231xx/cx231xx-pcb-cfg.h (100%)
 rename drivers/media/{video => usb}/cx231xx/cx231xx-reg.h (100%)
 rename drivers/media/{video => usb}/cx231xx/cx231xx-vbi.c (100%)
 rename drivers/media/{video => usb}/cx231xx/cx231xx-vbi.h (100%)
 rename drivers/media/{video => usb}/cx231xx/cx231xx-video.c (98%)
 rename drivers/media/{video => usb}/cx231xx/cx231xx.h (100%)
 create mode 100644 drivers/media/usb/dvb-usb-v2/Kconfig
 create mode 100644 drivers/media/usb/dvb-usb-v2/Makefile
 create mode 100644 drivers/media/usb/dvb-usb-v2/af9015.c
 rename drivers/media/{dvb/dvb-usb => usb/dvb-usb-v2}/af9015.h (78%)
 rename drivers/media/{dvb/dvb-usb => usb/dvb-usb-v2}/af9035.c (57%)
 rename drivers/media/{dvb/dvb-usb => usb/dvb-usb-v2}/af9035.h (93%)
 rename drivers/media/{dvb/dvb-usb => usb/dvb-usb-v2}/anysee.c (67%)
 rename drivers/media/{dvb/dvb-usb => usb/dvb-usb-v2}/anysee.h (97%)
 rename drivers/media/{dvb/dvb-usb => usb/dvb-usb-v2}/au6610.c (64%)
 rename drivers/media/{dvb/dvb-usb => usb/dvb-usb-v2}/au6610.h (80%)
 rename drivers/media/{dvb/dvb-usb => usb/dvb-usb-v2}/az6007.c (63%)
 rename drivers/media/{dvb/dvb-usb => usb/dvb-usb-v2}/ce6230.c (58%)
 rename drivers/media/{dvb/dvb-usb => usb/dvb-usb-v2}/ce6230.h (58%)
 create mode 100644 drivers/media/usb/dvb-usb-v2/cypress_firmware.c
 create mode 100644 drivers/media/usb/dvb-usb-v2/cypress_firmware.h
 create mode 100644 drivers/media/usb/dvb-usb-v2/dvb_usb.h
 create mode 100644 drivers/media/usb/dvb-usb-v2/dvb_usb_common.h
 create mode 100644 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
 create mode 100644 drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c
 rename drivers/media/{dvb/dvb-usb => usb/dvb-usb-v2}/ec168.c (57%)
 rename drivers/media/{dvb/dvb-usb => usb/dvb-usb-v2}/ec168.h (62%)
 rename drivers/media/{dvb/dvb-usb => usb/dvb-usb-v2}/gl861.c (54%)
 rename drivers/media/{dvb/dvb-usb => usb/dvb-usb-v2}/gl861.h (59%)
 create mode 100644 drivers/media/usb/dvb-usb-v2/it913x.c
 rename drivers/media/{dvb/dvb-usb => usb/dvb-usb-v2}/lmedm04.c (69%)
 rename drivers/media/{dvb/dvb-usb => usb/dvb-usb-v2}/lmedm04.h (100%)
 rename drivers/media/{dvb/dvb-usb => usb/dvb-usb-v2}/mxl111sf-demod.c (100%)
 rename drivers/media/{dvb/dvb-usb => usb/dvb-usb-v2}/mxl111sf-demod.h (100%)
 rename drivers/media/{dvb/dvb-usb => usb/dvb-usb-v2}/mxl111sf-gpio.c (100%)
 rename drivers/media/{dvb/dvb-usb => usb/dvb-usb-v2}/mxl111sf-gpio.h (100%)
 rename drivers/media/{dvb/dvb-usb => usb/dvb-usb-v2}/mxl111sf-i2c.c (100%)
 rename drivers/media/{dvb/dvb-usb => usb/dvb-usb-v2}/mxl111sf-i2c.h (100%)
 rename drivers/media/{dvb/dvb-usb => usb/dvb-usb-v2}/mxl111sf-phy.c (100%)
 rename drivers/media/{dvb/dvb-usb => usb/dvb-usb-v2}/mxl111sf-phy.h (100%)
 rename drivers/media/{dvb/dvb-usb => usb/dvb-usb-v2}/mxl111sf-reg.h (100%)
 rename drivers/media/{dvb/dvb-usb => usb/dvb-usb-v2}/mxl111sf-tuner.c (99%)
 rename drivers/media/{dvb/dvb-usb => usb/dvb-usb-v2}/mxl111sf-tuner.h (100%)
 create mode 100644 drivers/media/usb/dvb-usb-v2/mxl111sf.c
 rename drivers/media/{dvb/dvb-usb => usb/dvb-usb-v2}/mxl111sf.h (98%)
 rename drivers/media/{dvb/dvb-usb => usb/dvb-usb-v2}/rtl28xxu.c (62%)
 rename drivers/media/{dvb/dvb-usb => usb/dvb-usb-v2}/rtl28xxu.h (91%)
 create mode 100644 drivers/media/usb/dvb-usb-v2/usb_urb.c
 create mode 100644 drivers/media/usb/dvb-usb/Kconfig
 create mode 100644 drivers/media/usb/dvb-usb/Makefile
 rename drivers/media/{dvb => usb}/dvb-usb/a800.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/af9005-fe.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/af9005-remote.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/af9005-script.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/af9005.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/af9005.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/az6027.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/az6027.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/cinergyT2-core.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/cinergyT2-fe.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/cinergyT2.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/cxusb.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/cxusb.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/dib0700.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/dib0700_core.c (99%)
 rename drivers/media/{dvb => usb}/dvb-usb/dib0700_devices.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/dib07x0.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/dibusb-common.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/dibusb-mb.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/dibusb-mc.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/dibusb.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/digitv.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/digitv.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/dtt200u-fe.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/dtt200u.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/dtt200u.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/dtv5100.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/dtv5100.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/dvb-usb-common.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/dvb-usb-dvb.c (99%)
 rename drivers/media/{dvb => usb}/dvb-usb/dvb-usb-firmware.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/dvb-usb-i2c.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/dvb-usb-init.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/dvb-usb-remote.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/dvb-usb-urb.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/dvb-usb.h (99%)
 rename drivers/media/{dvb => usb}/dvb-usb/dw2102.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/dw2102.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/friio-fe.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/friio.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/friio.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/gp8psk-fe.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/gp8psk.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/gp8psk.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/m920x.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/m920x.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/nova-t-usb2.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/opera1.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/pctv452e.c (99%)
 rename drivers/media/{dvb => usb}/dvb-usb/technisat-usb2.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/ttusb2.c (99%)
 rename drivers/media/{dvb => usb}/dvb-usb/ttusb2.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/umt-010.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/usb-urb.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/vp702x-fe.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/vp702x.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/vp702x.h (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/vp7045-fe.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/vp7045.c (100%)
 rename drivers/media/{dvb => usb}/dvb-usb/vp7045.h (100%)
 rename drivers/media/{video => usb}/em28xx/Kconfig (67%)
 rename drivers/media/{video => usb}/em28xx/Makefile (57%)
 rename drivers/media/{video => usb}/em28xx/em28xx-audio.c (99%)
 rename drivers/media/{video => usb}/em28xx/em28xx-cards.c (99%)
 rename drivers/media/{video => usb}/em28xx/em28xx-core.c (99%)
 rename drivers/media/{video => usb}/em28xx/em28xx-dvb.c (95%)
 rename drivers/media/{video => usb}/em28xx/em28xx-i2c.c (100%)
 rename drivers/media/{video => usb}/em28xx/em28xx-input.c (100%)
 rename drivers/media/{video => usb}/em28xx/em28xx-reg.h (100%)
 rename drivers/media/{video => usb}/em28xx/em28xx-vbi.c (100%)
 rename drivers/media/{video => usb}/em28xx/em28xx-video.c (98%)
 rename drivers/media/{video => usb}/em28xx/em28xx.h (100%)
 rename drivers/media/{video => usb}/gspca/Kconfig (98%)
 rename drivers/media/{video => usb}/gspca/Makefile (100%)
 rename drivers/media/{video => usb}/gspca/autogain_functions.c (100%)
 rename drivers/media/{video => usb}/gspca/autogain_functions.h (100%)
 rename drivers/media/{video => usb}/gspca/benq.c (100%)
 rename drivers/media/{video => usb}/gspca/conex.c (100%)
 rename drivers/media/{video => usb}/gspca/cpia1.c (99%)
 rename drivers/media/{video => usb}/gspca/etoms.c (100%)
 rename drivers/media/{video => usb}/gspca/finepix.c (92%)
 rename drivers/media/{video => usb}/gspca/gl860/Kconfig (100%)
 rename drivers/media/{video => usb}/gspca/gl860/Makefile (75%)
 rename drivers/media/{video => usb}/gspca/gl860/gl860-mi1320.c (100%)
 rename drivers/media/{video => usb}/gspca/gl860/gl860-mi2020.c (100%)
 rename drivers/media/{video => usb}/gspca/gl860/gl860-ov2640.c (100%)
 rename drivers/media/{video => usb}/gspca/gl860/gl860-ov9655.c (100%)
 rename drivers/media/{video => usb}/gspca/gl860/gl860.c (100%)
 rename drivers/media/{video => usb}/gspca/gl860/gl860.h (100%)
 rename drivers/media/{video => usb}/gspca/gspca.c (99%)
 rename drivers/media/{video => usb}/gspca/gspca.h (97%)
 rename drivers/media/{video => usb}/gspca/jeilinj.c (99%)
 rename drivers/media/{video => usb}/gspca/jl2005bcd.c (95%)
 rename drivers/media/{video => usb}/gspca/jpeg.h (100%)
 rename drivers/media/{video => usb}/gspca/kinect.c (100%)
 rename drivers/media/{video => usb}/gspca/konica.c (100%)
 rename drivers/media/{video => usb}/gspca/m5602/Kconfig (100%)
 rename drivers/media/{video => usb}/gspca/m5602/Makefile (80%)
 rename drivers/media/{video => usb}/gspca/m5602/m5602_bridge.h (100%)
 rename drivers/media/{video => usb}/gspca/m5602/m5602_core.c (100%)
 rename drivers/media/{video => usb}/gspca/m5602/m5602_mt9m111.c (100%)
 rename drivers/media/{video => usb}/gspca/m5602/m5602_mt9m111.h (100%)
 rename drivers/media/{video => usb}/gspca/m5602/m5602_ov7660.c (100%)
 rename drivers/media/{video => usb}/gspca/m5602/m5602_ov7660.h (100%)
 rename drivers/media/{video => usb}/gspca/m5602/m5602_ov9650.c (100%)
 rename drivers/media/{video => usb}/gspca/m5602/m5602_ov9650.h (100%)
 rename drivers/media/{video => usb}/gspca/m5602/m5602_po1030.c (100%)
 rename drivers/media/{video => usb}/gspca/m5602/m5602_po1030.h (100%)
 rename drivers/media/{video => usb}/gspca/m5602/m5602_s5k4aa.c (100%)
 rename drivers/media/{video => usb}/gspca/m5602/m5602_s5k4aa.h (100%)
 rename drivers/media/{video => usb}/gspca/m5602/m5602_s5k83a.c (100%)
 rename drivers/media/{video => usb}/gspca/m5602/m5602_s5k83a.h (100%)
 rename drivers/media/{video => usb}/gspca/m5602/m5602_sensor.h (100%)
 rename drivers/media/{video => usb}/gspca/mars.c (100%)
 rename drivers/media/{video => usb}/gspca/mr97310a.c (100%)
 rename drivers/media/{video => usb}/gspca/nw80x.c (100%)
 rename drivers/media/{video => usb}/gspca/ov519.c (99%)
 rename drivers/media/{video => usb}/gspca/ov534.c (100%)
 rename drivers/media/{video => usb}/gspca/ov534_9.c (100%)
 rename drivers/media/{video => usb}/gspca/pac207.c (100%)
 rename drivers/media/{video => usb}/gspca/pac7302.c (95%)
 rename drivers/media/{video => usb}/gspca/pac7311.c (100%)
 rename drivers/media/{video => usb}/gspca/pac_common.h (100%)
 rename drivers/media/{video => usb}/gspca/se401.c (100%)
 rename drivers/media/{video => usb}/gspca/se401.h (100%)
 rename drivers/media/{video => usb}/gspca/sn9c2028.c (100%)
 rename drivers/media/{video => usb}/gspca/sn9c2028.h (100%)
 rename drivers/media/{video => usb}/gspca/sn9c20x.c (99%)
 rename drivers/media/{video => usb}/gspca/sonixb.c (100%)
 rename drivers/media/{video => usb}/gspca/sonixj.c (99%)
 rename drivers/media/{video => usb}/gspca/spca1528.c (100%)
 rename drivers/media/{video => usb}/gspca/spca500.c (100%)
 rename drivers/media/{video => usb}/gspca/spca501.c (100%)
 rename drivers/media/{video => usb}/gspca/spca505.c (100%)
 rename drivers/media/{video => usb}/gspca/spca506.c (100%)
 rename drivers/media/{video => usb}/gspca/spca508.c (100%)
 rename drivers/media/{video => usb}/gspca/spca561.c (100%)
 rename drivers/media/{video => usb}/gspca/sq905.c (95%)
 rename drivers/media/{video => usb}/gspca/sq905c.c (91%)
 rename drivers/media/{video => usb}/gspca/sq930x.c (99%)
 rename drivers/media/{video => usb}/gspca/stk014.c (100%)
 rename drivers/media/{video => usb}/gspca/stv0680.c (100%)
 rename drivers/media/{video => usb}/gspca/stv06xx/Kconfig (100%)
 rename drivers/media/{video => usb}/gspca/stv06xx/Makefile (78%)
 rename drivers/media/{video => usb}/gspca/stv06xx/stv06xx.c (100%)
 rename drivers/media/{video => usb}/gspca/stv06xx/stv06xx.h (100%)
 rename drivers/media/{video => usb}/gspca/stv06xx/stv06xx_hdcs.c (100%)
 rename drivers/media/{video => usb}/gspca/stv06xx/stv06xx_hdcs.h (100%)
 rename drivers/media/{video => usb}/gspca/stv06xx/stv06xx_pb0100.c (100%)
 rename drivers/media/{video => usb}/gspca/stv06xx/stv06xx_pb0100.h (100%)
 rename drivers/media/{video => usb}/gspca/stv06xx/stv06xx_sensor.h (100%)
 rename drivers/media/{video => usb}/gspca/stv06xx/stv06xx_st6422.c (100%)
 rename drivers/media/{video => usb}/gspca/stv06xx/stv06xx_st6422.h (100%)
 rename drivers/media/{video => usb}/gspca/stv06xx/stv06xx_vv6410.c (100%)
 rename drivers/media/{video => usb}/gspca/stv06xx/stv06xx_vv6410.h (100%)
 rename drivers/media/{video => usb}/gspca/sunplus.c (100%)
 rename drivers/media/{video => usb}/gspca/t613.c (100%)
 rename drivers/media/{video => usb}/gspca/topro.c (99%)
 rename drivers/media/{video => usb}/gspca/tv8532.c (100%)
 rename drivers/media/{video => usb}/gspca/vc032x.c (99%)
 rename drivers/media/{video => usb}/gspca/vicam.c (94%)
 rename drivers/media/{video => usb}/gspca/w996Xcf.c (100%)
 rename drivers/media/{video => usb}/gspca/xirlink_cit.c (99%)
 rename drivers/media/{video => usb}/gspca/zc3xx-reg.h (100%)
 rename drivers/media/{video => usb}/gspca/zc3xx.c (99%)
 rename drivers/media/{video => usb}/hdpvr/Kconfig (100%)
 rename drivers/media/{video => usb}/hdpvr/Makefile (81%)
 rename drivers/media/{video => usb}/hdpvr/hdpvr-control.c (100%)
 rename drivers/media/{video => usb}/hdpvr/hdpvr-core.c (100%)
 rename drivers/media/{video => usb}/hdpvr/hdpvr-i2c.c (100%)
 rename drivers/media/{video => usb}/hdpvr/hdpvr-video.c (99%)
 rename drivers/media/{video => usb}/hdpvr/hdpvr.h (100%)
 rename drivers/media/{video => usb}/pvrusb2/Kconfig (82%)
 rename drivers/media/{video => usb}/pvrusb2/Makefile (80%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-audio.c (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-audio.h (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-context.c (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-context.h (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-cs53l32a.c (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-cs53l32a.h (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-ctrl.c (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-ctrl.h (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-cx2584x-v4l.c (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-cx2584x-v4l.h (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-debug.h (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-debugifc.c (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-debugifc.h (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-devattr.c (97%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-devattr.h (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-dvb.c (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-dvb.h (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-eeprom.c (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-eeprom.h (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-encoder.c (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-encoder.h (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-fx2-cmd.h (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-hdw-internal.h (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-hdw.c (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-hdw.h (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-i2c-core.c (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-i2c-core.h (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-io.c (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-io.h (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-ioread.c (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-ioread.h (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-main.c (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-std.c (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-std.h (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-sysfs.c (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-sysfs.h (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-util.h (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-v4l2.c (99%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-v4l2.h (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-video-v4l.c (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-video-v4l.h (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-wm8775.c (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-wm8775.h (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2.h (100%)
 rename drivers/media/{video => usb}/pwc/Kconfig (100%)
 rename drivers/media/{video => usb}/pwc/Makefile (60%)
 rename drivers/media/{video => usb}/pwc/philips.txt (100%)
 rename drivers/media/{video => usb}/pwc/pwc-ctrl.c (100%)
 rename drivers/media/{video => usb}/pwc/pwc-dec1.c (100%)
 rename drivers/media/{video => usb}/pwc/pwc-dec1.h (100%)
 rename drivers/media/{video => usb}/pwc/pwc-dec23.c (100%)
 rename drivers/media/{video => usb}/pwc/pwc-dec23.h (100%)
 rename drivers/media/{video => usb}/pwc/pwc-if.c (99%)
 rename drivers/media/{video => usb}/pwc/pwc-kiara.c (100%)
 rename drivers/media/{video => usb}/pwc/pwc-kiara.h (100%)
 rename drivers/media/{video => usb}/pwc/pwc-misc.c (100%)
 rename drivers/media/{video => usb}/pwc/pwc-nala.h (100%)
 rename drivers/media/{video => usb}/pwc/pwc-timon.c (100%)
 rename drivers/media/{video => usb}/pwc/pwc-timon.h (100%)
 rename drivers/media/{video => usb}/pwc/pwc-uncompress.c (100%)
 rename drivers/media/{video => usb}/pwc/pwc-v4l.c (100%)
 rename drivers/media/{video => usb}/pwc/pwc.h (100%)
 create mode 100644 drivers/media/usb/s2255/Kconfig
 create mode 100644 drivers/media/usb/s2255/Makefile
 rename drivers/media/{video => usb/s2255}/s2255drv.c (99%)
 create mode 100644 drivers/media/usb/siano/Kconfig
 create mode 100644 drivers/media/usb/siano/Makefile
 rename drivers/media/{dvb => usb}/siano/smsusb.c (100%)
 rename drivers/media/{video => usb}/sn9c102/Kconfig (100%)
 rename drivers/media/{video => usb}/sn9c102/Makefile (100%)
 rename drivers/media/{video => usb}/sn9c102/sn9c102.h (100%)
 rename drivers/media/{video => usb}/sn9c102/sn9c102_config.h (100%)
 rename drivers/media/{video => usb}/sn9c102/sn9c102_core.c (100%)
 rename drivers/media/{video => usb}/sn9c102/sn9c102_devtable.h (100%)
 rename drivers/media/{video => usb}/sn9c102/sn9c102_hv7131d.c (100%)
 rename drivers/media/{video => usb}/sn9c102/sn9c102_hv7131r.c (100%)
 rename drivers/media/{video => usb}/sn9c102/sn9c102_mi0343.c (100%)
 rename drivers/media/{video => usb}/sn9c102/sn9c102_mi0360.c (100%)
 rename drivers/media/{video => usb}/sn9c102/sn9c102_mt9v111.c (100%)
 rename drivers/media/{video => usb}/sn9c102/sn9c102_ov7630.c (100%)
 rename drivers/media/{video => usb}/sn9c102/sn9c102_ov7660.c (100%)
 rename drivers/media/{video => usb}/sn9c102/sn9c102_pas106b.c (100%)
 rename drivers/media/{video => usb}/sn9c102/sn9c102_pas202bcb.c (100%)
 rename drivers/media/{video => usb}/sn9c102/sn9c102_sensor.h (100%)
 rename drivers/media/{video => usb}/sn9c102/sn9c102_tas5110c1b.c (100%)
 rename drivers/media/{video => usb}/sn9c102/sn9c102_tas5110d.c (100%)
 rename drivers/media/{video => usb}/sn9c102/sn9c102_tas5130d1b.c (100%)
 create mode 100644 drivers/media/usb/stk1160/Kconfig
 create mode 100644 drivers/media/usb/stk1160/Makefile
 create mode 100644 drivers/media/usb/stk1160/stk1160-ac97.c
 create mode 100644 drivers/media/usb/stk1160/stk1160-core.c
 create mode 100644 drivers/media/usb/stk1160/stk1160-i2c.c
 create mode 100644 drivers/media/usb/stk1160/stk1160-reg.h
 create mode 100644 drivers/media/usb/stk1160/stk1160-v4l.c
 create mode 100644 drivers/media/usb/stk1160/stk1160-video.c
 create mode 100644 drivers/media/usb/stk1160/stk1160.h
 create mode 100644 drivers/media/usb/stkwebcam/Kconfig
 create mode 100644 drivers/media/usb/stkwebcam/Makefile
 rename drivers/media/{video => usb/stkwebcam}/stk-sensor.c (100%)
 rename drivers/media/{video => usb/stkwebcam}/stk-webcam.c (100%)
 rename drivers/media/{video => usb/stkwebcam}/stk-webcam.h (100%)
 rename drivers/media/{video => usb}/tlg2300/Kconfig (100%)
 create mode 100644 drivers/media/usb/tlg2300/Makefile
 rename drivers/media/{video => usb}/tlg2300/pd-alsa.c (99%)
 rename drivers/media/{video => usb}/tlg2300/pd-common.h (100%)
 rename drivers/media/{video => usb}/tlg2300/pd-dvb.c (100%)
 rename drivers/media/{video => usb}/tlg2300/pd-main.c (100%)
 rename drivers/media/{video => usb}/tlg2300/pd-radio.c (99%)
 rename drivers/media/{video => usb}/tlg2300/pd-video.c (99%)
 rename drivers/media/{video => usb}/tlg2300/vendorcmds.h (100%)
 rename drivers/media/{video => usb}/tm6000/Kconfig (100%)
 rename drivers/media/{video => usb}/tm6000/Makefile (62%)
 rename drivers/media/{video => usb}/tm6000/tm6000-alsa.c (99%)
 rename drivers/media/{video => usb}/tm6000/tm6000-cards.c (100%)
 rename drivers/media/{video => usb}/tm6000/tm6000-core.c (100%)
 rename drivers/media/{video => usb}/tm6000/tm6000-dvb.c (100%)
 rename drivers/media/{video => usb}/tm6000/tm6000-i2c.c (100%)
 rename drivers/media/{video => usb}/tm6000/tm6000-input.c (99%)
 rename drivers/media/{video => usb}/tm6000/tm6000-regs.h (100%)
 rename drivers/media/{video => usb}/tm6000/tm6000-stds.c (100%)
 rename drivers/media/{video => usb}/tm6000/tm6000-usb-isoc.h (100%)
 rename drivers/media/{video => usb}/tm6000/tm6000-video.c (97%)
 rename drivers/media/{video => usb}/tm6000/tm6000.h (100%)
 rename drivers/media/{dvb => usb}/ttusb-budget/Kconfig (56%)
 create mode 100644 drivers/media/usb/ttusb-budget/Makefile
 rename drivers/media/{dvb => usb}/ttusb-budget/dvb-ttusb-budget.c (100%)
 rename drivers/media/{dvb => usb}/ttusb-dec/Kconfig (100%)
 rename drivers/media/{dvb => usb}/ttusb-dec/Makefile (57%)
 rename drivers/media/{dvb => usb}/ttusb-dec/ttusb_dec.c (100%)
 rename drivers/media/{dvb => usb}/ttusb-dec/ttusbdecfe.c (100%)
 rename drivers/media/{dvb => usb}/ttusb-dec/ttusbdecfe.h (100%)
 rename drivers/media/{video => usb}/usbvision/Kconfig (88%)
 rename drivers/media/{video => usb}/usbvision/Makefile (63%)
 rename drivers/media/{video => usb}/usbvision/usbvision-cards.c (100%)
 rename drivers/media/{video => usb}/usbvision/usbvision-cards.h (100%)
 rename drivers/media/{video => usb}/usbvision/usbvision-core.c (100%)
 rename drivers/media/{video => usb}/usbvision/usbvision-i2c.c (100%)
 rename drivers/media/{video => usb}/usbvision/usbvision-video.c (97%)
 rename drivers/media/{video => usb}/usbvision/usbvision.h (100%)
 rename drivers/media/{video => usb}/uvc/Kconfig (100%)
 rename drivers/media/{video => usb}/uvc/Makefile (100%)
 rename drivers/media/{video => usb}/uvc/uvc_ctrl.c (100%)
 rename drivers/media/{video => usb}/uvc/uvc_debugfs.c (100%)
 rename drivers/media/{video => usb}/uvc/uvc_driver.c (98%)
 rename drivers/media/{video => usb}/uvc/uvc_entity.c (100%)
 rename drivers/media/{video => usb}/uvc/uvc_isight.c (100%)
 rename drivers/media/{video => usb}/uvc/uvc_queue.c (100%)
 rename drivers/media/{video => usb}/uvc/uvc_status.c (100%)
 rename drivers/media/{video => usb}/uvc/uvc_v4l2.c (100%)
 rename drivers/media/{video => usb}/uvc/uvc_video.c (98%)
 rename drivers/media/{video => usb}/uvc/uvcvideo.h (98%)
 create mode 100644 drivers/media/usb/zr364xx/Kconfig
 create mode 100644 drivers/media/usb/zr364xx/Makefile
 rename drivers/media/{video => usb/zr364xx}/zr364xx.c (100%)
 create mode 100644 drivers/media/v4l2-core/Kconfig
 create mode 100644 drivers/media/v4l2-core/Makefile
 rename drivers/media/{video => v4l2-core}/tuner-core.c (100%)
 rename drivers/media/{video => v4l2-core}/v4l2-common.c (62%)
 rename drivers/media/{video => v4l2-core}/v4l2-compat-ioctl32.c (94%)
 rename drivers/media/{video => v4l2-core}/v4l2-ctrls.c (94%)
 rename drivers/media/{video => v4l2-core}/v4l2-dev.c (79%)
 rename drivers/media/{video => v4l2-core}/v4l2-device.c (99%)
 rename drivers/media/{video => v4l2-core}/v4l2-event.c (98%)
 rename drivers/media/{video => v4l2-core}/v4l2-fh.c (100%)
 rename drivers/media/{video => v4l2-core}/v4l2-int-device.c (100%)
 rename drivers/media/{video => v4l2-core}/v4l2-ioctl.c (92%)
 rename drivers/media/{video => v4l2-core}/v4l2-mem2mem.c (98%)
 rename drivers/media/{video => v4l2-core}/v4l2-subdev.c (98%)
 rename drivers/media/{video => v4l2-core}/videobuf-core.c (100%)
 rename drivers/media/{video => v4l2-core}/videobuf-dma-contig.c (100%)
 rename drivers/media/{video => v4l2-core}/videobuf-dma-sg.c (100%)
 rename drivers/media/{video => v4l2-core}/videobuf-dvb.c (96%)
 rename drivers/media/{video => v4l2-core}/videobuf-vmalloc.c (100%)
 rename drivers/media/{video => v4l2-core}/videobuf2-core.c (98%)
 rename drivers/media/{video => v4l2-core}/videobuf2-dma-contig.c (100%)
 rename drivers/media/{video => v4l2-core}/videobuf2-dma-sg.c (100%)
 rename drivers/media/{video => v4l2-core}/videobuf2-memops.c (100%)
 rename drivers/media/{video => v4l2-core}/videobuf2-vmalloc.c (99%)
 delete mode 100644 drivers/media/video/Kconfig
 delete mode 100644 drivers/media/video/Makefile
 delete mode 100644 drivers/media/video/bt8xx/Kconfig
 delete mode 100644 drivers/media/video/bt8xx/Makefile
 delete mode 100644 drivers/media/video/cx23885/Kconfig
 delete mode 100644 drivers/media/video/tlg2300/Makefile
 delete mode 100644 drivers/staging/media/easycap/Kconfig
 delete mode 100644 drivers/staging/media/easycap/Makefile
 delete mode 100644 drivers/staging/media/easycap/README
 delete mode 100644 drivers/staging/media/easycap/easycap.h
 delete mode 100644 drivers/staging/media/easycap/easycap_ioctl.c
 delete mode 100644 drivers/staging/media/easycap/easycap_low.c
 delete mode 100644 drivers/staging/media/easycap/easycap_main.c
 delete mode 100644 drivers/staging/media/easycap/easycap_settings.c
 delete mode 100644 drivers/staging/media/easycap/easycap_sound.c
 delete mode 100644 drivers/staging/media/easycap/easycap_testcard.c
 delete mode 100644 drivers/staging/media/lirc/lirc_ene0100.h
 delete mode 100644 drivers/staging/media/lirc/lirc_ttusbir.c
 create mode 100644 include/linux/v4l2-controls.h
 create mode 100644 include/media/ad9389b.h
 create mode 100644 include/media/adv7604.h
 create mode 100644 include/media/ir-rx51.h
 create mode 100644 include/media/s5k4ecgx.h

-- 
Regards,
Mauro
