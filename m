Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab0DXCI3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 22:08:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775Ab0DXCI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 22:08:27 -0400
Date: Fri, 23 Apr 2010 22:09:08 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Christian Eggers <ceggers@gmx.de>
Cc: linux-cifs-client@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: cifs: Filesystem unmounts automatically after some time
Message-ID: <20100423220908.480ce1f4@corrin.poochiereds.net>
In-Reply-To: <201004232148.52739.ceggers@gmx.de>
References: <201004232148.52739.ceggers@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Apr 2010 21:48:51 +0200
Christian Eggers <ceggers@gmx.de> wrote:

> # uname -r
> 2.6.34-rc5-desktop
> 
> Samba server: Debian with Samba-3.2.5 (also other OS seem to be affected)
> 
> # modprobe cifs
> # mount -t cifs //server/privat /mnt -o username=christian
> 
> When I mount a remote Samba share with the previous commands, the share gets successfully mounted and is shown in the output of the "mount" command. After some minutes the share is automatically unmounted without any user intervention. Is this a wanted feature 
> or a bug?
> 
> I saw this behaviour first on openSUSE 11.2 (shipped with kernel-2.6.31.5) but never on openSUSE 11.1 (kernel-2.6.27.7).
> 
> regards
> Christian
> 

Sounds like a bug, but I'm not sure if it's in CIFS or even in the
kernel.

> 
> # echo 1 > /proc/fs/cifs/cifsFY1
> [   98.055249]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/cifsfs.c: Devname: //server/privat flags: 64 
> [   98.055254]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/connect.c: CIFS VFS: in cifs_mount as Xid: 0 with uid: 0
> [   98.055262]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/connect.c: Username: christian
> [   98.065893]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/connect.c: UNC: \\server\privat ip: 192.168.0.2
> [   98.065898]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/netmisc.c: address conversion returned 1 for 192.168.0.2
> [   98.065907]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/connect.c: Socket created
> [   98.066298]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/connect.c: sndbuf 16384 rcvbuf 87380 rcvtimeo 0x1b58
> [   98.066460]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/connect.c: Existing smb sess not found
> [   98.066470]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/cifssmb.c: secFlags 0x7
> [   98.066475]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/transport.c: For smb_command 114
> [   98.066478]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/transport.c: Sending smb:  total_len 60
> [   98.066498]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/connect.c: Demultiplex PID: 4241
> [   98.224210]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/connect.c: rfc1002 length 0x5f
> [   98.224218]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/misc.c: Calculated size 81 vs length 95 mismatch for mid 1
> [   98.224233]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/cifssmb.c: Dialect: 0
> [   98.224236]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/cifssmb.c: Max buf = 16472
> [   98.224240]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/cifssmb.c: negprot rc 0
> [   98.224243]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/connect.c: Security Mode: 0x3 Capabilities: 0x80f3fd TimeAdjust: -7200
> [   98.224247]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/sess.c: sess setup type 2
> [   98.224323]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/transport.c: For smb_command 115
> [   98.224326]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/transport.c: Sending smb:  total_len 254
> [   98.301773]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/connect.c: rfc1002 length 0x5e
> [   98.301785]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
> [   98.301790]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/sess.c: ssetup rc from sendrecv2 is 0
> [   98.301792]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/sess.c: UID = 100 
> [   98.301795]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/sess.c: bleft 48
> [   98.301799]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/sess.c: serverOS=Unix
> [   98.301802]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/sess.c: serverNOS=Samba 3.2.5
> [   98.301805]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/sess.c: serverDomain=WGNETZ
> [   98.301808]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/sess.c: ssetup freeing small buf ffff88007a2bcdc0
> [   98.301811]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/connect.c: CIFS Session Established successfully
> [   98.301815]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/connect.c: file mode: 0x1ed  dir mode: 0x1ed
> [   98.301821]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/transport.c: For smb_command 117
> [   98.301824]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/transport.c: Sending smb:  total_len 86
> [   98.304537]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/connect.c: rfc1002 length 0x42
> [   98.304547]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/connect.c: disk share connection
> [   98.304551]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/connect.c: nativeFileSystem=NTFS
> [   98.304553]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/connect.c: Tcon flags: 0x1 
> [   98.304556]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/connect.c: CIFS Tcon rc = 0
> [   98.304559]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/cifssmb.c: In QFSDeviceInfo
> [   98.304562]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/transport.c: For smb_command 50
> [   98.304565]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/transport.c: Sending smb:  total_len 72
> [   98.305453]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/connect.c: rfc1002 length 0x44
> [   98.305462]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/cifssmb.c: In QFSAttributeInfo
> [   98.305465]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/transport.c: For smb_command 50
> [   98.305468]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/transport.c: Sending smb:  total_len 72
> [   98.306033]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/connect.c: rfc1002 length 0x50
> [   98.306041]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/cifssmb.c: In QFSUnixInfo
> [   98.306045]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/transport.c: For smb_command 50
> [   98.306048]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/transport.c: Sending smb:  total_len 72
> [   98.306562]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/connect.c: rfc1002 length 0x48
> [   98.306570]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/connect.c: negotiated posix acl support
> [   98.306573]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/connect.c: negotiate posix pathnames
> [   98.306575]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/connect.c: Negotiate caps 0x5b
> [   98.306578]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/connect.c: FCNTL cap
> [   98.306580]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/connect.c: EXTATTR cap
> [   98.306582]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/connect.c: POSIX path cap
> [   98.306584]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/connect.c: POSIX ACL cap
> [   98.306587]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/connect.c: very large read cap
> [   98.306589]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/cifssmb.c: In SETFSUnixInfo
> [   98.306593]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/transport.c: For smb_command 50
> [   98.306595]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/transport.c: Sending smb:  total_len 86
> [   98.307122]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/connect.c: rfc1002 length 0x3b
> [   98.307138]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/connect.c: CIFS VFS: leaving cifs_mount (xid = 0) rc = 0
> [   98.307145]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/inode.c: CIFS VFS: in cifs_root_iget as Xid: 1 with uid: 0
> [   98.307151]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/inode.c: Getting info on 
> [   98.307156]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/cifssmb.c: In QPathInfo (Unix) the path 
> [   98.307162]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/transport.c: For smb_command 50
> [   98.307167]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/transport.c: Sending smb:  total_len 78
> [   98.307965]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/connect.c: rfc1002 length 0xa4
> [   98.307975]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/inode.c: looking for uniqueid=1081824
> [   98.307987]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/inode.c: cifs_revalidate_cache: revalidating inode 1081824
> [   98.307990]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/inode.c: cifs_revalidate_cache: inode 1081824 is new
> [   98.307993]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/inode.c: inode 0xffff88007df83d10 old_time=0 new_time=4294765603
> [  320.464094]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/inode.c: CIFS VFS: in cifs_revalidate_dentry as Xid: 2 with uid: 0
> [  320.464102]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/inode.c: Revalidate:  inode 0xffff88007df83d10 count 1 dentry: 0xffff88007195fcc0 d_time -8028920569317556072 jiffies 4294987760
> [  320.464106]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/inode.c: Getting info on 
> [  320.464109]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/cifssmb.c: In QPathInfo (Unix) the path 
> [  320.464119]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/transport.c: For smb_command 50
> [  320.464122]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/transport.c: Sending smb:  total_len 78
> [  320.464867]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/connect.c: rfc1002 length 0xa4
> [  320.464883]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/inode.c: cifs_revalidate_cache: revalidating inode 1081824
> [  320.464886]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/inode.c: cifs_revalidate_cache: inode 1081824 is unchanged
> [  320.464890]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/inode.c: inode 0xffff88007df83d10 old_time=4294765603 new_time=4294987760
> [  320.464894]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/inode.c: CIFS VFS: leaving cifs_revalidate_dentry (xid = 2) rc = 0
> [  320.464912]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/cifsfs.c: CIFS VFS: in cifs_statfs as Xid: 3 with uid: 0
> [  320.464916]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/cifssmb.c: In QFSPosixInfo
> [  320.464919]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/transport.c: For smb_command 50
> [  320.464922]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/transport.c: Sending smb:  total_len 72
> [  320.466338]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/connect.c: rfc1002 length 0x74
> [  320.466350]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/cifsfs.c: CIFS VFS: leaving cifs_statfs (xid = 3) rc = 0

