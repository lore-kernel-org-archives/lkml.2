Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932830Ab2GYGTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 02:19:34 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:46469 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932736Ab2GYGTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 02:19:33 -0400
X-Sasl-enc: ntS0ctq65Q48llymBNW3CLPuJeZJ+fXBt6gC3p2qMQm/ 1343197171
Message-ID: <1343197168.2386.29.camel@perseus.themaw.net>
Subject: [ANNOUNCE] autofs 5.0.7 release
From: Ian Kent <raven@themaw.net>
To: autofs@linux.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 25 Jul 2012 14:19:28 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Once again this is long overdue so there are many changes.

The kernel patches are not being updated any more because of the
introduction of the vfs-automount changes to the VFS. If there
are needs in this area we will need to discuss how to deal with
them on the mailing list.

Known issues (haven't changed since 5.0.6)
==========================================

- Quoted strings in the master map are still not yet handled.
- When the active restart is being used it will happily re-connect a
  mount that is unresponsive, perhaps because the server is not
  responding. A forced expire (USR1 signal) should be enough to clean
  up.

autofs
======

The package can be found at:

ftp://ftp.kernel.org/pub/linux/daemons/autofs/v5

It is autofs-5.0.7.tar.[gz|bz2|xz]

No source rpm is there as it can be produced by using:

rpmbuild -ts autofs-5.0.7.tar.gz

and the binary rpm by using:

rpmbuild -tb autofs-5.0.7.tar.gz

See the INSTALL file for information about configure options and
kernel requirements.

Here are the entries from the CHANGELOG which outline the updates:

25/07/2012 autofs-5.0.7
=======================
- fix ipv6 name for lookup fix.
- improve mount location error reporting.
- fix paged query more results check.
- fix dumpmaps not reading maps.
- fix result null check in read_one_map().
- fix LDAP result leaks on error paths.
- fix fix LDAP result leaks on error paths.
- code analysis fixes part 1.
- fix not bind mounting local filesystem.
- add "dir" map-type.
- fix wait for master source mutex.
- fix submount shutdown race.
- fix fix map source check in file lookup.
- add disable move mount configure option.
- fix ipv6 name lookup check.
- fix ipv6 rpc calls.
- fix ipv6 configure check.
- add piddir to configure.
- add systemd unit support.
- remove empty command line arguments (passed by systemd).
- fix rpc build error.
- fix improve mount location error reporting.
- fix fix wait for master source mutex.
- add sss lookup module.
- teach automount about sss source.
- fix init script usage message.
- ignore duplicate exports in auto.net.
- add kernel verion check function.
- add function to check mount.nfs version.
- reinstate singleton mount probe.
- rework error return handling in rpc code.
- catch EHOSTUNREACH and bail out early.
- systemd support fixes.
- check scandir() return value.
- allow for kernel packet size change (in kernel 3.3.0+).
- fix function to check mount.nfs version.
- fix typo in libtirpc file name.
- fix rework error return handling in rpc code.
- allow MOUNT_WAIT to override probe.
- improve UDP RPC timeout handling.
- use strtok_r() in linux_version_code().
- fix sss wildcard match.
- fix dlopen() error handling in sss module.
- fix configure string length tests for sss library.
- report map not read when debug logging.
- duplicate parent options for included maps.
- update ->timeout() function to not return timeout.
- move timeout to map_source (allow per direct map timeout).
- fix kernel verion check of version components.
- dont retry ldap connect if not required.
- fix initialization in rpc create_client().
- fix libtirpc name clash.
- check if /etc/mtab is a link to /proc/self/mounts.
- fix nfs4 contacts portmap.
- make autofs wait longer for shutdown completion.
- fix sss map age not updated.
- fix remount deadlock.
- fix umount recovery of busy direct mount.
- fix offset mount point directory removal.
- fix remount of multi mount.
- fix devce ioctl alloc path check.
- add hup signal handling to hosts map.
- fix systemd argument passing.
- fix get_nfs_info() can incorrectly fail.
- fix offset directory removal.
- check negative cache much earlier.
- dont use pthread_rwlock_tryrdlock().
- mount_nfs.so to honor explicit NFSv4 requests.
- mount_nfs.so fix port=0 option behavior v3.
- documentation fix some typos and misleading comments.

Ian

