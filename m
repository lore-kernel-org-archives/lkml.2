Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757718Ab0GOAnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 20:43:53 -0400
Received: from adelie.canonical.com ([91.189.90.139]:56749 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756851Ab0GOAnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 20:43:51 -0400
From: John Johansen <john.johansen@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Subject: [AppArmor #5 0/13] AppArmor security module
Date: Wed, 14 Jul 2010 17:43:28 -0700
Message-Id: <1279154621-25868-1-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the fifth general posting of the newest version of the
AppArmor security module it has been rewritten to use the security_path
hooks instead of the previous vfs approach.  The current implementation
is aimed at being as semantically close to previous versions of AppArmor
as possible while using the existing LSM infrastructure.

Development is on going and
improvements to file, capability, network, resource usage and ipc mediation
are planned.

With this submission we believe AppArmor is ready for inclusion into
the kernel.

_Issues NOT specifically addressed_
* The d_namespace_path function still manually strips the " (deleted)"
  string that __d_path appends.  A fix to __d_path is being pursued
  independently of the AppArmor submission.

_Issues Addressed Since Last Time AppArmor was Posted_
* AppArmor auditing has been converted to use lsm_audit as suggested by
  Eric Paris in
  http://marc.info/?l=linux-security-module&m=125778105017307&w=2
* The user space interface CONFIG_APPARMOR_COMPAT_24 has not been removed,
  as the replacement interface isn't ready yet.  It will become a separate
  patch that distros can carry to provide backwards compatibility.
* AppArmor's old network mediation has been removed and moved into
  the compatibility patch.  The new network mediation routines will
  be submitted for review separate for the AppArmor base.
* all issues raised from last posting should be addressed.
* The code has seen more cleanup removing dead code. eg. // as null transition
* Several bug fixes have been applied

  A Detailed list of all changes and patches are available from the AppArmor
  git repository


The AppArmor project has recently transitioned away from Novell forge.
Code and Documentation can be found at the following locations
* Mailing List - apparmor@lists.ubuntu.com
* Documentation (wip) - http://apparmor.wiki.kernel.org/
* User space tools -  https://launchpad.net/apparmor
* Kernel module -
  git://git.kernel.org/pub/scm/linux/kernel/git/jj/apparmor-dev.git


