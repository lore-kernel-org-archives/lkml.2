Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab1LZWLO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 17:11:14 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:51878 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372Ab1LZWLM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 17:11:12 -0500
MIME-Version: 1.0
Date: Mon, 26 Dec 2011 17:11:09 -0500
Message-ID: <CAHFgRy-z2Hauw=r=D=LRnxRdgANW0Wq9TSjfOrGKLym6Q5YxgA@mail.gmail.com>
Subject: Offtopic? - I have a vmlinuz-3.2.0-rc7+ kernel file that will not
 load -- ("invalid magic number") with the latest Ubuntu grub2 (1.99-14ubuntu2)
From: Miles Lane <miles.lane@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry to ask a potentially off-topic question, but I have received no
help from the GRUB2 mailing list.
The reply I got was:
     "Well apparently the number you gave it wasn't magic ;) just a
joke. I really don't have a good answer , I wish I did. Sorry , I just
needed to clown for a bit."
http://comments.gmane.org/gmane.comp.boot-loaders.grub.user/974

If noone has time to help, no problemo.  I suppose that when Canonical
releases the final 12.04 that the problem will go away with a fresh
install.

I have a 3.2.0-6 kernel that Canonical built which successfully boots.
 I have tried building a Linus GIT tree kernel using the .config that
Canonical used, but it still fails to boot.
My best guess is that perhaps there is either a problem with my Grub2
(1.99-14ubuntu2) installation, or that something is amiss with my
toolchain.

I am running a WUBI install (the root filesystem is located in a
loopback mounted file on my Windows 7 NTFS filesystem).   The
distribution is Ubuntu 11.10 upgraded to 12.04 (Precise Pangolin).


fdisk:
Disk /dev/sda: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders, total 976773168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x8ea8e911

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *        2048      206847      102400    7  HPFS/NTFS/exFAT
/dev/sda2          206848   976771071   488282112    7  HPFS/NTFS/exFAT

mount:
/dev/loop0 on / type ext3 (rw,commit=0,commit=0)
proc on /proc type proc (rw,noexec,nosuid,nodev)
sysfs on /sys type sysfs (rw,noexec,nosuid,nodev)
none on /sys/fs/fuse/connections type fusectl (rw)
none on /sys/kernel/debug type debugfs (rw)
none on /sys/kernel/security type securityfs (rw)
udev on /dev type devtmpfs (rw,mode=0755)
devpts on /dev/pts type devpts (rw,noexec,nosuid,gid=5,mode=0620)
tmpfs on /run type tmpfs (rw,noexec,nosuid,size=10%,mode=0755)
none on /run/lock type tmpfs (rw,noexec,nosuid,nodev,size=5242880)
none on /run/shm type tmpfs (rw,nosuid,nodev)
/dev/sda2 on /host type fuseblk
(rw,nosuid,nodev,relatime,user_id=0,group_id=0,allow_other,blksize=4096)
binfmt_misc on /proc/sys/fs/binfmt_misc type binfmt_misc
(rw,noexec,nosuid,nodev)
gvfs-fuse-daemon on /home/miles/.gvfs type fuse.gvfs-fuse-daemon
(rw,nosuid,nodev,user=miles)

/boot/grub/grub.cfg:

### BEGIN /etc/grub.d/00_header ###
if [ -s $prefix/grubenv ]; then
  set have_grubenv=true
  load_env
fi
set default="0"
if [ "${prev_saved_entry}" ]; then
  set saved_entry="${prev_saved_entry}"
  save_env saved_entry
  set prev_saved_entry=
  save_env prev_saved_entry
  set boot_once=true
fi

function savedefault {
  if [ -z "${boot_once}" ]; then
    saved_entry="${chosen}"
    save_env saved_entry
  fi
}

function recordfail {
  set recordfail=1
  if [ -n "${have_grubenv}" ]; then if [ -z "${boot_once}" ]; then
save_env recordfail; fi; fi
}

function load_video {
  insmod vbe
  insmod vga
  insmod video_bochs
  insmod video_cirrus
}

