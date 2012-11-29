Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488Ab2K2T12 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 14:27:28 -0500
Received: from smtprelay0138.b.hostedemail.com ([64.98.42.138]:45225 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753522Ab2K2T11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 14:27:27 -0500
X-Panda: scanned!
X-Session-Marker: 742E617274656D406C79636F732E636F6D
X-Filterd-Recvd-Size: 8618
Date: Thu, 29 Nov 2012 19:27:25 +0000 (UTC)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: linux-kernel@vger.kernel.org
Message-ID: <101873674.12848.1354217245216.JavaMail.mail@webmail07>
Subject: A vague, murky topic of "Buffer I/O error on device sdb6, logical
 block NNNNNNNNN" and a ext4/VFS oops
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [176.214.170.114]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

When I was copying a lot of information (tens of gigabytes) from my primary HDD to a
secondary HDD I got gazillions of errors like these ones:

[19568.964762] EXT4-fs warning (device sdb6): ext4_end_bio:250: I/O error writing to inode 6029369 (offset 8036352 size 524288 starting block 51946549)
[19568.964767] sd 2:0:0:0: [sdb]
[19568.964768] Result: hostbyte=0x00 driverbyte=0x08
[19568.964770] sd 2:0:0:0: [sdb]
[19568.964771] Sense Key : 0xb [current] [descriptor]
[19568.964774] Descriptor sense data with sense descriptors (in hex):
[19568.964775]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00
[19568.964784]         00 00 00 00
[19568.964788] sd 2:0:0:0: [sdb]
[19568.964789] ASC=0x0 ASCQ=0x0
[19568.964791] sd 2:0:0:0: [sdb] CDB:
[19568.964792] cdb[0]=0x2a: 2a 00 18 c5 25 a8 00 00 70 00
[19568.964804] Buffer I/O error on device sdb6, logical block 13727786
[19568.964806] Buffer I/O error on device sdb6, logical block 13727787
[19568.964808] Buffer I/O error on device sdb6, logical block 13727788
[19568.964810] Buffer I/O error on device sdb6, logical block 13727789
[19568.964812] Buffer I/O error on device sdb6, logical block 13727790

along with:

[19568.964832] EXT4-fs warning (device sdb6): ext4_end_bio:250: I/O error writing to inode 6029369 (offset 8560640 size 57344 starting block 51946677)
[19568.964843] ata3: EH complete
[19624.635176] ata3.00: exception Emask 0x0 SAct 0x3fff SErr 0x40000 action 0x6 frozen
[19624.635181] ata3: SError: { CommWake }
[19624.635184] ata3.00: failed command: WRITE FPDMA QUEUED
[19624.635190] ata3.00: cmd 61/00:00:48:ee:cb/04:00:18:00:00/40 tag 0 ncq 524288 out
[19624.635190]          res 40/00:01:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[19624.635193] ata3.00: status: { DRDY }
[19624.635196] ata3.00: failed command: WRITE FPDMA QUEUED
[19624.635201] ata3.00: cmd 61/08:08:f0:65:bd/00:00:1d:00:00/40 tag 1 ncq 4096 out
[19624.635201]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[19624.635203] ata3.00: status: { DRDY }
[19624.635206] ata3.00: failed command: WRITE FPDMA QUEUED
[19624.635211] ata3.00: cmd 61/00:10:48:f2:cb/04:00:18:00:00/40 tag 2 ncq 524288 out
[19624.635211]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[19624.635213] ata3.00: status: { DRDY }
[19624.635215] ata3.00: failed command: WRITE FPDMA QUEUED
[19624.635220] ata3.00: cmd 61/00:18:48:f6:cb/04:00:18:00:00/40 tag 3 ncq 524288 out
[19624.635220]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[19624.635223] ata3.00: status: { DRDY }
[19624.635225] ata3.00: failed command: WRITE FPDMA QUEUED

along with:

[19624.635320] ata3: hard resetting link
[19624.954880] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[19624.956101] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20120711/psargs-359)
[19624.956109] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.SPT2._GTF] (Node ef0307b0), AE_NOT_FOUND (20120711/psparse-536)
[19624.958006] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20120711/psargs-359)
[19624.958011] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.SPT2._GTF] (Node ef0307b0), AE_NOT_FOUND (20120711/psparse-536)
[19624.958366] ata3.00: configured for UDMA/133
[19624.960763] ata3.00: device reported invalid CHS sector 0
[19624.960765] ata3.00: device reported invalid CHS sector 0
[19624.960767] ata3.00: device reported invalid CHS sector 0
[19624.960769] ata3.00: device reported invalid CHS sector 0
[19624.960771] ata3.00: device reported invalid CHS sector 0
[19624.960773] ata3.00: device reported invalid CHS sector 0
[19624.960775] ata3.00: device reported invalid CHS sector 0
[19624.960777] ata3.00: device reported invalid CHS sector 0
[19624.960779] ata3.00: device reported invalid CHS sector 0
[19624.960781] ata3.00: device reported invalid CHS sector 0
[19624.960782] ata3.00: device reported invalid CHS sector 0
[19624.960784] ata3.00: device reported invalid CHS sector 0
[19624.960786] ata3.00: device reported invalid CHS sector 0
[19624.960788] ata3.00: device reported invalid CHS sector 0

