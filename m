Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932942Ab0FBVK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 17:10:57 -0400
Received: from troy.hostgo.com ([64.62.143.130]:56684 "EHLO troy.hostgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758632Ab0FBVK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 17:10:56 -0400
From: Thomas Fjellstrom <tfjellstrom@strangesoft.net>
To: linux-kernel@vger.kernel.org
Subject: failed command FLUSH CACHE EXT (was: Re: via 8237 sata errors)
Date: Wed, 2 Jun 2010 15:10:51 -0600
User-Agent: KMail/1.13.3 (Linux/2.6.34-0.dmz.6-liquorix-amd64; KDE/4.4.3; x86_64; ; )
Cc: Robert Hancock <hancockrwd@gmail.com>, linux-ide@vger.kernel.org
References: <201005292046.06344.tfjellstrom@strangesoft.net> <201005301348.50004.tfjellstrom@strangesoft.net> <201005301919.16747.tfjellstrom@strangesoft.net>
In-Reply-To: <201005301919.16747.tfjellstrom@strangesoft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006021510.52463.tfjellstrom@strangesoft.net>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - troy.hostgo.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - strangesoft.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 30, 2010, Thomas Fjellstrom wrote:
> On May 30, 2010, Thomas Fjellstrom wrote:
> > On May 30, 2010, Robert Hancock wrote:
> > > On Sun, May 30, 2010 at 1:33 PM, Thomas Fjellstrom
> > > 
> > > <tfjellstrom@strangesoft.net> wrote:
> > > > On May 30, 2010, Thomas Fjellstrom wrote:
> > > >> On May 30, 2010, Robert Hancock wrote:
> > > >> > On 05/29/2010 08:46 PM, Thomas Fjellstrom wrote:
> > > >> > > I'm getting a rather nasty set of messages from dmesg when
> > > >> > > trying to use a couple SATA II WD 2TB Green drives with an
> > > >> > > older system (via 8237 based). They seem to work fine on a
> > > >> > > newer p35 based system.
> > > >> > 
> > > >> > ..
> > > >> > 
> > > >> > > [  283.308963] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0
> > > >> > > action 0x0 [  283.309007] ata2.00: BMDMA stat 0x4
> > > >> > > [  283.309045] ata2.00: failed command: READ DMA
> > > >> > > [  283.309089] ata2.00: cmd
> > > >> > > c8/00:08:08:08:30/00:00:00:00:00/e0 tag 0 dma 4096 in [ 
> > > >> > > 283.309091]          res
> > > >> > > 41/04:00:08:08:30/00:00:00:00:00/e0 Emask 0x1 (device error) [
> > > >> > > 283.309171] ata2.00: status: { DRDY ERR }
> > > >> > > [  283.309207] ata2.00: error: { ABRT }
> > > >> > > [  283.324886] ata2.00: configured for UDMA/133
> > > >> > > [  283.324904] ata2: EH complete
> > > >> > 
> > > >> > It's not really clear why the drive is returning command aborted
> > > >> > on a read, there's no other error bits to indicate an
> > > >> > uncorrectable error or a CRC error. Is it only the one drive
> > > >> > that's giving the errors?
> > > >> 
> > > >> I'm not entirely sure if its the same drive each time. I can make
> > > >> sure today. The fun part is it works fine in a different machine.
> > > >> Where as it will start erroring out like that almost right away in
> > > >> the via based machine. When its doing that, its also making some
> > > >> fairly scary (for a hard drive) noises, but since it doesn't do
> > > >> that in the p35 machine I'm really hoping it isn't the drive.
> > > > 
> > > > I've started up a dd on each drive, just for kicks, and reading
> > > > from both of them at the same time seems to work fine on the via
> > > > chipset. Given this little tid-bit, it seems its only once md-raid
> > > > is setup on the drives does one of them freak out.
> > > 
> > > If the problem happens mostly when both drives are in use then it
> > > could be a power supply issue. Some drives are rather sensitive to
> > > power fluctuations. You could try and move the drives to separate
> > > power cables if they're on the same one, or maybe the power supply's
> > > just not up to snuff.
> > 
> > I'll give that a shot too. But I have dd running on both drives right
> > now (dd if=/dev/sdX of=/dev/null), and its running fine. I'm also
> > going to run some other tests, see if maybe there isn't a ram problem,
> > it could be the cause.
> 
> Interesting, after moving each WD drive to its own power cable, that
> particular problem seems to have gone away. However another problem seems
> to have popped up, which I'm not sure is related so I'll post another
> thread (unable to handle kernel paging request).
> 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe
> > > linux-kernel" in the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > Please read the FAQ at  http://www.tux.org/lkml/

Ok, more testing, I've moved the drives over to the p35 machine semi-
permanently, and after a day or so of uptime I got some new errors:

ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata3.00: failed command: FLUSH CACHE EXT
ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata3.00: status: { DRDY }
ata3: hard resetting link
ata3: link is slow to respond, please be patient (ready=0)
ata3: SRST failed (errno=-16)
ata3: hard resetting link
ata3: link is slow to respond, please be patient (ready=0)
ata3: SRST failed (errno=-16)
ata3: hard resetting link
ata3: link is slow to respond, please be patient (ready=0)
ata3: SRST failed (errno=-16)
ata3: limiting SATA link speed to 1.5 Gbps
ata3: hard resetting link
ata3: SRST failed (errno=-16)
ata3: reset failed, giving up
ata3.00: disabled
ata3.00: device reported invalid CHS sector 0
ata3: EH complete
end_request: I/O error, dev sdc, sector 0
sd 2:0:0:0: [sdc] Unhandled error code
sd 2:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 2:0:0:0: [sdc] CDB: Write(10): 2a 00 00 00 07 a7 00 00 08 00
end_request: I/O error, dev sdc, sector 1959
Buffer I/O error on device dm-0, logical block 189
lost page write due to I/O error on dm-0
end_request: I/O error, dev sdc, sector 0
end_request: I/O error, dev sdc, sector 0
JBD2 unexpected failure: do_get_write_access: buffer_uptodate(jh2bh(jh));
Possible IO failure.

end_request: I/O error, dev sdc, sector 0
end_request: I/O error, dev sdc, sector 0
------------[ cut here ]------------
WARNING: at /home/damentz/src/zen/main/linux-
liquorix-2.6-2.6.34/debian/build/source_amd64_none/fs/buffer.c:1199 
mark_buffer_dirty+0x74/0x90()
Hardware name: P5K SE
Modules linked in: nfs lockd fscache nfs_acl auth_rpcgss sunrpc ipv6 
acpi_cpufreq cpufreq_ondemand freq_table cpufreq_conservative 
cpufreq_userspace cpufreq_powersave af_packet ext3 jbd loop 
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss 
snd_mixer_oss snd_pcm rtc_cmos rtc_core snd_timer tpm_tis nvidia(P) tpm 
rtc_lib tpm_bios evdev snd intel_agp pcspkr asus_atk0110 soundcore i2c_i801 
snd_page_alloc button i2c_core processor dm_mod raid10 raid456 
async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx 
raid1 raid0 multipath linear md_mod ext4 mbcache jbd2 crc16 usbhid sd_mod 
ata_generic pata_acpi uhci_hcd ata_piix libata floppy scsi_mod thermal atl1 
mii ehci_hcd [last unloaded: scsi_wait_scan]
Pid: 3283, comm: jbd2/dm-0-8 Tainted: P           2.6.34-0.dmz.8-liquorix-
amd64 #1
Call Trace:
 [<ffffffff8103bf23>] ? warn_slowpath_common+0x73/0xb0
 [<ffffffff81101cd4>] ? mark_buffer_dirty+0x74/0x90
 [<ffffffffa005a3c9>] ? __jbd2_journal_unfile_buffer+0x9/0x20 [jbd2]
 [<ffffffffa005d8a3>] ? jbd2_journal_commit_transaction+0xba3/0x12d0 [jbd2]
 [<ffffffff810542d0>] ? autoremove_wake_function+0x0/0x30
 [<ffffffffa0061701>] ? kjournald2+0xb1/0x210 [jbd2]
 [<ffffffff810542d0>] ? autoremove_wake_function+0x0/0x30
 [<ffffffffa0061650>] ? kjournald2+0x0/0x210 [jbd2]
 [<ffffffff81053e3e>] ? kthread+0x8e/0xa0
 [<ffffffff81033e8d>] ? schedule_tail+0x4d/0xf0
 [<ffffffff81003c94>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff81053db0>] ? kthread+0x0/0xa0
 [<ffffffff81003c90>] ? kernel_thread_helper+0x0/0x10
---[ end trace c90e4c710c9ef513 ]---
end_request: I/O error, dev sdc, sector 0

(and plenty more dmesg lines from lvm and ext4/jbd2 screaming about the io 
commands failing)

I take it that this means the drive is likely pooched? I'm going to try some 
more tests, and make sure both of the WD drives are on their own power cable 
first. but I'm betting now that the drive is just failing. This would make 2 
out of 4 in the same batch that had issues. The first one would increase the 
sector reallocated count 4 every hour or so. Now this one fails a flush 
cache command (and other spurious errors).

I guess its time to break out the WD diagnostics disk.

-- 
Thomas Fjellstrom
tfjellstrom@strangesoft.net