insmod part_msdos
insmod ntfs
set root='(hd0,msdos2)'
search --no-floppy --fs-uuid --set=root 9A200E69200E4CA7
loopback loop0 /ubuntu/disks/root.disk
set root=(loop0)
if loadfont /usr/share/grub/unicode.pf2 ; then
  set gfxmode=1680x1050x32
  load_video
  insmod gfxterm
  insmod part_msdos
  insmod ntfs
  set root='(hd0,msdos2)'
  search --no-floppy --fs-uuid --set=root 9A200E69200E4CA7
  loopback loop0 /ubuntu/disks/root.disk
  set root=(loop0)
  set locale_dir=($root)/boot/grub/locale
  set lang=en_US
  insmod gettext
fi
terminal_output gfxterm
if [ "${recordfail}" = 1 ]; then
  set timeout=-1
else
  set timeout=10
fi
### END /etc/grub.d/00_header ###

### BEGIN /etc/grub.d/05_debian_theme ###
set menu_color_normal=white/black
set menu_color_highlight=black/light-gray
if background_color 44,0,30; then
  clear
fi
### END /etc/grub.d/05_debian_theme ###

### BEGIN /etc/grub.d/10_linux ###
### END /etc/grub.d/10_linux ###

### BEGIN /etc/grub.d/10_lupin ###
if [ ${recordfail} != 1 ]; then
  if [ -e ${prefix}/gfxblacklist.txt ]; then
    if hwmatch ${prefix}/gfxblacklist.txt 3; then
      if [ ${match} = 0 ]; then
        set linux_gfx_mode=keep
      else
        set linux_gfx_mode=text
      fi
    else
      set linux_gfx_mode=text
    fi
  else
    set linux_gfx_mode=keep
  fi
else
  set linux_gfx_mode=text
fi
export linux_gfx_mode
if [ "$linux_gfx_mode" != "text" ]; then load_video; fi
menuentry 'Ubuntu, with Linux 3.2.0-6-generic' --class ubuntu --class
gnu-linux --class gnu --class os {
	set gfxpayload=$linux_gfx_mode
	insmod part_msdos
	insmod ntfs
	set root='(hd0,msdos2)'
	search --no-floppy --fs-uuid --set=root 9A200E69200E4CA7
	loopback loop0 /ubuntu/disks/root.disk
	set root=(loop0)
	linux	/boot/vmlinuz-3.2.0-6-generic root=UUID=9A200E69200E4CA7
loop=/ubuntu/disks/root.disk ro   quiet splash vt.handoff=7
	initrd	/boot/initrd.img-3.2.0-6-generic
}
submenu "Previous Linux versions" {
menuentry 'Ubuntu, with Linux 3.2.0-rc7+' --class ubuntu --class
gnu-linux --class gnu --class os {
	set gfxpayload=$linux_gfx_mode
	insmod part_msdos
	insmod ntfs
	set root='(hd0,msdos2)'
	search --no-floppy --fs-uuid --set=root 9A200E69200E4CA7
	loopback loop0 /ubuntu/disks/root.disk
	set root=(loop0)
	linux	/boot/vmlinuz-3.2.0-rc7+ root=UUID=9A200E69200E4CA7
loop=/ubuntu/disks/root.disk ro   quiet splash vt.handoff=7
	initrd	/boot/initrd.img-3.2.0-rc7+
}
### BEGIN /etc/grub.d/41_custom ###
if [ -f  $prefix/custom.cfg ]; then
  source $prefix/custom.cfg;
fi
### END /etc/grub.d/41_custom ###

Gnu C                  4.6
Gnu make               3.81
binutils               2.22
util-linux             2.20.1
mount                  support
module-init-tools      3.16
e2fsprogs              1.42-WIP
pcmciautils            018
PPP                    2.4.5
Linux C Library        2.13
Dynamic linker (ldd)   2.13
Procps                 3.2.8
Net-tools              1.60
Kbd                    1.15.2
Sh-utils               8.13
wireless-tools         30

Modules Loaded:   parport_pc ppdev lp parport hid_logitech_dj joydev
bnep rfcomm bluetooth snd_hda_codec_hdmi snd_hda_codec_realtek
binfmt_misc usbhid hid uvcvideo videodev v4l2_compat_ioctl32
snd_usb_audio snd_usbmidi_lib snd_hda_intel snd_hda_codec snd_hwdep
snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer
snd_seq_device i915 drm_kms_helper drm i2c_algo_bit video mei psmouse
snd serio_raw soundcore snd_page_alloc shpchp e1000e

My system board is an INTEL DH67BL, BIOS
BLH6710H.86A.0110.2011.0415.1506 04/15/2011
