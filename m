Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389Ab0ITNUG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 09:20:06 -0400
Received: from atl.turmel.org ([74.117.157.138]:57449 "EHLO atl.turmel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755350Ab0ITNUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 09:20:04 -0400
Message-ID: <4C975F79.9060609@turmel.org>
Date: Mon, 20 Sep 2010 09:19:53 -0400
From: Phil Turmel <philip@turmel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100916 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Guillaume Chazarain <guichaz@gmail.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oliver@neukum.org>, Alan Ott <alan@signal11.us>,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        Mat <jackdachef@gmail.com>, Andreas Bombe <aeb@debian.org>,
        Alex Riesen <raa.lkml@gmail.com>
Subject: Re: [BUG, Regression, bisected] USB mouse causes bug on 1st insert,
 ignored on 2nd insert, lsusb stuck at usbdev_open
References: <4C96B9DB.8030403@turmel.org> <AANLkTi=1zh4hD-1uzpgjAsnKZBE=qi_ZAX-ug=2XMkW0@mail.gmail.com> <alpine.LNX.2.00.1009201440140.26813@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1009201440140.26813@pobox.suse.cz>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2010 08:42 AM, Jiri Kosina wrote:
> On Mon, 20 Sep 2010, Guillaume Chazarain wrote:
> 
>>> The USB mouse I use with my laptop is causing a BUG when inserted.  It works at that
>>> point, but if removed and re-inserted, it is ignored.  Also, after the 2nd insert,
>>> other USB devices (like my thumb drive) are also ignored.
>>>
>>> [   37.450777] BUG: unable to handle kernel NULL pointer dereference at (null)
>>> [   37.451148] IP: [<ffffffff817d0991>] hiddev_open+0xc1/0x220
>>> [   37.452036] PGD 1131a0067 PUD 113036067 PMD 0
>>> [   37.452924] Oops: 0000 [#1] PREEMPT SMP
>>> [   37.453336] last sysfs file: /sys/devices/platform/toshiba_acpi/backlight/toshiba/max_brightness
>>> [   37.453336] CPU 1
>>> [   37.453336] Modules linked in: tpm_infineon iwlagn iwlcore tifm_7xx1 tpm_tis toshiba_bluetooth toshiba_acpi tifm_core pcmcia sdhci_pci yenta_socket sdhci [last unloaded: scsi_wait_scan]
>>> [   37.453336]
>>> [   37.453336] Pid: 3117, comm: hald-probe-hidd Not tainted 2.6.36-rc4-00166-g151b6a5 #28 Portable PC/TECRA A9
>>> [   37.453336] RIP: 0010:[<ffffffff817d0991>]  [<ffffffff817d0991>] hiddev_open+0xc1/0x220
> 
> Could please those of you who are able to reproduce the problem (from a 
> quick test seems that I am not) use 'addr2line' utility to convert the RIP 
> value (ffffffff817d0991 in this case) to the line number inside of 
> hiddev_open(), so that we can see whether it's something behind 
> usbhid_find_interface() causing NULL pointer dereference, or whether it is 
> intfdata being NULL and thus going to hid->hiddev faults?

I couldn't quickly figure out how to recover the uncompressed kernel from
the vmlinuz (lzma) short of recompiling.  Here's the relevant section of System.map
if that's of any use....

# grep 'ffffffff817d0' /boot/System.map-2.6.36-rc4-00166-g151b6a5 
ffffffff817d0190 T usbhid_lookup_quirk
ffffffff817d02e0 T usbhid_quirks_exit
ffffffff817d0380 T usbhid_quirks_init
ffffffff817d05e0 t hiddev_lookup_report
ffffffff817d0690 t hiddev_write
ffffffff817d06b0 t hiddev_poll
ffffffff817d0720 t hiddev_usbd_probe
ffffffff817d0730 T hiddev_exit
ffffffff817d0750 T hiddev_disconnect
ffffffff817d07e0 t hiddev_fasync
ffffffff817d0800 t hiddev_release
ffffffff817d08d0 t hiddev_open
ffffffff817d0af0 t hiddev_ioctl_string
ffffffff817d0c70 t hiddev_ioctl_usage

If there's a tool to expand vmlinuz => vmlinux, I love to hear about it.  If you
need me to recompile to get what you need, I can do that.

> (sticking two printk()s in there should do the same as well).

If you give me a patch with exactly the debug stuff you want, I can compile that instead.

Unfortunately, I have some work to do later today that I have to boot this box into Windows
for (CADD), so my compiling and testing window is narrow (until tomorrow).

Phil