Just before cifs_put_super is called, looks like something did a statfs call.

> [  320.466675]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/cifsfs.c: In cifs_put_super
> [  320.466680]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/connect.c: CIFS VFS: in cifs_put_tcon as Xid: 4 with uid: 0
> [  320.466683]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/cifssmb.c: In tree disconnect
> [  320.466687]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/transport.c: For smb_command 113
> [  320.466690]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/transport.c: Sending smb:  total_len 39
> [  320.467832]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/connect.c: rfc1002 length 0x27
> [  320.467843]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/transport.c: SendRcvNoRsp flags 64 rc 0
> [  320.467848]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/connect.c: CIFS VFS: in cifs_put_smb_ses as Xid: 5 with uid: 0
> [  320.467851]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/cifssmb.c: In SMBLogoff for session disconnect
> [  320.467855]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/transport.c: For smb_command 116
> [  320.467858]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/transport.c: Sending smb:  total_len 43
> [  320.479204]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/connect.c: rfc1002 length 0x2b
> [  320.479221]  /home/christian/intel/linux-2.6.34-rc/fs/cifs/transport.c: SendRcvNoRsp flags 64 rc 0
> 

...and then the last reference to the superblock was put. I can't be
certain, but it seems plausible that something in userspace is
triggering a umount. What may be interesting is to boot the box into
single-user mode and redo the mount. Does it still end up unmounted
after a little while?

It also could be a matter of more vfsmount references being put than
"got", possibly with the last reference being put in the statfs
codepath above. This would be the first I've heard of such a problem
however and would probably not be a cifs-specific issue.

-- 
Jeff Layton <jlayton@redhat.com>
