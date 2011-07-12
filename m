Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab1GLArh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 20:47:37 -0400
Received: from ppp118-208-123-30.lns20.bne4.internode.on.net ([118.208.123.30]:56472
	"EHLO mail.psychogeeks.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754640Ab1GLArg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 20:47:36 -0400
X-Greylist: delayed 534 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Jul 2011 20:47:35 EDT
Message-ID: <4E1B978C.2030407@psychogeeks.com>
Date: Tue, 12 Jul 2011 10:38:36 +1000
From: Chris W <lkml@psychogeeks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110620 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Imon module Oops and kernel hang
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All,

The following report applies to 2.6.39.3 (vanilla code).  I also see it
consistently on 2.6.39.2 and 2.6.38-gentoo-r6.

I am trying to switch to using the in-kernel modules for my remote
control and vfd display needs.   I have built the kernel with the mceusb
module for the MCE remote that I use to control the machine and the imon
module to provide an LCD interface for lcdproc (I don't use that actual
remote). There's also another, unused, remote interface on one of my DVB
cards (rc_winfast module).   Kernel modules for the MCE and other remote
load fine.

Attempting to load the imon module crashes Linux hard (no recovery other
than hard reset).  Details are below.  It seems to be related to
keytables.   The iMon device is an older VFD device in a Silverstone
case, with mouse control on the remote, no volume knob.  Details of the
iMon USB device are below the crash details.

I hope this is a dumb mistake on my part.  I would appreciate any
assistance.
Regards,
Chris


root@kepler # modprobe -v imon debug=1
(I have also tried specifying display_type=1)

root@newton # cat /var/log/kepler-netconsole.log
Jul 12 09:44:20 kepler BUG: unable to handle kernel
Jul 12 09:44:20 kepler NULL pointer dereference
Jul 12 09:44:20 kepler at 000000dc
Jul 12 09:44:20 kepler IP:
Jul 12 09:44:20 kepler [<f8fbe46e>] rc_g_keycode_from_table+0x1e/0xe0
[rc_core]
Jul 12 09:44:20 kepler *pde = 00000000
Jul 12 09:44:20 kepler
Jul 12 09:44:20 kepler Oops: 0000 [#1]
Jul 12 09:44:20 kepler PREEMPT
Jul 12 09:44:20 kepler
Jul 12 09:44:20 kepler last sysfs file:
/sys/devices/pci0000:00/0000:00:10.2/usb4/4-2/4-2:1.0/input/input6/capabilities/key
Jul 12 09:44:20 kepler Modules linked in:
Jul 12 09:44:20 kepler imon(+)
Jul 12 09:44:20 kepler netconsole
Jul 12 09:44:20 kepler asb100
Jul 12 09:44:20 kepler hwmon_vid
Jul 12 09:44:20 kepler cx22702
Jul 12 09:44:20 kepler dvb_pll
Jul 12 09:44:20 kepler mt352
Jul 12 09:44:20 kepler cx88_dvb
Jul 12 09:44:20 kepler cx88_vp3054_i2c
Jul 12 09:44:20 kepler rc_winfast
Jul 12 09:44:20 kepler ir_lirc_codec
Jul 12 09:44:20 kepler lirc_dev
Jul 12 09:44:20 kepler ir_sony_decoder
Jul 12 09:44:20 kepler videobuf_dvb
Jul 12 09:44:20 kepler ir_jvc_decoder
Jul 12 09:44:20 kepler ir_rc6_decoder
Jul 12 09:44:20 kepler snd_via82xx
Jul 12 09:44:20 kepler cx8802
Jul 12 09:44:20 kepler cx8800
Jul 12 09:44:20 kepler ir_rc5_decoder
Jul 12 09:44:20 kepler ir_nec_decoder
Jul 12 09:44:20 kepler snd_ac97_codec
Jul 12 09:44:20 kepler ac97_bus
Jul 12 09:44:20 kepler cx88xx
Jul 12 09:44:20 kepler rc_core
Jul 12 09:44:20 kepler b44
Jul 12 09:44:20 kepler i2c_algo_bit
Jul 12 09:44:20 kepler snd_mpu401_uart
Jul 12 09:44:20 kepler tveeprom
Jul 12 09:44:20 kepler snd_rawmidi
Jul 12 09:44:20 kepler btcx_risc
Jul 12 09:44:20 kepler i2c_viapro
Jul 12 09:44:20 kepler videobuf_dma_sg
Jul 12 09:44:20 kepler ssb
Jul 12 09:44:20 kepler mii
Jul 12 09:44:20 kepler videobuf_core
Jul 12 09:44:20 kepler
Jul 12 09:44:20 kepler
Jul 12 09:44:20 kepler Pid: 2981, comm: input_id Not tainted 2.6.39.3 #2
Jul 12 09:44:20 kepler System Manufacturer System Name
Jul 12 09:44:20 kepler /A7V8X
Jul 12 09:44:20 kepler
Jul 12 09:44:20 kepler EIP: 0060:[<f8fbe46e>] EFLAGS: 00010002 CPU: 0
Jul 12 09:44:20 kepler EIP is at rc_g_keycode_from_table+0x1e/0xe0 [rc_core]
Jul 12 09:44:20 kepler EAX: 00000000 EBX: f57f2000 ECX: 00000008 EDX:
00000000
Jul 12 09:44:20 kepler ESI: 00000000 EDI: 00000000 EBP: f7007e48 ESP:
f7007e18
Jul 12 09:44:20 kepler DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Jul 12 09:44:20 kepler Process input_id (pid: 2981, ti=f7006000
task=f5101a40 task.ti=f5102000)
Jul 12 09:44:20 kepler Stack:
Jul 12 09:44:20 kepler 00000001
Jul 12 09:44:20 kepler f7007e30
Jul 12 09:44:20 kepler c101e9ae
Jul 12 09:44:20 kepler f7088a60
Jul 12 09:44:20 kepler 00000001
Jul 12 09:44:20 kepler f7088a60
Jul 12 09:44:20 kepler 00000000
Jul 12 09:44:20 kepler 00000086
Jul 12 09:44:20 kepler
Jul 12 09:44:20 kepler f7007e50
Jul 12 09:44:20 kepler f57f2000
Jul 12 09:44:20 kepler 00000000
Jul 12 09:44:20 kepler 00000000
Jul 12 09:44:20 kepler f7007e58
Jul 12 09:44:20 kepler f87c259c
Jul 12 09:44:20 kepler f57f2000
Jul 12 09:44:20 kepler f57f2041
Jul 12 09:44:20 kepler
Jul 12 09:44:20 kepler f7007edc
Jul 12 09:44:20 kepler f87c26dc
Jul 12 09:44:20 kepler f68880a4
Jul 12 09:44:20 kepler f7007e6c
Jul 12 09:44:20 kepler c11a0865
Jul 12 09:44:20 kepler f7007e74
Jul 12 09:44:20 kepler f68880a4
Jul 12 09:44:20 kepler f7007e98
Jul 12 09:44:20 kepler
Jul 12 09:44:20 kepler Call Trace:
Jul 12 09:44:20 kepler [<c101e9ae>] ? T.889+0x2e/0x50
Jul 12 09:44:20 kepler [<f87c259c>] imon_remote_key_lookup+0x1c/0x70 [imon]
Jul 12 09:44:20 kepler [<f87c26dc>] imon_incoming_packet+0x5c/0xe10 [imon]
Jul 12 09:44:20 kepler [<c11a0865>] ? blk_complete_request+0x15/0x20
Jul 12 09:44:20 kepler [<c12572c8>] ? atapi_qc_complete+0x58/0x2b0
Jul 12 09:44:20 kepler [<c124f353>] ? __ata_qc_complete+0x73/0x110
Jul 12 09:44:20 kepler [<f87c3563>] usb_rx_callback_intf0+0x63/0x70 [imon]
Jul 12 09:44:20 kepler [<c1272cc8>] usb_hcd_giveback_urb+0x48/0xb0
Jul 12 09:44:20 kepler [<c128a5ee>] uhci_giveback_urb+0x8e/0x220
Jul 12 09:44:20 kepler [<c128ac16>] uhci_scan_schedule+0x396/0x9a0
Jul 12 09:44:20 kepler [<c128cfd1>] uhci_irq+0x91/0x170
Jul 12 09:44:20 kepler [<c1271de1>] usb_hcd_irq+0x21/0x50
Jul 12 09:44:20 kepler [<c1051246>] handle_irq_event_percpu+0x36/0x140
Jul 12 09:44:20 kepler [<c1015f06>] ? __io_apic_modify_irq+0x76/0x90
Jul 12 09:44:20 kepler [<c1053000>] ? handle_edge_irq+0x100/0x100
Jul 12 09:44:20 kepler [<c1051382>] handle_irq_event+0x32/0x60
Jul 12 09:44:20 kepler [<c1053045>] handle_fasteoi_irq+0x45/0xc0
Jul 12 09:44:20 kepler <IRQ>
Jul 12 09:44:20 kepler
Jul 12 09:44:20 kepler [<c1003cea>] ? do_IRQ+0x3a/0xb0
Jul 12 09:44:20 kepler [<c1089fcd>] ? sys_read+0x3d/0x70
Jul 12 09:44:20 kepler [<c13d8d69>] ? common_interrupt+0x29/0x30
Jul 12 09:44:20 kepler Code:
Jul 12 09:44:20 kepler ff
Jul 12 09:44:20 kepler ff
Jul 12 09:44:20 kepler 8d
Jul 12 09:44:20 kepler 74
Jul 12 09:44:20 kepler 26
Jul 12 09:44:20 kepler 00
Jul 12 09:44:20 kepler 8d
Jul 12 09:44:20 kepler bc
Jul 12 09:44:20 kepler 27
Jul 12 09:44:20 kepler 00
Jul 12 09:44:20 kepler 00
Jul 12 09:44:20 kepler 00
Jul 12 09:44:20 kepler 00
Jul 12 09:44:20 kepler 55
Jul 12 09:44:20 kepler 89
Jul 12 09:44:20 kepler e5
Jul 12 09:44:20 kepler 57
Jul 12 09:44:20 kepler 56
Jul 12 09:44:20 kepler 53
Jul 12 09:44:20 kepler 83
Jul 12 09:44:20 kepler ec
Jul 12 09:44:20 kepler 24
Jul 12 09:44:20 kepler 89
Jul 12 09:44:20 kepler 45
Jul 12 09:44:20 kepler e8
Jul 12 09:44:20 kepler 9c
Jul 12 09:44:20 kepler 8f
Jul 12 09:44:20 kepler 45
Jul 12 09:44:20 kepler ec
Jul 12 09:44:20 kepler fa
Jul 12 09:44:20 kepler 89
Jul 12 09:44:20 kepler e0
Jul 12 09:44:20 kepler 25
Jul 12 09:44:20 kepler 00
Jul 12 09:44:20 kepler e0
Jul 12 09:44:20 kepler ff
Jul 12 09:44:20 kepler ff
Jul 12 09:44:20 kepler ff
Jul 12 09:44:20 kepler 40
Jul 12 09:44:20 kepler 14
Jul 12 09:44:20 kepler 8b
Jul 12 09:44:20 kepler 45
Jul 12 09:44:20 kepler e8
Jul 12 09:44:20 kepler syslog-ng[2061]: Error processing log message: <8b>
Jul 12 09:44:20 kepler 80
Jul 12 09:44:20 kepler dc
Jul 12 09:44:20 kepler 00
Jul 12 09:44:20 kepler 00
Jul 12 09:44:20 kepler 00
Jul 12 09:44:20 kepler 89
Jul 12 09:44:20 kepler c3
Jul 12 09:44:20 kepler 89
Jul 12 09:44:20 kepler 45
Jul 12 09:44:20 kepler f0
Jul 12 09:44:20 kepler 4b
Jul 12 09:44:20 kepler 78
Jul 12 09:44:20 kepler 38
Jul 12 09:44:20 kepler 8b
Jul 12 09:44:20 kepler 45
Jul 12 09:44:20 kepler e8
Jul 12 09:44:20 kepler 31
Jul 12 09:44:20 kepler c9
Jul 12 09:44:20 kepler 8b
Jul 12 09:44:20 kepler b0
Jul 12 09:44:20 kepler
Jul 12 09:44:20 kepler EIP: [<f8fbe46e>]
Jul 12 09:44:20 kepler rc_g_keycode_from_table+0x1e/0xe0 [rc_core]
Jul 12 09:44:20 kepler SS:ESP 0068:f7007e18
Jul 12 09:44:20 kepler CR2: 00000000000000dc
Jul 12 09:44:20 kepler ---[ end trace 3be02180d283b5a7 ]---
Jul 12 09:44:20 kepler Kernel panic - not syncing: Fatal exception in
interrupt
Jul 12 09:44:20 kepler Pid: 2981, comm: input_id Tainted: G      D    
2.6.39.3 #2
Jul 12 09:44:20 kepler Call Trace:
Jul 12 09:44:20 kepler [<c13d6279>] panic+0x61/0x145
Jul 12 09:44:20 kepler [<c1004ff0>] oops_end+0x80/0x80
Jul 12 09:44:20 kepler [<c101906e>] no_context+0xbe/0x150
Jul 12 09:44:20 kepler [<c101918f>] __bad_area_nosemaphore+0x8f/0x130
Jul 12 09:44:20 kepler [<c1019242>] bad_area_nosemaphore+0x12/0x20
Jul 12 09:44:20 kepler [<c10195fb>] do_page_fault+0x24b/0x410
Jul 12 09:44:20 kepler [<c128bdf6>] ? uhci_alloc_td+0x16/0x40
Jul 12 09:44:20 kepler [<c10400e5>] ? T.312+0x15/0x1b0
Jul 12 09:44:20 kepler [<c10193b0>] ? mm_fault_error+0xe0/0xe0
Jul 12 09:44:20 kepler [<c13d85f4>] error_code+0x58/0x60
Jul 12 09:44:20 kepler [<c10193b0>] ? mm_fault_error+0xe0/0xe0
Jul 12 09:44:20 kepler [<f8fbe46e>] ? rc_g_keycode_from_table+0x1e/0xe0
[rc_core]
Jul 12 09:44:20 kepler [<c101e9ae>] ? T.889+0x2e/0x50
Jul 12 09:44:20 kepler [<f87c259c>] imon_remote_key_lookup+0x1c/0x70 [imon]
Jul 12 09:44:20 kepler [<f87c26dc>] imon_incoming_packet+0x5c/0xe10 [imon]
Jul 12 09:44:20 kepler [<c11a0865>] ? blk_complete_request+0x15/0x20
Jul 12 09:44:20 kepler [<c12572c8>] ? atapi_qc_complete+0x58/0x2b0
Jul 12 09:44:20 kepler [<c124f353>] ? __ata_qc_complete+0x73/0x110
Jul 12 09:44:20 kepler [<f87c3563>] usb_rx_callback_intf0+0x63/0x70 [imon]
Jul 12 09:44:20 kepler [<c1272cc8>] usb_hcd_giveback_urb+0x48/0xb0
Jul 12 09:44:20 kepler [<c128a5ee>] uhci_giveback_urb+0x8e/0x220
Jul 12 09:44:20 kepler [<c128ac16>] uhci_scan_schedule+0x396/0x9a0
Jul 12 09:44:20 kepler [<c128cfd1>] uhci_irq+0x91/0x170
Jul 12 09:44:20 kepler [<c1271de1>] usb_hcd_irq+0x21/0x50
Jul 12 09:44:20 kepler [<c1051246>] handle_irq_event_percpu+0x36/0x140
Jul 12 09:44:20 kepler [<c1015f06>] ? __io_apic_modify_irq+0x76/0x90
Jul 12 09:44:20 kepler [<c1053000>] ? handle_edge_irq+0x100/0x100
Jul 12 09:44:20 kepler [<c1051382>] handle_irq_event+0x32/0x60
Jul 12 09:44:20 kepler [<c1053045>] handle_fasteoi_irq+0x45/0xc0
Jul 12 09:44:20 kepler <IRQ>
Jul 12 09:44:20 kepler [<c1003cea>] ? do_IRQ+0x3a/0xb0
Jul 12 09:44:20 kepler [<c1089fcd>] ? sys_read+0x3d/0x70
Jul 12 09:44:20 kepler [<c13d8d69>] ? common_interrupt+0x29/0x30




root@kepler # lsusb -v -d 15c2:ffdc
Bus 004 Device 003: ID 15c2:ffdc SoundGraph Inc. iMON PAD Remote Controller
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0         8
  idVendor           0x15c2 SoundGraph Inc.
  idProduct          0xffdc iMON PAD Remote Controller
  bcdDevice            0.00
  iManufacturer           0
  iProduct                0
  iSerial                 0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           41
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass         0 (Defined at Interface level)
      bInterfaceSubClass      0
      bInterfaceProtocol      0
      iInterface              0
      ** UNRECOGNIZED:  09 21 00 01 00 01 22 25 00
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval              10
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval              10
Device Status:     0x0000
  (Bus Powered)



# Kernel options from Media/RC
#
# Multimedia drivers
#
CONFIG_RC_CORE=m
CONFIG_LIRC=m
CONFIG_RC_MAP=m
CONFIG_IR_NEC_DECODER=m
CONFIG_IR_RC5_DECODER=m
CONFIG_IR_RC6_DECODER=m
CONFIG_IR_JVC_DECODER=m
CONFIG_IR_SONY_DECODER=m
CONFIG_IR_RC5_SZ_DECODER=m
CONFIG_IR_LIRC_CODEC=m
# CONFIG_IR_ENE is not set
CONFIG_IR_IMON=m
CONFIG_IR_MCEUSB=m
# CONFIG_IR_ITE_CIR is not set
# CONFIG_IR_NUVOTON is not set
# CONFIG_IR_STREAMZAP is not set
# CONFIG_IR_WINBOND_CIR is not set
# CONFIG_RC_LOOPBACK is not set


# cat /proc/cpuinfo
processor    : 0
vendor_id    : AuthenticAMD
cpu family    : 6
model        : 8
model name    : AMD Athlon(TM) XP 2400+
stepping    : 1
cpu MHz        : 2000.091
cache size    : 256 KB
fdiv_bug    : no
hlt_bug        : no
f00f_bug    : no
coma_bug    : no
fpu        : yes
fpu_exception    : yes
cpuid level    : 1
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
cmov pat pse36 mmx fxsr sse syscall mmxext 3dnowext 3dnow
bogomips    : 4000.18
clflush size    : 32
cache_alignment    : 32
address sizes    : 34 bits physical, 32 bits virtual
power management: ts

-- 
Chris Williams
Brisbane, Australia

