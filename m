Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601Ab2JIRnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 13:43:50 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:45461 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754918Ab2JIRnr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 13:43:47 -0400
MIME-Version: 1.0
In-Reply-To: <20121005104259.03c94150@redhat.com>
References: <20121005104259.03c94150@redhat.com>
Date: Tue, 9 Oct 2012 14:43:46 -0300
Message-ID: <CALF0-+XQW1RrHQN4=5fzLLsdJESrLnhSwW3yD9rK+huP5dUOqQ@mail.gmail.com>
Subject: Re: [GIT PULL for 3.7-rc1] media updates - part 1
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 5, 2012 at 10:42 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Hi Linus,
>
> Please pull from:
> git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus
>
> For the first part of the media updates for Kernel 3.7.
>
> This series contain:
>
>         - A major tree renaming patch series: now, drivers are organized internally
>           by their used bus, instead of by V4L2 and/or DVB API, providing a cleaner
>           driver location for hybrid drivers that implement both APIs, and allowing to
>           cleanup the Kconfig items and make them more intuitive for the end user;
>
>         - Media Kernel developers are typically very lazy with their duties of
>           keeping the MAINTAINERS entries for their drivers updated. As now the tree
>           is more organized, we're doing an effort to add/update those entries
>           for the drivers that aren't currently orphan;
>
>         - Several DVB USB drivers got moved to a new DVB USB v2 core; the new core
>           fixes several bugs (as the existing one that got bitroted). Now,
>           suspend/resume finally started to work fine (at least with some devices -
>           we should expect more work with regards to it);
>
>         - added multistream support for DVB-T2, and unified the API for DVB-S2
>           and ISDB-S. Backward binary support is preserved;
>
>         - as usual, a few new drivers, some V4L2 core improvements and lots of
>           drivers improvements and fixes.
>
> There are some points to notice on this series:
>
>         1) you should expect a trivial merge conflict on your tree, with the removal
>            of Documentation/feature-removal-schedule.txt: this series would be adding
>            two additional entries there. I opted to not rebase it due to this recent
>            change;
>
>         2) With regards to the PCTV 520e udev-related breakage, I opted to fix it
>            in a way that the patches can be backported to 3.5 even without your
>            firmware fix patch. This way, Greg doesn't need to rush backporting your
>            patch (as there are still the firmware cache and firmware path customization
>            issues to be addressed there). I'll send later a patch (likely after the end
>            of the merge window) reverting the rest of the DRX-K async firmware request,
>            fully restoring its original behaviour to allow media drivers to initialize
>            everything serialized as before for 3.7 and upper.
>
>         3) I'm planning to work on this weekend to test the DMABUF patches for V4L2.
>            The patches are on my queue for several Kernel cycles, but, up to now,
>            there is/was no way to test the series locally. I have some concerns about
>            this particular changeset with regards to security issues, and with regards
>            to the replacement of the old VIDIOC_OVERLAY ioctl's that is broken on
>            modern systems, due to GPU drivers change. The Overlay API allows direct
>            PCI2PCI transfers from a media capture card into the GPU framebuffer, but
>            its API is crappy. Also, the only existing X11 driver that implements it
>            requires a XV extension that is not available anymore on modern drivers.
>            The DMABUF can do the same thing, but with it is promising to be a
>            properly-designed API. If I can successfully test this series and
>            be happy with it, I should be asking you to pull them next week.
>
> Thanks,
> Mauro
>
> -
>
> The following changes since commit a0d271cbfed1dd50278c6b06bead3d00ba0a88f9:
>
>   Linux 3.6 (2012-09-30 16:47:46 -0700)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus
>
> for you to fetch changes up to bd0d10498826ed150da5e4c45baf8b9c7088fb71:
>
>   Merge branch 'staging/for_v3.7' into v4l_for_linus (2012-10-05 09:36:26 -0300)
>
> ----------------------------------------------------------------
>
> Alan Cox (5):
>       [media] mantis: fix silly crash case
>       [media] tda8261: add printk levels
>       [media] cx88: Fix reset delays
>       [media] tlg2300: fix missing check for audio creation
>       [media] v4l2: spi modalias is an array
>
> Albert Wang (1):
>       [media] media: soc_camera: don't clear pix->sizeimage in JPEG mode
>
> Alex Gershgorin (2):
>       [media] media: mx3_camera: buf_init() add buffer state check
>       [media] mt9v022: Add support for mt9v024
>
> Alexey Khoroshilov (1):
>       [media] ddbridge: fix error handling in module_init_ddbridge()
>
> Andrzej Hajda (2):
>       [media] s5p-mfc: added support for end of stream handling in MFC encoder
>       [media] s5p-mfc: optimized code related to working contextes
>
> Andy Shevchenko (11):
>       [media] saa7164: use native print_hex_dump() instead of custom one
>       [media] dvb: nxt200x: apply levels to the printk()s
>       [media] staging: lirc: use %*ph to print small buffers
>       [media] common: tunners: use %*ph to dump small buffers
>       [media] dvb: frontends: use %*ph to dump small buffers
>       [media] radio-shark2: use %*ph to print small buffers
>       [media] gspca: use %*ph to print small buffers
>       [media] dvb: use %*ph to hexdump small buffers
>       [media] ati_remote: use %*ph to dump small buffers
>       [media] saa7127: use %*ph to print small buffers
>       [media] dvb-usb: use %*ph to dump small buffers
>
> Andy Walls (3):
>       [media] ivtv, ivtv-alsa: Add initial ivtv-alsa interface driver for ivtv
>       [media] ivtv-alsa, ivtv: Connect ivtv PCM capture stream to ivtv-alsa interface driver
>       [media] ivtv-alsa: Remove EXPERIMENTAL from Kconfig and revise Kconfig help text
>
> Anton Nurkin (2):
>       [media] cx23885-cards: fix netup card default revision
>       [media] cx23885: fix pointer to structure for CAM
>
> Antti Palosaari (214):
>       [media] dvb_usb_v2: copy current dvb_usb as a starting point
>       [media] dvb_usb_v2: add .init() callback
>       [media] dvb_usb_v2: remove one parameter from dvb_usbv2_device_init()
>       [media] dvb_usb_v2: use .driver_info to pass struct dvb_usb_device_properties
>       [media] dvb_usb_v2: remove owner parameter from dvb_usbv2_device_init()
>       [media] dvb_usb_v2: remove adapter_nums parameter from dvb_usbv2_device_init()
>       [media] dvb_usb_v2: pass (struct dvb_usb_device *) as a parameter for fw download
>       [media] dvb_usb_v2: implement .get_firmware_name()
>       [media] dvb_usb_v2: fix issues raised by checkpatch.pl
>       [media] dvb_usb_v2: pass device name too using (struct usb_device_id)
>       [media] dvb_usb_v2: implement .get_adapter_count()
>       [media] dvb_usb_v2: implement .read_config()
>       [media] dvb_usb_v2: remote controller
>       [media] dvb_usb_v2: restore .firmware - pointer to name
>       [media] dvb_usb_v2: init I2C and USB mutex earlier
>       [media] dvb_usb_v2: remote controller changes
>       [media] dvb_usb_v2: dynamic USB stream URB configuration
>       [media] dvb_usb_v2: usb_urb.c use dynamic debugs
>       [media] dvb_usb_v2: add .get_usb_stream_config()
>       [media] dvb_usb_v2: move (struct usb_data_stream) to one level up
>       [media] dvb_usb_v2: add .get_ts_config() callback
>       [media] dvb_usb_v2: move (struct usb_data_stream_properties) to upper level
>       [media] dvb_usb_v2: move PID filters from frontend to adapter
>       [media] dvb_usb_v2: move 3 callbacks from the frontend to adapter
>       [media] dvb_usb_v2: get rid of (struct dvb_usb_adapter_fe_properties)
>       [media] dvb_usb_v2: remove .num_frontends
>       [media] dvb_usb_v2: delay firmware download as it blocks module init
>       [media] dvb_usb_v2: clean firmware downloading routines
>       [media] dvb_usb_v2: add macro for filling usb_device_id table entry
>       [media] dvb_usb_v2: use dynamic debugs
>       [media] dvb_usb_v2: remove various unneeded variables
>       [media] dvb_usb_v2: frontend switching changes
>       [media] dvb_usb_v2: ensure driver_info is not null
>       [media] dvb_usb_v2: refactor delayed init
>       [media] dvb_usb_v2: remove usb_clear_halt()
>       [media] dvb_usb_v2: unregister all frontends in error case
>       [media] dvb_usb_v2: use Kernel logging (pr_debug/pr_err/pr_info)
>       [media] dvb_usb_v2: move I2C adapter code to different file
>       [media] dvb_usb_v2: rename device_init/device_exit to probe/disconnect
>       [media] dvb_usb_v2: add .bInterfaceNumber match
>       [media] dvb_usb_v2: add missing new line for log writings
>       [media] dvb_usb_v2: fix dvb_usb_generic_rw() debug
>       [media] dvb_usb_v2: do not free resources until delayed init is done
>       [media] dvb_usb_v2: enable compile
>       [media] af9015: switch to new DVB-USB
>       [media] af9015: use USB core soft_unbind
>       [media] dvb_usb_v2: I2C adapter cleanup changes
>       [media] dvb_usb_v2: misc cleanup changes
>       [media] dvb_usb_v2: probe/disconnect error handling
>       [media] dvb_usb_v2: add .disconnect() callback
>       [media] dvb_usb_v2: suspend/resume stop/start USB streaming
>       [media] dvb_usb_v2: Cypress firmware download module
>       [media] dvb_usb_v2: move few callbacks one level up
>       [media] dvb_usb_v2: use keyword const for USB ID table
>       [media] af9015: suspend/resume
>       [media] dvb_usb_v2: use pointers to properties
>       [media] ec168: convert to new DVB USB
>       [media] ec168: switch Kernel pr_* logging
>       [media] dvb_usb_v2: do not check active fe when stop streaming
>       [media] ec168: re-implement firmware loading
>       [media] au6610: convert to new DVB USB
>       [media] dvb_usb_v2: move remote controller to the main file
>       [media] ce6230: convert to new DVB USB
>       [media] ce6230: various small changes
>       [media] dvb_usb_v2: attach tuners later
>       [media] anysee: convert to new DVB USB
>       [media] dvb_usb_v2: do not release USB interface when device reconnects
>       [media] dvb_usb_v2: try to remove all adapters on exit
>       [media] dvb_usb_v2: simplify remote init/exit logic
>       [media] dvb_usb_v2: get rid of dvb_usb_device state
>       [media] dvb_usb_v2: move fe_ioctl_override() callback
>       [media] dvb_usb_v2: remove num_frontends_initialized from dvb_usb_adapter
>       [media] dvb_usb_v2: .read_mac_address() callback changes
>       [media] dvb_usb_v2: add macros to fill USB stream properties
>       [media] dvb_usb_v2: change USB stream config logic
>       [media] af9015: update USB streaming configuration logic
>       [media] dvb_usb_v2: helper macros for device/adapter/frontend pointers
>       [media] af9015: use helper macros for some pointers
>       [media] dvb_usb_v2: use lock to sync feed and frontend control
>       [media] af9035: convert to new DVB USB
>       [media] dvb_usb_v2: git rid of dvb_usb_adapter state variable
>       [media] anysee: use DVB USB macros
>       [media] au6610: use DVB USB macros
>       [media] ce6230: use DVB USB macros
>       [media] ec168: use DVB UDB macros
>       [media] dvb_usb_v2: use container_of() for adapter to device
>       [media] dvb_usb_v2: merge get_ts_config() to get_usb_stream_config()
>       [media] dvb_usb_v2: use identify_state() to resolve firmware name
>       [media] dvb_usb_v2: remove num_adapters_initialized variable
>       [media] dvb_usb_v2: refactor dvb_usb_ctrl_feed() logic
>       [media] dvb_usb_v2: merge files dvb_usb_init.c and dvb_usb_dvb.c
>       [media] dvb_usb_v2: move dvb_usbv2_generic_rw() debugs behind define
>       [media] dvb_usb_v2: multiple small tweaks around the code
>       [media] dvb_usb_v2: refactor dvb_usbv2_generic_rw()
>       [media] dvb_usb_v2: update header dvb_usb.h comments
>       [media] dvb_usb_v2: remove unused variable
>       [media] dvb_usb_v2: update copyrights
>       [media] dvb_usb_v2: fix power_ctrl() callback error handling
>       [media] dvb_usb_v2: change streaming control callback parameter
>       [media] dvb_usb_v2: use dev_* logging macros
>       [media] dvb_usb_v2: do not try to remove non-existent adapter
>       [media] dvb_usb_v2: remove usb_clear_halt() from stream
>       [media] dvb_usb_v2: register device even no remote keymap defined
>       [media] mxl111sf: convert to new DVB USB
>       [media] gl861: convert to new DVB USB
>       [media] dvb_usb_v2: move from dvb-usb to dvb-usb-v2
>       [media] af9015: remote controller fixes
>       [media] dvb_usbv2: rename dvb_usb_firmware to cypress_firmware
>       [media] m88rs2000: add missing FE_HAS_SYNC flag
>       [media] tda18212: silence compiler warning
>       [media] tda18212: use Kernel dev_* logging
>       [media] tda18218: silence compiler warning
>       [media] rtl28xxu: convert to new DVB USB
>       [media] rtl28xxu: generalize streaming control
>       [media] add DTMB support for DVB API
>       [media] DVB API: add INTERLEAVING_AUTO
>       [media] dvb_usb_v2: use %*ph to dump usb xfer debugs
>       [media] anysee: fix compiler warning
>       [media] anysee: convert Kernel dev_* logging
>       [media] dvb_core: export function to perform retune
>       [media] dvb_usb_v2: implement power-management for suspend
>       [media] dvb_frontend: implement suspend / resume
>       [media] dvb_usb_v2: .reset_resume() support
>       [media] dvb_usb_v2: af9015, af9035, anysee use .reset_resume
>       [media] dvb_usb_v2: ce6230, rtl28xxu use .reset_resume
>       [media] dvb_frontend: use Kernel dev_* logging
>       [media] dvb_frontend: return -ENOTTY for unimplement IOCTL
>       [media] DocBook: update ioctl error codes
>       [media] rtl2832: remove dummy callback implementations
>       [media] dvb_usb_v2: use ratelimited debugs where appropriate
>       [media] dvb-usb: remove unused files
>       [media] qt1010: do not change frequency during init
>       [media] gl861: reset_resume support
>       [media] qt1010: convert for Kernel logging
>       [media] qt1010: remove debug register dump
>       [media] tda18218: re-implement tda18218_wr_regs()
>       [media] tda18218: switch to Kernel logging
>       [media] rtl28xxu: stream did not start after stop on USB3.0
>       [media] rtl28xxu: fix rtl2832u module reload fails bug
>       [media] rtl2832: implement .get_frontend()
>       [media] rtl2832: implement .read_snr()
>       [media] rtl2832: implement .read_ber()
>       [media] au6610: define reset_resume
>       [media] dvb_usb_v2: add debug macro dvb_usb_dbg_usb_control_msg
>       [media] dvb_usb_v2: use dvb_usb_dbg_usb_control_msg()
>       [media] rtl28xxu: correct usb_clear_halt() usage
>       [media] Elonics E4000 silicon tuner driver
>       [media] rtl28xxu: add support for Elonics E4000 tuner
>       [media] mxl5005s: implement get_if_frequency()
>       [media] af9013: add debug for IF frequency
>       [media] mc44s803: implement get_if_frequency()
>       [media] tuners: add FCI FC2580 silicon tuner driver
>       [media] rtl28xxu: add support for FCI FC2580 silicon tuner driver
>       [media] rtl28xxu: Dexatek DK DVB-T Dongle [1d19:1101]
>       [media] rtl2832: separate tuner specific init from general
>       [media] rtl2832: remove redundant function declaration
>       [media] af9035: relax frontend callback error handling
>       [media] tua9001: implement control pin callbacks
>       [media] rtl28xxu: add support for tua9001 tuner based devices
>       [media] rtl2832: support for tua9001 tuner
>       [media] tua9001: use dev_foo logging
>       [media] rtl2832: use dev_foo() logging
>       [media] af9013: declare MODULE_FIRMWARE
>       [media] af9015: declare MODULE_FIRMWARE
>       [media] tda10071: declare MODULE_FIRMWARE
>       [media] ec168: declare MODULE_FIRMWARE
>       [media] af9033: use Kernel dev_foo() logging
>       [media] af9013: use Kernel dev_foo() logging
>       [media] ec100: use Kernel dev_foo() logging
>       [media] ec100: improve I2C routines
>       [media] hd29l2: use Kernel dev_foo() logging
>       [media] rtl2830: use Kernel dev_foo() logging
>       [media] rtl2830: use .get_if_frequency()
>       [media] rtl2830: declare two tables as constant
>       [media] af9015: use Kernel dev_foo() logging
>       [media] af9015: improve af9015_eeprom_hash()
>       [media] af9015: correct few error codes
>       [media] af9035: use Kernel dev_foo() logging
>       [media] au6610: use Kernel dev_foo() logging
>       [media] gl861: use Kernel dev_foo() logging
>       [media] ec168: use Kernel dev_foo() logging
>       [media] ce6230: use Kernel dev_foo() logging
>       [media] tua9001: enter full power save on attach
>       [media] af9035: implement TUA9001 GPIOs correctly
>       [media] af9033: sleep on attach
>       [media] rtl28xxu: add ID [0bda:2832] Realtek RTL2832U reference design
>       [media] dvb_frontend: do not allow statistic IOCTLs when sleeping
>       [media] add LNA support for DVB API
>       [media] DVB API: LNA documentation
>       [media] cxd2820r: switch to Kernel dev_* logging
>       [media] cxd2820r: use Kernel GPIO for GPIO access
>       [media] dvb_usb_v2: rename module dvb_usbv2 => dvb_usb_v2
>       [media] dvb_usb_v2: call streaming_ctrl() before kill urbs
>       [media] af9035: declare MODULE_FIRMWARE
>       [media] rtl28xxu: move rtl2832u tuner probing to .read_config()
>       [media] rtl28xxu: masked reg write
>       [media] rtl28xxu: do not return error for unimplemented fe callback
>       [media] rtl28xxu: move rtl2831u tuner probing to .read_config()
>       [media] rtl28xxu: remove fc0013 tuner fe callback
>       [media] rtl2832: add configuration for e4000 tuner
>       [media] rtl28xxu: use proper config for e4000 tuner
>       [media] rtl28xxu: [0413:6680] DigitalNow Quad DVB-T Receiver
>       [media] cypress_firmware: use Kernel dev_foo() logging
>       [media] cypress_firmware: refactor firmware downloading
>       [media] fc2580: small improvements for chip id check
>       [media] dvb_usb_v2: fix error handling for .tuner_attach()
>       [media] fc2580: fix crash when attach fails
>       [media] e4000: fix crash when attach fails
>       [media] anysee: do not remove CI when it is not attached
>       [media] MAINTAINERS: add modules I am responsible
>       [media] em28xx: implement FE set_lna() callback
>       [media] cxd2820r: use static GPIO config when GPIOLIB is undefined
>       [media] em28xx: do not set PCTV 290e LNA handler if fe attach fail
>       [media] rtl28xxu: [0ccd:00d3] TerraTec Cinergy T Stick RC (Rev. 3)
>
> Arnd Bergmann (2):
>       [media] media/radio/shark2: Fix build error caused by missing dependencies
>       [media] media/radio/shark2: Fix build error caused by missing dependencies
>
> Axel Lin (1):
>       gpio: bt8xx: Fix build error due to missing include file
>
> Ben Hutchings (1):
>       [media] rc: ite-cir: Initialise ite_dev::rdev earlier
>
> Dan Carpenter (6):
>       [media] qt1010: signedness bug in qt1010_init_meas1()
>       [media] it913x-fe: use ARRAY_SIZE() as a cleanup
>       [media] em28xx: use after free in em28xx_v4l2_close()
>       [media] mem2mem_testdev: unlock and return error code properly
>       [media] stk1160: unlock on error path stk1160_set_alternate()
>       [media] stk1160: remove unneeded check
>
> David Härdeman (3):
>       [media] rc-core: move timeout and checks to lirc
>       [media] winbond-cir: correctness fix
>       [media] winbond-cir: asynchronous tx
>
> Devendra Naga (3):
>       [media] staging: media: cxd2099: fix sparse warnings in cxd2099_attach
>       [media] staging: media: cxd2099: use kzalloc to allocate ci pointer of type struct cxd in cxd2099_attach
>       [media] staging: media: cxd2099: remove memcpy of similar structure variables
>
> Devin Heitmueller (24):
>       [media] au8522: fix intermittent lockup of analog video decoder
>       [media] au8522: Fix off-by-one in SNR table for QAM256
>       [media] au8522: properly recover from the au8522 delivering misaligned TS streams
>       [media] au0828: Make the s_reg and g_reg advanced debug calls work against the bridge
>       [media] xc5000: properly show quality register values
>       [media] xc5000: add support for showing the SNR and gain in the debug output
>       [media] xc5000: properly report i2c write failures
>       [media] au0828: fix race condition that causes xc5000 to not bind for digital
>       [media] au0828: make sure video standard is setup in tuner-core
>       [media] au8522: fix regression in logging introduced by separation of modules
>       [media] xc5000: don't invoke auto calibration unless we really did reset tuner
>       [media] au0828: prevent i2c gate from being kept open while in analog mode
>       [media] au0828: fix case where STREAMOFF being called on stopped stream causes BUG()
>       [media] au0828: speed up i2c clock when doing xc5000 firmware load
>       [media] au0828: remove control buffer from send_control_msg
>       [media] au0828: tune retry interval for i2c interaction
>       [media] xc5000: reset device if encountering PLL lock failure
>       [media] xc5000: add support for firmware load check and init status
>       [media] au0828: tweak workaround for i2c clock stretching bug
>       [media] xc5000: show debug version fields in decimal instead of hex
>       [media] au0828: fix a couple of missed edge cases for i2c gate with analog
>       [media] au0828: make xc5000 firmware speedup apply to the xc5000c as well
>       [media] xc5000: change filename to production/redistributable xc5000c firmware
>       [media] au0828: fix possible race condition in usage of dev->ctrlmsg
>
> Djuri Baars (1):
>       [media] Add support for the Terratec Cinergy T Dual PCIe IR remote
>
> Emil Goode (3):
>       [media] cx88: Remove duplicate const
>       [media] media: coda: add const qualifiers
>       [media] gspca: dubious one-bit signed bitfield
>
> Evgeny Plehov (4):
>       [media] ttpci: add support for Omicom S2 PCI
>       [media] dvb_frontend: add multistream support
>       [media] DocBook: Multistream support
>       [media] stv090x: add support for multistream
>
> Ezequiel Garcia (9):
>       [media] pwc: Use vb2 queue mutex through a single name
>       [media] pwc: Remove unneeded struct vb2_queue clearing
>       [media] stk1160: Make kill/free urb debug message more verbose
>       [media] stk1160: Handle urb allocation failure condition properly
>       [media] stk1160: Fix s_fmt and try_fmt implementation
>       [media] stk1160: Stop device and unqueue buffers when start_streaming() fails
>       [media] vivi: Add return code check at vb2_queue_init()
>       [media] videobuf2-core: Replace BUG_ON and return an error at vb2_queue_init()
>       [media] MAINTAINERS: Add stk1160 driver
>
> Ezequiel García (13):
>       [media] em28xx: Remove useless runtime->private_data usage
>       [media] media: Add stk1160 new driver (easycap replacement)
>       [media] staging: media: Remove easycap driver

Hi Mauro,

We've replaced easycap staging driver with stk1160.
However, stk1160 still misses s-video input support, which I believe
easycap had.

This feature was missing because I couldn't get s-video devices to test with,
but now a couple users have provided the test and the patch is ready.
It's a tiny patch routing saa7115 properly.

I think we should include this feature in v3.7 to complete easycap ->
stk1160 replacement.
Also, it seems to me there's no point in keeping the driver until v3.8,
since there aren't much users out there testing it.

On the other side, I don't want to mess with the flow, so it's
completely up to you.
If you think it's okey, then I can send the patch tonight and
hopefully you can pick
it for your second pull request.

Please let me know.

    Ezequiel
