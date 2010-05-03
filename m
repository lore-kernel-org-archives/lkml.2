Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759552Ab0ECPAl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 11:00:41 -0400
Received: from ns.de.thalesgroup.com ([62.225.145.226]:42208 "EHLO
	ns.de.thalesgroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759427Ab0ECPAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 11:00:40 -0400
X-Greylist: delayed 529 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 May 2010 11:00:39 EDT
Message-ID: <569685F045B85741820D0265E0D2999D019CFE84@tddhh01.hh.thales-naval.de>
From: "Dunda, Matthias" <Matthias.Dunda@de.thalesgroup.com>
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: PPC: Problems at early stage after starting from U-Boot
Date: Mon, 3 May 2010 16:51:46 +0200 
MIME-Version: 1.0
X-Mailer: Internet Mail Service (5.5.2650.21)
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01CAEAD0.274D3970"
X-PMX-Version: 5.5.8.383112, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.5.3.143916
X-PMX-Spam: Gauge=IIIIIIII, Probability=8%, Report='
 BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_10000_PLUS 0, TO_NO_NAME 0, __ATTACHMENT_SIZE_0_10K 0, __ATTACHMENT_SIZE_10_25K 0, __CT 0, __CTYPE_HAS_BOUNDARY 0, __CTYPE_MULTIPART 0, __CTYPE_MULTIPART_MIXED 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __IMS_MSGID 0, __IMS_MUA 0, __MIME_VERSION 0, __SANE_MSGID 0, __TO_MALFORMED_2 0'
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01CAEAD0.274D3970
Content-Type: text/plain

Hi everybody,

I am trying to get the 2.6.29.6-rt23 kernel running on our self-designed
board based on a Freescale MPC8568 CPU. I launch the kernel out of U-Boot.

I have serial console output from U-Boot until I reach the point where the
kernel is called.

As I don't see output, I was reading out the memory at the log_buf location
with our Abatron BDI3000 debugger (dump 0x003e1c9c 0x2000)

As I am new to kernel debugging at that early stage, I would really
appreciate if someone could help explaining the log - so far for me it just
says that the device tree is faulty. ;-)

I've attached the log and DTS.