and also this:

[19624.961128] Buffer I/O error on device sdb6, logical block 13783485
[19624.961132] EXT4-fs warning (device sdb6): ext4_end_bio:250: I/O error writing to inode 6029369 (offset 236183552 size 524288 starting block 52002249)
[19624.961142] sd 2:0:0:0: [sdb]
[19624.961144] Result: hostbyte=0x00 driverbyte=0x08
[19624.961146] sd 2:0:0:0: [sdb]
[19624.961147] Sense Key : 0xb [current] [descriptor]
[19624.961149] Descriptor sense data with sense descriptors (in hex):
[19624.961151]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00
[19624.961160]         00 00 00 00
[19624.961164] sd 2:0:0:0: [sdb]
[19624.961165] ASC=0x0 ASCQ=0x0
[19624.961167] sd 2:0:0:0: [sdb] CDB:
[19624.961168] cdb[0]=0x2a: 2a 00 1d bd 65 f0 00 00 08 00
[19624.961176] end_request: I/O error, dev sdb, sector 498951664
[19624.961179] Buffer I/O error on device sdb6, logical block 24150067
[19624.961180] lost page write due to I/O error on sdb6
[19624.961189] sd 2:0:0:0: [sdb]
[19624.961191] Result: hostbyte=0x00 driverbyte=0x08
[19624.961192] sd 2:0:0:0: [sdb]
[19624.961194] Sense Key : 0xb [current] [descriptor]
[19624.961196] Descriptor sense data with sense descriptors (in hex):
[19624.961197]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00
[19624.961206]         00 00 00 00
[19624.961210] sd 2:0:0:0: [sdb]
[19624.961212] ASC=0x0 ASCQ=0x0
[19624.961214] sd 2:0:0:0: [sdb] CDB:
[19624.961215] cdb[0]=0x2a: 2a 00 18 cb f2 48 00 04 00 00
[19624.961222] end_request: I/O error, dev sdb, sector 416019016
[19624.961256] Buffer I/O error on device sdb6, logical block 13783486

What _exactly_ do these "Buffer I/O error on device sdb6, logical block 13727790" errors mean?
The Internet doesn't offer any relevant information on this topic - only assumption which I don't quite
appreciate.

I suspect my second HDD is failing but I've no idea how and what causes it?

Also, due to this yet unidentified failure, I've discovered a kernel bug (that's on the vanilla kernel 3.6.7):

[19633.288813] ------------[ cut here ]------------
[19633.288824] WARNING: at fs/buffer.c:1106 mark_buffer_dirty+0x64/0x70()
[19633.288826] Hardware name: System Product Name
[19633.288828] Modules linked in: 
[19633.288892] Pid: 16654, comm: cp Tainted: P           O 3.6.7-ic #3
[19633.288893] Call Trace:
[19633.288899]  [] warn_slowpath_common+0x6d/0xa0
[19633.288903]  [] ? mark_buffer_dirty+0x64/0x70
[19633.288907]  [] ? mark_buffer_dirty+0x64/0x70
[19633.288911]  [] warn_slowpath_null+0x1d/0x20
[19633.288914]  [] mark_buffer_dirty+0x64/0x70
[19633.288919]  [] __ext4_handle_dirty_metadata+0xef/0x100
[19633.288922]  [] ? alloc_inode+0x2a/0x80
[19633.288927]  [] ext4_new_inode+0x7df/0x1170
[19633.288932]  [] ? __d_lookup+0x105/0x190
[19633.288936]  [] ext4_create+0x94/0x100
[19633.288939]  [] ? ext4_mknod+0x100/0x100
[19633.288943]  [] vfs_create+0x7b/0xc0
[19633.288946]  [] ? lookup_dcache+0x25/0xb0
[19633.288949]  [] do_last.isra.50+0x736/0xad0
[19633.288953]  [] ? link_path_walk+0x5a/0x7b0
[19633.288956]  [] path_openat+0x95/0x3e0
[19633.288960]  [] ? user_path_at_empty+0x4f/0x80
[19633.288964]  [] ? copy_to_user+0x2c/0x40
[19633.288967]  [] do_filp_open+0x2c/0x80
[19633.288971]  [] ? alloc_fd+0xa7/0xf0
[19633.288975]  [] do_sys_open+0xe0/0x1c0
[19633.288978]  [] sys_open+0x2d/0x40
[19633.288983]  [] sysenter_do_call+0x12/0x26
[19633.288985] ---[ end trace 2d9fda7935bc9fda ]---

Last but not least, when the kernel tries to reset the second HDD, all read/write operations
on the first HDD completely stall.

Please, advise.

--

Artem
