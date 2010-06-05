Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436Ab0FEOqA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 10:46:00 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:51309 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756963Ab0FEOp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 10:45:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type;
        b=xcIe8WAdybpQ4qO4ez2v9ReqPSoUGcfElGfM427brXJ4WoIQmPFuY+H9hJOidFvySq
         u8DB7Cs/xliHmag4Cu5V2alXLsuTNq5jXxTo7XJwmTz+vc6nq1SuEajzA1mvNYGqGl48
         2O0vMFuxTrtbO4KCufi9PIXJiAQYVlMCoC85Q=
Message-ID: <4C0A6326.1090100@gmail.com>
Date: Sat, 05 Jun 2010 07:45:58 -0700
From: DanVolkman <danvolkman@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Kernel 2.6.32-22-generic sata problems
Content-Type: multipart/mixed;
 boundary="------------050404000601020908030906"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050404000601020908030906
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

SYNOPSES
==========
Kernel fails to boot when multiple SATA drives are connected.  After a 
day of working on the problem (changing cables, sata positions, 
motherboards, CPUs, power supplies, etc.) I discovered that with only 
the boot drive connected everything worked fine.

BACKGROUND
=============
I had a career in UNIX so it is common for me to use cpio(1), tar(1), 
dump(1), and dd(1) to replicate disks but have not been able to do so 
with two SATA disks connected using older kernels but with this new 
kernel I could not even have the second disk connected.

PROBLEM APPEARED WHEN
======================
An Ubuntu kernel update stopped my computer from booting.  I have no 
backup computer so my description is sketchy because I was not willing 
to use a pencil and write the lengthy terse information.  Boot error 
message was something like:

Gave up waiting for root device. Common problems:0f106d71e58
...
ALERT! /dev/disk/by-uuid/..... does not exist. Dropping to a shell!


Dan
DanVolkman@gmail.com





--------------050404000601020908030906
Content-Type: text/plain;
 name="fstab"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="fstab"

# /etc/fstab: static file system information.
#
# Use 'blkid -o value -s UUID' to print the universally unique identifier
# for a device; this may be used with UUID= as a more robust way to name
# devices that works even if disks are added and removed. See fstab(5).
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
proc            /proc           proc    defaults        0       0
# / was on /dev/sda1 during installation
UUID=0c089174-ffb8-46ac-8efb-af2a78f0a666 /               ext4    errors=remount-ro 0       1
# swap was on /dev/sda5 during installation
UUID=7e39ada2-3f4f-411a-a8c2-49a4e6fdefc9 none            swap    sw              0       0
/dev/scd0       /media/cdrom0   udf,iso9660 user,noauto,exec,utf8 0       0
#/dev/sdb1	/dspace1	ext4	defaults	0	0
#/dev/sdb2	/dspace2	ext4	defaults	0	0

--------------050404000601020908030906
Content-Type: text/plain;
 name="ver_linux"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ver_linux"

If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.
 
Linux dan-desktop 2.6.32-22-generic #36-Ubuntu SMP Thu Jun 3 22:02:19 UTC 2010 i686 GNU/Linux
 
Gnu C                  4.4.3
Gnu make               3.81
binutils               2.20.1
util-linux             2.17.2
mount                  support
module-init-tools      3.11.1
e2fsprogs              1.41.11
pcmciautils            014
Linux C Library        2.11.1
Dynamic linker (ldd)   2.11.1
Procps                 3.2.8
Net-tools              1.60
Kbd                    1.15
Sh-utils               7.4
wireless-tools         30
Modules Loaded         isofs udf crc_itu_t binfmt_misc rfcomm snd_hda_codec_realtek tuner_simple tuner_types wm8775 tda9887 tda8290 snd_hda_intel snd_hda_codec snd_hwdep tuner snd_pcm_oss snd_mixer_oss cx25840 snd_pcm snd_seq_dummy snd_seq_oss sco snd_seq_midi bridge stp snd_rawmidi bnep snd_seq_midi_event snd_seq l2cap snd_timer snd_seq_device ppdev hid_logitech ff_memless ivtv lirc_mceusb fbcon tileblit font bitblit softcursor i2c_algo_bit cx2341x v4l2_common usblp lirc_dev asus_atk0110 parport_pc snd btusb bluetooth usbhid hid nvidia videodev v4l1_compat tveeprom psmouse serio_raw intel_agp soundcore snd_page_alloc vga16fb vgastate agpgart lp parport atl1e

--------------050404000601020908030906
Content-Type: text/plain;
 name="sysinfo"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="sysinfo"

System information report, generated by Sysinfo: 05/06/2010 7:28:51 AM
http://sourceforge.net/projects/gsysinfo