I have no idea where to look next... :-(

Cheers
Matthias


------_=_NextPart_000_01CAEAD0.274D3970
Content-Type: application/octet-stream;
	name="kernel-log.001"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="kernel-log.001"

<4>Invalid tag 0 scanning flattened device tree !=0A=
<4>Invalid tag 0 scanning flattened device tree !=0A=
<4>Invalid tag 0 scanning flattened device tree !=0A=
<0>------------[ cut here ]------------=0A=
<2>Kernel BUG at c039737c [verbose debug info unavailable]=0A=
<4>Oops: Exception in kernel mode, sig: 5 [#1]=0A=
<4>PREEMPT =0A=
<4>Modules linked in:=0A=
<4>NIP: c039737c LR: c03862b8 CTR: c0059b80=0A=
<4>REGS: c03d9ef0 TRAP: 0700   Not tainted  (2.6.29.6-rt23)=0A=
<4>MSR: 00021000 <ME,CE>  CR: 28044022  XER: 00000000=0A=
<4>TASK =3D c03ad508[0] 'swapper' THREAD: c03d8000=0A=
<6>GPR00: 00000001 c03d9fa0 c03ad508 00000000 00400000 00000000 =
00400000 00000000 =0A=
<6>GPR08: 00000000 c0400000 00000096 c03d9fb0 28044028 00000000 =
7ff78e00 00000000 =0A=
<6>GPR16: 7ff494ec 7ff6d634 00000000 00000000 00000000 00000000 =
00000000 00000000 =0A=
<6>GPR24: 00000000 00000000 c03e0000 00000000 00400000 00400000 =
c0400000 c03d9fa0 =0A=
<4>NIP [c039737c] lmb_reserve+0x30/0x5c=0A=
<4>LR [c03862b8] early_init_devtree+0xb4/0x298=0A=
<4>Call Trace:=0A=
<4>[c03d9fa0] [c0397390] lmb_reserve+0x44/0x5c (unreliable)=0A=
<4>[c03d9fb0] [c03862b8] early_init_devtree+0xb4/0x298=0A=
<4>[c03d9fd0] [c038718c] machine_init+0x24/0xa0=0A=
<4>[c03d9ff0] [c00003b0] skpinv+0x2d8/0x318=0A=
<4>Instruction dump:=0A=
<4>9421fff0 7c0802a6 93e1000c 90010014 7c3f0b78 7ca03379 7cc83378 =
7ca72b78 =0A=
<4>7c862378 7c651b78 7c000026 54001ffe <0f000000> 3c60c041 38630948 =
38630830 =0A=
<4>---[ end trace 31fd0ba7d8756001 ]---=0A=
<0>Kernel panic - not syncing: Attempted to kill the idle task!=0A=
<1>Unable to handle kernel paging request for data at address =
0x00000010=0A=
<1>Faulting instruction address: 0xc0067dcc=0A=
<4>Oops: Kernel access of bad area, sig: 11 [#2]=0A=
<4>PREEMPT =0A=
<4>Modules linked in:=0A=
<4>NIP: c0067dcc LR: c006cf90 CTR: c0067d68=0A=
<4>REGS: c03d9ad0 TRAP: 0300   Tainted: G      D     (2.6.29.6-rt23)=0A=
<4>MSR: 00021000 <ME,CE>  CR: 28044024  XER: 00000000=0A=
<4>DEAR: 00000010, ESR: 00000000=0A=
<4>TASK =3D c03ad508[0] 'swapper' THREAD: c03d8000=0A=
<6>GPR00: 00000000 c03d9b80 c03ad508 c03d9bd8 00000000 00000000 =
00000000 00000000 =0A=
<6>GPR08: 793a3765 00000000 00000000 00000000 00000000 00000000 =
7ff78e00 00000000 =0A=
<6>GPR16: 7ff494ec c03d9bd8 c03df180 c03df170 c03e0000 c03e0000 =
00021000 c03d9bd8 =0A=
<6>GPR24: c03e0000 c03e0000 c03d9ef0 00000000 00000000 c03ae4c8 =
00000000 c03d9b80 =0A=
<4>NIP [c0067dcc] ktime_get+0x70/0x15c=0A=
<4>LR [c006cf90] tick_nohz_stop_sched_tick+0x40/0x414=0A=
<4>Call Trace:=0A=
<4>[c03d9b80] [c032f385] 0xc032f385 (unreliable)=0A=
<4>[c03d9bd0] [c006cf90] tick_nohz_stop_sched_tick+0x40/0x414=0A=
<4>[c03d9c20] [c00475a8] irq_exit+0x80/0xac=0A=
<4>[c03d9c30] [c000d74c] timer_interrupt+0xb8/0x110=0A=
<4>[c03d9c50] [c0011af0] ret_from_except+0x0/0x18=0A=
<4>[c03d9d10] [c00406f0] panic+0xb8/0x178=0A=
<4>[c03d9d60] [c0044cc4] do_exit+0x63c/0x6f8=0A=
<4>[c03d9da0] [c000e634] kernel_bad_stack+0x0/0x68=0A=
<4>[c03d9dd0] [c000e988] _exception+0x168/0x194=0A=
<4>[c03d9ec0] [c000ef00] program_check_exception+0x84/0x608=0A=
<4>[c03d9ee0] [c0011aa4] ret_from_except_full+0x0/0x4c=0A=
<4>[c03d9fa0] [c0397390] lmb_reserve+0x44/0x5c=0A=
<4>[c03d9fb0] [c03862b8] early_init_devtree+0xb4/0x298=0A=
<4>[c03d9fd0] [c038718c] machine_init+0x24/0xa0=0A=
<4>[c03d9ff0] [c00003b0] skpinv+0x2d8/0x318=0A=
<4>Instruction dump:=0A=
<4>3f20c03e 3e80c03e 3ea0c03e 83d9f160 3a54f180 3a75f170 3f00c03e =
73db0001 =0A=
<4>408200bc 8138f188 8154f180 8175f170 <81290010> 80130004 83920004 =
7f4a5a14 =0A=
<4>---[ end trace 31fd0ba7d8756002 ]---=0A=
<0>Kernel panic - not syncing: Attempted to kill the idle task!=0A=

------_=_NextPart_000_01CAEAD0.274D3970
Content-Type: application/octet-stream;
	name="thales_dge.dts"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="thales_dge.dts"

/dts-v1/;=0A=
=0A=
/ {=0A=
	model =3D "ThalesDGE";=0A=
	#address-cells =3D <1>;=0A=
	#size-cells =3D <1>;=0A=
=0A=
	aliases {=0A=
		ethernet0 =3D &enet0;=0A=
		ethernet1 =3D &enet1;=0A=
		ethernet2 =3D &enet2;=0A=
		ethernet3 =3D &enet3;=0A=
		ethernet4 =3D &enet4;=0A=
		serial0 =3D &serial0;=0A=
		serial1 =3D &serial1;=0A=
		serial2 =3D &serial2;=0A=
		serial3 =3D &serial3;=0A=
		pci0 =3D &pci0;=0A=
		pci1 =3D &pci1;=0A=
	};=0A=
=0A=
	cpus {=0A=
		#address-cells =3D <1>;=0A=
		#size-cells =3D <0>;=0A=
=0A=
		PowerPC,8568@0 {=0A=
			device_type =3D "cpu";=0A=
			reg =3D <0x0>;=0A=
			d-cache-line-size =3D <32>;	// 32 bytes=0A=
			i-cache-line-size =3D <32>;	// 32 bytes=0A=
			d-cache-size =3D <0x8000>;	// L1, 32K=0A=
			i-cache-size =3D <0x8000>;	// L1, 32K=0A=
			timebase-frequency =3D <0>;=0A=
			bus-frequency =3D <0>;=0A=
			clock-frequency =3D <0>;=0A=
			next-level-cache =3D <&L2>;=0A=
		};=0A=
	};=0A=
=0A=
	memory {=0A=
		device_type =3D "memory";=0A=
		reg =3D <0x0 0x80000000>;	// start at 0x0, have 2 GB=0A=
	};=0A=
=0A=
	/* SOC =3D system-on-a-chip */=0A=
	soc8568@e0000000 {=0A=
		device_type =3D "soc";=0A=
		#address-cells =3D <1>;=0A=
		#size-cells =3D <1>;=0A=
		compatible =3D "simple-bus";=0A=
=0A=
		/* ranges: bus address, parent bus address, size */=0A=
		ranges =3D <0x0 0xe0000000 0x100000>;=0A=
=0A=
		reg =3D <0xe0000000 0x1000>;=0A=
		bus-frequency =3D <0>;=0A=
=0A=
		memory-controller@2000 {=0A=
			compatible =3D "fsl,8568-memory-controller";=0A=
			reg =3D <0x2000 0x1000>;=0A=
			interrupt-parent =3D <&mpic>;=0A=
			interrupts =3D <18 2>;=0A=
		};=0A=
=0A=
		L2: l2-cache-controller@20000 {=0A=
			compatible =3D "fsl,8568-l2-cache-controller";=0A=
			reg =3D <0x20000 0x1000>;=0A=
			cache-line-size =3D <32>;	// 32 bytes=0A=
			cache-size =3D <0x80000>;	// L2, 512K=0A=
			interrupt-parent =3D <&mpic>;=0A=
			interrupts =3D <16 2>;=0A=
		};=0A=
=0A=
		i2c@3000 {=0A=
			#address-cells =3D <1>;=0A=
			#size-cells =3D <0>;=0A=
			cell-index =3D <0>;=0A=
			compatible =3D "fsl-i2c";=0A=
			reg =3D <0x3000 0x100>;=0A=
			interrupts =3D <43 2>;=0A=
			interrupt-parent =3D <&mpic>;=0A=
			dfsrr;=0A=
=0A=
			rtc@68 {=0A=
				//compatible =3D "dallas,ds1307";=0A=
				compatible =3D "st,m41t00";=0A=
				reg =3D <0x68>;=0A=
			};=0A=
		};=0A=
=0A=
		i2c@3100 {=0A=
			#address-cells =3D <1>;=0A=
			#size-cells =3D <0>;=0A=
			cell-index =3D <1>;=0A=
			compatible =3D "fsl-i2c";=0A=
			reg =3D <0x3100 0x100>;=0A=
			interrupts =3D <43 2>;=0A=
			interrupt-parent =3D <&mpic>;=0A=
			dfsrr;=0A=
		};=0A=
=0A=
		dma@21300 {=0A=
			#address-cells =3D <1>;=0A=
			#size-cells =3D <1>;=0A=
			compatible =3D "fsl,mpc8568-dma", "fsl,eloplus-dma";=0A=
			reg =3D <0x21300 0x4>;=0A=
			ranges =3D <0x0 0x21100 0x200>;=0A=
			cell-index =3D <0>;=0A=
			dma-channel@0 {=0A=
				compatible =3D "fsl,mpc8568-dma-channel",=0A=
						"fsl,eloplus-dma-channel";=0A=
				reg =3D <0x0 0x80>;=0A=
				cell-index =3D <0>;=0A=
				interrupt-parent =3D <&mpic>;=0A=
				interrupts =3D <20 2>;=0A=
			};=0A=
			dma-channel@80 {=0A=
				compatible =3D "fsl,mpc8568-dma-channel",=0A=
						"fsl,eloplus-dma-channel";=0A=
				reg =3D <0x80 0x80>;=0A=
				cell-index =3D <1>;=0A=
				interrupt-parent =3D <&mpic>;=0A=
				interrupts =3D <21 2>;=0A=
			};=0A=
			dma-channel@100 {=0A=
				compatible =3D "fsl,mpc8568-dma-channel",=0A=
						"fsl,eloplus-dma-channel";=0A=
				reg =3D <0x100 0x80>;=0A=
				cell-index =3D <2>;=0A=
				interrupt-parent =3D <&mpic>;=0A=
				interrupts =3D <22 2>;=0A=
			};=0A=
			dma-channel@180 {=0A=
				compatible =3D "fsl,mpc8568-dma-channel",=0A=
						"fsl,eloplus-dma-channel";=0A=
				reg =3D <0x180 0x80>;=0A=
				cell-index =3D <3>;=0A=
				interrupt-parent =3D <&mpic>;=0A=
				interrupts =3D <23 2>;=0A=
			};=0A=
		};=0A=
=0A=
		mdio@24520 {=0A=
			#address-cells =3D <1>;=0A=
			#size-cells =3D <0>;=0A=
			compatible =3D "fsl,gianfar-mdio";=0A=
			reg =3D <0x24520 0x20>;=0A=
=0A=
			phy0: ethernet-phy@1 {=0A=
				interrupt-parent =3D <&mpic>;=0A=
				interrupts =3D <1 1>;=0A=
				reg =3D <0x1>;=0A=
				device_type =3D "ethernet-phy";=0A=
			};=0A=
			phy1: ethernet-phy@2 {=0A=
				interrupt-parent =3D <&mpic>;=0A=
				interrupts =3D <1 1>;=0A=
				reg =3D <0x2>;=0A=
				device_type =3D "ethernet-phy";=0A=
			};=0A=
			phy2: ethernet-phy@3 {=0A=
				interrupt-parent =3D <&mpic>;=0A=
				interrupts =3D <1 1>;=0A=
				reg =3D <0x3>;=0A=
				device_type =3D "ethernet-phy";=0A=
			};=0A=
			phy3: ethernet-phy@4 {=0A=
				interrupt-parent =3D <&mpic>;=0A=
				interrupts =3D <1 1>;=0A=
				reg =3D <0x4>;=0A=
				device_type =3D "ethernet-phy";=0A=
			};=0A=
			phy4: ethernet-phy@5 {=0A=
				interrupt-parent =3D <&mpic>;=0A=
				interrupts =3D <1 1>;=0A=
				reg =3D <0x5>;=0A=
				device_type =3D "ethernet-phy";=0A=
			};=0A=
		};=0A=
=0A=
		enet0: ethernet@24000 {=0A=
			cell-index =3D <0>;=0A=
			device_type =3D "network";=0A=
			model =3D "eTSEC";=0A=
			compatible =3D "gianfar";=0A=
			reg =3D <0x24000 0x1000>;=0A=
			local-mac-address =3D [ 00 00 00 00 00 00 ];=0A=
 			interrupts =3D <29 2 30 2 34 2>;=0A=
			interrupt-parent =3D <&mpic>;=0A=
			phy =3D <&phy0>;=0A=
		};=0A=
=0A=
		enet1: ethernet@25000 {=0A=
			cell-index =3D <1>;=0A=
			device_type =3D "network";=0A=
			model =3D "eTSEC";=0A=
			compatible =3D "gianfar";=0A=
			reg =3D <0x25000 0x1000>;=0A=
			local-mac-address =3D [ 00 00 00 00 00 00 ];=0A=
 			interrupts =3D <35 2 36 2 40 2>;=0A=
			interrupt-parent =3D <&mpic>;=0A=
			phy =3D <&phy1>;=0A=
		};=0A=
=0A=
		global-utilities@e0000 {	//global utilities block=0A=
			compatible =3D "fsl,mpc8548-guts";=0A=
			reg =3D <0xe0000 0x1000>;=0A=
			fsl,has-rstcr;=0A=
		};=0A=
=0A=
		serial0: serial@4500 {=0A=
			cell-index =3D <0>;=0A=
			device_type =3D "serial";=0A=
			compatible =3D "ns16550";=0A=
			reg =3D <0x4500 0x100>;=0A=
			clock-frequency =3D <0>;=0A=
			interrupts =3D <42 2>;=0A=
			interrupt-parent =3D <&mpic>;=0A=
		};=0A=
=0A=
		serial1: serial@4600 {=0A=
			cell-index =3D <1>;=0A=
			device_type =3D "serial";=0A=
			compatible =3D "ns16550";=0A=
			reg =3D <0x4600 0x100>;=0A=
			clock-frequency =3D <0>;=0A=
			interrupts =3D <42 2>;=0A=
			interrupt-parent =3D <&mpic>;=0A=
		};=0A=
=0A=
		crypto@30000 {=0A=
			compatible =3D "fsl,sec2.1", "fsl,sec2.0";=0A=
			reg =3D <0x30000 0x10000>;=0A=
			interrupts =3D <45 2>;=0A=
			interrupt-parent =3D <&mpic>;=0A=
			fsl,num-channels =3D <4>;=0A=
			fsl,channel-fifo-len =3D <24>;=0A=
			fsl,exec-units-mask =3D <0xfe>;=0A=
			fsl,descriptor-types-mask =3D <0x12b0ebf>;=0A=
		};=0A=
=0A=
		mpic: pic@40000 {=0A=
			interrupt-controller;=0A=
			#address-cells =3D <0>;=0A=
			#interrupt-cells =3D <2>;=0A=
			reg =3D <0x40000 0x40000>;=0A=
			compatible =3D "chrp,open-pic";=0A=
			device_type =3D "open-pic";=0A=
		};=0A=
=0A=
		par_io@e0100 {=0A=
			reg =3D <0xe0100 0x100>;=0A=
			device_type =3D "par_io";=0A=
			num-ports =3D <7>;=0A=
=0A=
			/* Ethernet Subsystem 1 */=0A=
			pio1: ucc_pin@01 {=0A=
				pio-map =3D <=0A=
			/*=0A=
			port	pin	dir	open_dr assign	has_irq=0A=
			=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =
*/=0A=
			0x4	0xa	0x1	0x0	0x2	0x0 	/* TxD0 */=0A=
			0x4	0x9	0x1	0x0	0x2	0x0 	/* TxD1 */=0A=
			0x4	0x8	0x1	0x0	0x2	0x0 	/* TxD2 */=0A=
			0x4	0x7	0x1	0x0	0x2	0x0 	/* TxD3 */=0A=
			0x4	0x17	0x1	0x0	0x2	0x0 	/* TxD4 */=0A=
			0x4	0x16	0x1	0x0	0x2	0x0 	/* TxD5 */=0A=
			0x4	0x15	0x1	0x0	0x2	0x0 	/* TxD6 */=0A=
			0x4	0x14	0x1	0x0	0x2	0x0 	/* TxD7 */=0A=
			0x4	0xf	0x2	0x0	0x2	0x0 	/* RxD0 */=0A=
			0x4	0xe	0x2	0x0	0x2	0x0 	/* RxD1 */=0A=
			0x4	0xd	0x2	0x0	0x2	0x0 	/* RxD2 */=0A=
			0x4	0xc	0x2	0x0	0x2	0x0 	/* RxD3 */=0A=
			0x4	0x1d	0x2	0x0	0x2	0x0 	/* RxD4 */=0A=
			0x4	0x1c	0x2	0x0	0x2	0x0 	/* RxD5 */=0A=
			0x4	0x1b	0x2	0x0	0x2	0x0 	/* RxD6 */=0A=
			0x4	0x1a	0x2	0x0	0x2	0x0 	/* RxD7 */=0A=
			0x4	0xb	0x1	0x0	0x2	0x0 	/* TX_EN */=0A=
			0x4	0x18	0x1	0x0	0x2	0x0 	/* TX_ER */=0A=
			0x4	0x10	0x2	0x0	0x2	0x0 	/* RX_DV */=0A=
			0x4	0x1e	0x2	0x0	0x2	0x0 	/* RX_ER */=0A=
			0x4	0x11	0x2	0x0	0x2	0x0 	/* RX_CLK */=0A=
			0x4	0x13	0x1	0x0	0x2	0x0 	/* GTX_CLK */=0A=
			0x4	0x12	0x2	0x0	0x3	0x0>;	/* GTX125 - TODO: check */=0A=
			};=0A=
=0A=
			/* Ethernet Subsystem 2 */=0A=
			pio2: ucc_pin@02 {=0A=
				pio-map =3D <=0A=
			/*=0A=
			port	pin	dir	open_dr assign	has_irq=0A=
			=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =
*/=0A=
			0x5  0xa 0x1  0x0  0x2  0x0   /* TxD0 */=0A=
			0x5  0x9 0x1  0x0  0x2  0x0   /* TxD1 */=0A=
			0x5  0x8 0x1  0x0  0x2  0x0   /* TxD2 */=0A=
			0x5  0x7 0x1  0x0  0x2  0x0   /* TxD3 */=0A=
			0x5  0x17 0x1  0x0  0x2  0x0   /* TxD4 */=0A=
			0x5  0x16 0x1  0x0  0x2  0x0   /* TxD5 */=0A=
			0x5  0x15 0x1  0x0  0x2  0x0   /* TxD6 */=0A=
			0x5  0x14 0x1  0x0  0x2  0x0   /* TxD7 */=0A=
			0x5  0xf 0x2  0x0  0x2  0x0   /* RxD0 */=0A=
			0x5  0xe 0x2  0x0  0x2  0x0   /* RxD1 */=0A=
			0x5  0xd 0x2  0x0  0x2  0x0   /* RxD2 */=0A=
			0x5  0xc 0x2  0x0  0x2  0x0   /* RxD3 */=0A=
			0x5  0x1d 0x2  0x0  0x2  0x0   /* RxD4 */=0A=
			0x5  0x1c 0x2  0x0  0x2  0x0   /* RxD5 */=0A=
			0x5  0x1b 0x2  0x0  0x2  0x0   /* RxD6 */=0A=
			0x5  0x1a 0x2  0x0  0x2  0x0   /* RxD7 */=0A=
			0x5  0xb 0x1  0x0  0x2  0x0   /* TX_EN */=0A=
			0x5  0x18 0x1  0x0  0x2  0x0   /* TX_ER */=0A=
			0x5  0x10 0x2  0x0  0x2  0x0   /* RX_DV */=0A=
			0x5  0x1e 0x2  0x0  0x2  0x0   /* RX_ER */=0A=
			0x5  0x11 0x2  0x0  0x2  0x0   /* RX_CLK */=0A=
			0x5  0x13 0x1  0x0  0x2  0x0   /* GTX_CLK */=0A=
			0x5  0x12 0x2  0x0  0x3  0x0>; /* GTX125 - TODO: check */=0A=
			};=0A=
=0A=
			/* Ethernet Maintenance */=0A=
			pio4: ucc_pin@04 {=0A=
				pio-map =3D <=0A=
			/*=0A=
			port	pin	dir	open_dr assign	has_irq=0A=
			=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =
*/=0A=
			2	21	1	0	2	0 	/* TxD0 */=0A=
			2	20	1	0	2	0 	/* TxD1 */=0A=
			2	28	1	0	2	0 	/* TxD2 */=0A=
			2	27	1	0	2	0 	/* TxD3 */=0A=
			2	8	1	0	1	0 	/* TxD4 */=0A=
			2	7	1	0	1	0 	/* TxD5 */=0A=
			2	6	1	0	1	0 	/* TxD6 */=0A=
			2	5	1	0	1	0 	/* TxD7 */=0A=
			2	24	2	0	2	0 	/* RxD0 */=0A=
			2	23	2	0	2	0 	/* RxD1 */=0A=
			2	31	2	0	2	0 	/* RxD2 */=0A=
			2	30	2	0	2	0 	/* RxD3 */=0A=
			2	13	2	0	1	0 	/* RxD4 */=0A=
			2	12	2	0	1	0 	/* RxD5 */=0A=
			2	11	2	0	1	0 	/* RxD6 */=0A=
			2	10	2	0	1	0 	/* RxD7 */=0A=
			2	22	1	0	2	0 	/* TX_EN */=0A=
			2	29	1	0	2	0 	/* TX_ER */=0A=
			2	25	2	0	2	0 	/* RX_DV */=0A=
			2	26	2	0	2	0 	/* RX_ER */=0A=
			3	22	2	0	2	0 	/* RX_CLK */=0A=
			2	9	1	0	1	0 	/* GTX_CLK */=0A=
			3	23	2	0	3	0>;	/* GTX125 - TODO: check */=0A=
			};=0A=
		};=0A=
	};=0A=
=0A=
	qe@e0080000 {=0A=
		#address-cells =3D <1>;=0A=
		#size-cells =3D <1>;=0A=
		device_type =3D "qe";=0A=
		compatible =3D "fsl,qe";=0A=
		ranges =3D <0x0 0xe0080000 0x40000>;=0A=
		reg =3D <0xe0080000 0x480>;=0A=
		brg-frequency =3D <0>;=0A=
		bus-frequency =3D <396000000>;=0A=
=0A=
		muram@10000 {=0A=
 			#address-cells =3D <1>;=0A=
 			#size-cells =3D <1>;=0A=
			compatible =3D "fsl,qe-muram", "fsl,cpm-muram";=0A=
			ranges =3D <0x0 0x10000 0x10000>;=0A=
=0A=
			data-only@0 {=0A=
				compatible =3D "fsl,qe-muram-data",=0A=
					     "fsl,cpm-muram-data";=0A=
				reg =3D <0x0 0x10000>;=0A=
			};=0A=
		};=0A=
=0A=
		spi@4c0 {=0A=
			cell-index =3D <0>;=0A=
			compatible =3D "fsl,spi";=0A=
			reg =3D <0x4c0 0x40>;=0A=
			interrupts =3D <2>;=0A=
			interrupt-parent =3D <&qeic>;=0A=
			mode =3D "cpu";=0A=
		};=0A=
=0A=
		spi@500 {=0A=
			cell-index =3D <1>;=0A=
			compatible =3D "fsl,spi";=0A=
			reg =3D <0x500 0x40>;=0A=
			interrupts =3D <1>;=0A=
			interrupt-parent =3D <&qeic>;=0A=
			mode =3D "cpu";=0A=
		};=0A=
=0A=
		enet2: ucc@2000 {=0A=
			device_type =3D "network";=0A=
			compatible =3D "ucc_geth";=0A=
			cell-index =3D <1>;=0A=
			reg =3D <0x2000 0x200>;=0A=
			interrupts =3D <32>;=0A=
			interrupt-parent =3D <&qeic>;=0A=
			local-mac-address =3D [ 00 00 00 00 00 00 ];=0A=
			rx-clock-name =3D "none";=0A=
			tx-clock-name =3D "clk15";=0A=
			pio-handle =3D <&pio1>;=0A=
			phy-handle =3D <&phy2>;=0A=
			phy-connection-type =3D "gmii-id";=0A=
		};=0A=
=0A=
		enet3: ucc@3000 {=0A=
			device_type =3D "network";=0A=
			compatible =3D "ucc_geth";=0A=
			cell-index =3D <2>;=0A=
			reg =3D <0x3000 0x200>;=0A=
			interrupts =3D <33>;=0A=
			interrupt-parent =3D <&qeic>;=0A=
			local-mac-address =3D [ 00 00 00 00 00 00 ];=0A=
			rx-clock-name =3D "none";=0A=
			tx-clock-name =3D "clk17";=0A=
			pio-handle =3D <&pio2>;=0A=
			phy-handle =3D <&phy3>;=0A=
			phy-connection-type =3D "gmii-id";=0A=
		};=0A=
=0A=
		enet4: ucc@3200 {=0A=
			device_type =3D "network";=0A=
			compatible =3D "ucc_geth";=0A=
			cell-index =3D <2>;=0A=
			reg =3D <0x3200 0x200>;=0A=
			interrupts =3D <35>;=0A=
			interrupt-parent =3D <&qeic>;=0A=
			local-mac-address =3D [ 00 00 00 00 00 00 ];=0A=
			rx-clock-name =3D "none";=0A=
			tx-clock-name =3D "clk8";=0A=
			pio-handle =3D <&pio4>;=0A=
			phy-handle =3D <&phy4>;=0A=
			phy-connection-type =3D "gmii-id";=0A=
		};=0A=
=0A=
		qeic: interrupt-controller@80 {=0A=
			interrupt-controller;=0A=
			compatible =3D "fsl,qe-ic";=0A=
			#address-cells =3D <0>;=0A=
			#interrupt-cells =3D <1>;=0A=
			reg =3D <0x80 0x80>;=0A=
			big-endian;=0A=
			interrupts =3D <46 2 46 2>; //high:30 low:30=0A=
			interrupt-parent =3D <&mpic>;=0A=
		};=0A=
=0A=
	};=0A=
=0A=
	pci0: pci@e0008000 {=0A=
		cell-index =3D <0>;=0A=
		interrupt-map-mask =3D <0xf800 0x0 0x0 0x7>;=0A=
		interrupt-map =3D <=0A=
			/* IDSEL 0x12 AD18 */=0A=
			0x9000 0x0 0x0 0x1 &mpic 0x5 0x1=0A=
			0x9000 0x0 0x0 0x2 &mpic 0x6 0x1=0A=
			0x9000 0x0 0x0 0x3 &mpic 0x7 0x1=0A=
			0x9000 0x0 0x0 0x4 &mpic 0x4 0x1=0A=
=0A=
			/* IDSEL 0x13 AD19 */=0A=
			0x9800 0x0 0x0 0x1 &mpic 0x6 0x1=0A=
			0x9800 0x0 0x0 0x2 &mpic 0x7 0x1=0A=
			0x9800 0x0 0x0 0x3 &mpic 0x4 0x1=0A=
			0x9800 0x0 0x0 0x4 &mpic 0x5 0x1>;=0A=
=0A=
		interrupt-parent =3D <&mpic>;=0A=
		interrupts =3D <24 2>;=0A=
		bus-range =3D <0 255>;=0A=
		ranges =3D <0x2000000 0x0 0x80000000 0x80000000 0x0 0x20000000=0A=
			  0x1000000 0x0 0x0 0xe2000000 0x0 0x800000>;=0A=
		clock-frequency =3D <33333333>;=0A=
		#interrupt-cells =3D <1>;=0A=
		#size-cells =3D <2>;=0A=
		#address-cells =3D <3>;=0A=
		reg =3D <0xe0008000 0x1000>;=0A=
		compatible =3D "fsl,mpc8540-pci";=0A=
		device_type =3D "pci";=0A=
	};=0A=
=0A=
	/* PCI Express */=0A=
	pci1: pcie@e000a000 {=0A=
		cell-index =3D <2>;=0A=
		interrupt-map-mask =3D <0xf800 0x0 0x0 0x7>;=0A=
		interrupt-map =3D <=0A=
=0A=
			/* IDSEL 0x0 (PEX) */=0A=
			00000 0x0 0x0 0x1 &mpic 0x0 0x1=0A=
			00000 0x0 0x0 0x2 &mpic 0x1 0x1=0A=
			00000 0x0 0x0 0x3 &mpic 0x2 0x1=0A=
			00000 0x0 0x0 0x4 &mpic 0x3 0x1>;=0A=
=0A=
		interrupt-parent =3D <&mpic>;=0A=
		interrupts =3D <26 2>;=0A=
		bus-range =3D <0 255>;=0A=
		ranges =3D <0x2000000 0x0 0xa0000000 0xa0000000 0x0 0x10000000=0A=
			  0x1000000 0x0 0x0 0xe2800000 0x0 0x800000>;=0A=
		clock-frequency =3D <33333333>;=0A=
		#interrupt-cells =3D <1>;=0A=
		#size-cells =3D <2>;=0A=
		#address-cells =3D <3>;=0A=
		reg =3D <0xe000a000 0x1000>;=0A=
		compatible =3D "fsl,mpc8548-pcie";=0A=
		device_type =3D "pci";=0A=
		pcie@0 {=0A=
			reg =3D <0x0 0x0 0x0 0x0 0x0>;=0A=
			#size-cells =3D <2>;=0A=
			#address-cells =3D <3>;=0A=
			device_type =3D "pci";=0A=
			ranges =3D <0x2000000 0x0 0xa0000000=0A=
				  0x2000000 0x0 0xa0000000=0A=
				  0x0 0x10000000=0A=
=0A=
				  0x1000000 0x0 0x0=0A=
				  0x1000000 0x0 0x0=0A=
				  0x0 0x800000>;=0A=
		};=0A=
	};=0A=
};=0A=
=0A=

------_=_NextPart_000_01CAEAD0.274D3970--
