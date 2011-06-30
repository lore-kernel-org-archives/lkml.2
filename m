Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121Ab1F3BhP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 21:37:15 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:36720 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753661Ab1F3BhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 21:37:10 -0400
X-Sasl-enc: NYcjmK84SwgMPHnxuw66hEkUHpW1RQ83KnFU1idEywZb 1309397828
Subject: [ANNOUNCE] autofs 5.0.6 release
From: Ian Kent <raven@themaw.net>
To: autofs@linux.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Jun 2011 09:37:01 +0800
Message-ID: <1309397821.3183.2.camel@perseus.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This is long overdue, even so, I think there are still some things
that need fixing but aren't clear cut. However there are too many
patches to delay any longer so here is release 5.0.6.

The kernel patches are not being updated any more because of the
introduction of the vfs-automount changes to the VFS. If there
are needs in this area we will need to discuss how to deal with
them on the mailing list.

Known issues (haven't changed since 5.0.5)
==========================================

- Quoted strings in the master map are still not yet handled.
- There is a problem with "mount --move" in some releases of SuSE
  (perhaps other distributions as well)  which can cause mounts to
  not be moved correctly resulting in /etc/mtab continually growing
  due to invalid entries.
- When the active restart is being used it will happily re-connect a
  mount that is unresponsive, perhaps because the server is not
  responding. A forced expire (USR1 signal) should be enough to clean
  up.

autofs
======

The package can be found at:

ftp://ftp.kernel.org/pub/linux/daemons/autofs/v5

It is autofs-5.0.6.tar.[gz|bz2]

No source rpm is there as it can be produced by using:

rpmbuild -ts autofs-5.0.6.tar.gz

and the binary rpm by using:

rpmbuild -tb autofs-5.0.6.tar.gz

See the INSTALL file for information about configure options and
kernel requirements.

Here are the entries from the CHANGELOG which outline the updates:

28/06/2011 autofs-5.0.6
-----------------------
- fix included map read fail handling.
- refactor ldap sasl bind handling.
- add mount wait timeout parameter.
- special case cifs escapes.
- fix compile fail with when LDAP is excluded.
- more code analysis corrections (and fix a typo in an init script).
- fix backwards #ifndef INET6.
- fix stale initialization for file map instance.
- add "preen" fsck for ext4 mounts.
- don't use master_lex_destroy() to clear parse buffer.
- make documentation for set-log-priority clearer.
- fix timeout in connect_nb().
- fix pidof init script usage.
- check for path mount location in generic module.
- dont fail mount on access fail.
- fix rpc fail on large export list.
- fix memory leak on reload.
- update kernel patches for 2.6.18 and 2.6.19.
- dont connect at ldap lookup module init.
- fix random selection option.
- fix disable timeout.
- fix strdup() return value check (Leonardo Chiquitto).
- fix reconnect get base dn.
- add missing sasl mutex callbacks.
- fix get query dn failure.
- fix ampersand escape in auto.smb.
- add locality as valid ldap master map attribute.
- add locality as valid ldap master map attribute fix.
- add simple bind authentication.
- fix master map source server unavailable handling.
- add autofs_ldap_auth.conf man page.
- fix random selection for host on different network.
- make redhat init script more lsb compliant.
- don't hold lock for simple mounts.
- fix remount locking.
- fix wildcard map entry match.
- fix parse_sun() module init.
- dont check null cache on expire.
- fix null cache race.
- fix cache_init() on source re-read.
- fix mapent becomes negative during lookup.
- check each dc server individually.
- fix negative cache included map lookup.
- remove state machine timed wait.
- remove extra read master map call.
- fix error handing in do_mount_indirect().
- expire thread use pending mutex.
- remove ERR_remove_state() openssl call.
- fix init script restart option.
- fix init script status privilege error.
- always read file maps mount lookup map read fix.
- fix direct map not updating on reread.
- add external bind method.
- fix add simple bind auth.
- add option to dump configured automount maps.
- use weight only for server selection.
- fix isspace() wild card substition.
- auto adjust ldap page size.
- fix prune cache valid check.
- fix mountd vers retry.
- fix expire race.
- replace GPLv3 code.
- fix paged ldap map read.
- fix next task list update.
- fix stale map read.
- fix null cache clean.
- automount(8) man page correction.
- fix out of order locking in readmap.
- include ip address in debug logging.
- mount using address for DNS round robin host names.
- reset negative status on cache prune.
- remove master_mutex_unlock() leftover.
- fix sanity checks for brackets in server name.
- fix lsb service name in init script.
- fix map source check in file lookup.
- fix simple bind without SASL support.
- fix sasl bind host name selection.
- add nobind option.
- add base64 password encode.
- fix ipv6 name for lookup.
- fix libtirpc ipv6 check.

Ian