SYSTEM INFORMATION
	Running Ubuntu Linux, the Ubuntu 10.04 (lucid) release.
	GNOME: 2.30.0 (Ubuntu 2010-03-31)
	Kernel version: 2.6.32-22-generic (#36-Ubuntu SMP Thu Jun 3 22:02:19 UTC 2010)
	GCC: 4.4.3 (i486-linux-gnu)
	Xorg: unknown (23 April 2010  05:11:50PM) (23 April 2010  05:11:50PM)
	Hostname: dan-desktop
	Uptime: 0 days 12 h 43 min

CPU INFORMATION
	GenuineIntel, Intel(R) Pentium(R) D CPU 3.00GHz
	Number of CPUs: 1
	CPU clock currently at 2999.721 MHz with 2048 KB cache
	Numbering: family(15) model(6) stepping(2)
	Bogomips: 5999.44
	Flags: fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc up pebs bts pni dtes64 monitor ds_cpl vmx cid cx16 xtpr pdcm lahf_lm tpr_shadow

MEMORY INFORMATION
	Total memory: 3529 MB
	Total swap: 8856 MB

STORAGE INFORMATION
	SCSI device -  scsi2
		Vendor:  ATA      
		Model:  WDC WD2500JS-00N 
	SCSI device -  scsi3
		Vendor:  HP       
		Model:  DVD Writer 1070r 

HARDWARE INFORMATION
MOTHERBOARD
	Host bridge
		Intel Corporation 4 Series Chipset DRAM Controller (rev 03)
		Subsystem: ASUSTeK Computer Inc. Device 836d
	PCI bridge(s)
		Intel Corporation 4 Series Chipset PCI Express Root Port (rev 03)
		Intel Corporation N10/ICH 7 Family PCI Express Port 1 (rev 01)
		Intel Corporation N10/ICH 7 Family PCI Express Port 2 (rev 01)
		Intel Corporation 82801 PCI Bridge (rev e1) (prog-if 01)
		Intel Corporation 4 Series Chipset PCI Express Root Port (rev 03)
		Intel Corporation N10/ICH 7 Family PCI Express Port 1 (rev 01)
		Intel Corporation N10/ICH 7 Family PCI Express Port 2 (rev 01)
		Intel Corporation 82801 PCI Bridge (rev e1) (prog-if 01)
	USB controller(s)
		Intel Corporation N10/ICH7 Family USB UHCI Controller #1 (rev 01)
		Intel Corporation N10/ICH 7 Family USB UHCI Controller #2 (rev 01)
		Intel Corporation N10/ICH 7 Family USB UHCI Controller #3 (rev 01)
		Intel Corporation N10/ICH 7 Family USB UHCI Controller #4 (rev 01)
		Intel Corporation N10/ICH 7 Family USB2 EHCI Controller (rev 01) (prog-if 20)
		Intel Corporation N10/ICH7 Family USB UHCI Controller #1 (rev 01)
		Intel Corporation N10/ICH 7 Family USB UHCI Controller #2 (rev 01)
		Intel Corporation N10/ICH 7 Family USB UHCI Controller #3 (rev 01)
		Intel Corporation N10/ICH 7 Family USB UHCI Controller #4 (rev 01)
		Intel Corporation N10/ICH 7 Family USB2 EHCI Controller (rev 01) (prog-if 20)
	ISA bridge
		Intel Corporation 82801GB/GR (ICH7 Family) LPC Interface Bridge (rev 01)
		Subsystem: ASUSTeK Computer Inc. Device 8179
	IDE interface
		Intel Corporation N10/ICH7 Family SATA IDE Controller (rev 01) (prog-if 8f [Master SecP SecO PriP PriO])
		Subsystem: ASUSTeK Computer Inc. Device 8179

GRAPHIC CARD
	VGA controller
		nVidia Corporation G92 [GeForce 9800 GT] (rev a2)
		Subsystem: eVga.com. Corp. Device c976

SOUND CARD
	Multimedia controller
		Intel Corporation N10/ICH 7 Family High Definition Audio Controller (rev 01)
		Subsystem: ASUSTeK Computer Inc. Device 840b

NETWORK
	Ethernet controller
		Atheros Communications Atheros AR8121/AR8113/AR8114 PCI-E Ethernet Controller (rev b0)
		Subsystem: ASUSTeK Computer Inc. Device 8304

NVIDIA GRAPHIC CARD INFORMATION
	Model name: GeForce 9800 GT
	Card Type: PCI-E 16x
	Video RAM: 512 MB
	GPU Frequency: 650 MHz
	Driver version: NVIDIA UNIX x86 Kernel Module  195.36.15  Thu Mar 11 21:41:46 PST 2010

--------------050404000601020908030906
Content-Type: text/plain;
 name="grub.cfg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="grub.cfg"

#
# DO NOT EDIT THIS FILE
#
# It is automatically generated by /usr/sbin/grub-mkconfig using templates
# from /etc/grub.d and settings from /etc/default/grub
#

### BEGIN /etc/grub.d/00_header ###
if [ -s $prefix/grubenv ]; then
  load_env
fi
set default="0"
if [ ${prev_saved_entry} ]; then
  set saved_entry=${prev_saved_entry}
  save_env saved_entry
  set prev_saved_entry=
  save_env prev_saved_entry
  set boot_once=true
fi

function savedefault {
  if [ -z ${boot_once} ]; then
    saved_entry=${chosen}
    save_env saved_entry
  fi
}

function recordfail {
  set recordfail=1
  if [ -n ${have_grubenv} ]; then if [ -z ${boot_once} ]; then save_env recordfail; fi; fi
}
insmod ext2
set root='(hd0,1)'
search --no-floppy --fs-uuid --set 0c089174-ffb8-46ac-8efb-af2a78f0a666
if loadfont /usr/share/grub/unicode.pf2 ; then
  set gfxmode=640x480
  insmod gfxterm
  insmod vbe
  if terminal_output gfxterm ; then true ; else
    # For backward compatibility with versions of terminal.mod that don't
    # understand terminal_output
    terminal gfxterm
  fi
fi
insmod ext2
set root='(hd0,1)'
search --no-floppy --fs-uuid --set 0c089174-ffb8-46ac-8efb-af2a78f0a666
set locale_dir=($root)/boot/grub/locale
set lang=en
insmod gettext
if [ ${recordfail} = 1 ]; then
  set timeout=-1
else
  set timeout=10
fi
### END /etc/grub.d/00_header ###

### BEGIN /etc/grub.d/05_debian_theme ###
set menu_color_normal=white/black
set menu_color_highlight=black/light-gray
### END /etc/grub.d/05_debian_theme ###

### BEGIN /etc/grub.d/10_linux ###
menuentry 'Ubuntu, with Linux 2.6.32-22-generic' --class ubuntu --class gnu-linux --class gnu --class os {
	recordfail
	insmod ext2
	set root='(hd0,1)'
	search --no-floppy --fs-uuid --set 0c089174-ffb8-46ac-8efb-af2a78f0a666
	linux	/boot/vmlinuz-2.6.32-22-generic root=UUID=0c089174-ffb8-46ac-8efb-af2a78f0a666 ro   quiet splash
	initrd	/boot/initrd.img-2.6.32-22-generic
}
menuentry 'Ubuntu, with Linux 2.6.32-22-generic (recovery mode)' --class ubuntu --class gnu-linux --class gnu --class os {
	recordfail
	insmod ext2
	set root='(hd0,1)'
	search --no-floppy --fs-uuid --set 0c089174-ffb8-46ac-8efb-af2a78f0a666
	echo	'Loading Linux 2.6.32-22-generic ...'
	linux	/boot/vmlinuz-2.6.32-22-generic root=UUID=0c089174-ffb8-46ac-8efb-af2a78f0a666 ro single 
	echo	'Loading initial ramdisk ...'
	initrd	/boot/initrd.img-2.6.32-22-generic
}
menuentry 'Ubuntu, with Linux 2.6.31-21-generic' --class ubuntu --class gnu-linux --class gnu --class os {
	recordfail
	insmod ext2
	set root='(hd0,1)'
	search --no-floppy --fs-uuid --set 0c089174-ffb8-46ac-8efb-af2a78f0a666
	linux	/boot/vmlinuz-2.6.31-21-generic root=UUID=0c089174-ffb8-46ac-8efb-af2a78f0a666 ro   quiet splash
	initrd	/boot/initrd.img-2.6.31-21-generic
}
menuentry 'Ubuntu, with Linux 2.6.31-21-generic (recovery mode)' --class ubuntu --class gnu-linux --class gnu --class os {
	recordfail
	insmod ext2
	set root='(hd0,1)'
	search --no-floppy --fs-uuid --set 0c089174-ffb8-46ac-8efb-af2a78f0a666
	echo	'Loading Linux 2.6.31-21-generic ...'
	linux	/boot/vmlinuz-2.6.31-21-generic root=UUID=0c089174-ffb8-46ac-8efb-af2a78f0a666 ro single 
	echo	'Loading initial ramdisk ...'
	initrd	/boot/initrd.img-2.6.31-21-generic
}
### END /etc/grub.d/10_linux ###

### BEGIN /etc/grub.d/20_memtest86+ ###
menuentry "Memory test (memtest86+)" {
	insmod ext2
	set root='(hd0,1)'
	search --no-floppy --fs-uuid --set 0c089174-ffb8-46ac-8efb-af2a78f0a666
	linux16	/boot/memtest86+.bin
}
menuentry "Memory test (memtest86+, serial console 115200)" {
	insmod ext2
	set root='(hd0,1)'
	search --no-floppy --fs-uuid --set 0c089174-ffb8-46ac-8efb-af2a78f0a666
	linux16	/boot/memtest86+.bin console=ttyS0,115200n8
}
### END /etc/grub.d/20_memtest86+ ###

### BEGIN /etc/grub.d/30_os-prober ###
if [ ${timeout} != -1 ]; then
  if keystatus; then
    if keystatus --shift; then
      set timeout=-1
    else
      set timeout=0
    fi
  else
    if sleep --interruptible 3 ; then
      set timeout=0
    fi
  fi
fi
### END /etc/grub.d/30_os-prober ###

### BEGIN /etc/grub.d/40_custom ###
# This file provides an easy way to add custom menu entries.  Simply type the
# menu entries you want to add after this comment.  Be careful not to change
# the 'exec tail' line above.
### END /etc/grub.d/40_custom ###

--------------050404000601020908030906--
