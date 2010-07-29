Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab0G2VsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 17:48:17 -0400
Received: from adelie.canonical.com ([91.189.90.139]:43269 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab0G2VsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 17:48:15 -0400
From: John Johansen <john.johansen@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Subject: [AppArmor #7 0/13] AppArmor security module
Date: Thu, 29 Jul 2010 14:47:56 -0700
Message-Id: <1280440089-3203-1-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the seveth general posting of the newest version of the
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

  http://lkml.org/lkml/2010/7/6/186

_Issues Addressed Since Last Time AppArmor was Posted_

All changes requested by feed back
* Add comment for embedded \0 in fqnames and their validation
* Add comment for kvmalloc minimum size of work_struct when falling back
  to vmalloc
* Spell check of comments and general cleanup any need change found during
  the spell check.
* updated aa_info_message
* removed extraneous if (profile) checks
* removed unused AA_NEW_SID symbol
* added __init and __initdata to fns and variables where appropriate
* removed patch text not related to apparmor that was being added to
  Documentation/kernel-parameters.txt

Misc fixes and cleanups as result of above changes
* fixed missing include for vmalloc.h in lib.c that would cause build failure
  on some platforms
* Added simple Documentation/apparmor.txt

  A Detailed list of all changes and patches are available from the AppArmor
  git repository, from commit 5e43ceab0299aa8ee786e17048a31a865de3163f

The AppArmor project has recently transitioned away from Novell forge.
Code and Documentation can be found at the following locations
* Mailing List - apparmor@lists.ubuntu.com
* Documentation (wip) - http://apparmor.wiki.kernel.org/
* User space tools -  https://launchpad.net/apparmor
* Kernel module -
  git://git.kernel.org/pub/scm/linux/kernel/git/jj/apparmor-dev.git


