Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312Ab0G0C57 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 22:57:59 -0400
Received: from adelie.canonical.com ([91.189.90.139]:49710 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab0G0C54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 22:57:56 -0400
From: John Johansen <john.johansen@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Subject: [AppArmor #6 0/13] AppArmor security module
Date: Mon, 26 Jul 2010 19:57:35 -0700
Message-Id: <1280199468-19680-1-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the sixth general posting of the newest version of the
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
* converted mediation of sysctls away from using security_sysctl to denty_open
* split aa_audit into profile dependent and profile independent parts, allowed
  * removal of profile conditional test from mode tests
* converted custom COMMON_AUDIT_DATA_INIT_NONE to COMMON_AUDIT_DATA_INIT
* removed dead NULL profile test in aa_may_ptrace
* updated __aa_transition_rlimits to require a profile
* General comment update, syncing comment headers to functions, updating
  TODO items, ..
* removed declarations of fns that no longer exist from includes
* remove explicit \0 from aa_dfa_null_transition
* add comment about change_hat_v tokenization
* add __init to aa_free_root_ns
* Move free inside of dfa test in dfa_free
* fix apparmor_setprocattr to allow PAGE_SIZE writes as long as they are
  \0 terminated
* replace , in aa_info_message with a ;
* rework aa_strneq as suggested by Tetsuo Handa
* remove unneeded incrementing of string pos at terminal character of permission
  string generation
* remove setting of hat info when hat not found in change_hat
* remove unused aa_fs_null and aa_fs_mnt
* cleanup simple write to buffer returns
* fix kvmalloc, vmalloc allocations to ensure that they are at least the size
  of work_struct
* remove extraneous !buffer tests when freeing memory in kvfree
* cleanup if condition in apparmor_capable
* Maks permitted caps returned by capget
* Fix missing call to cap_ptrace_traceme from apparmor_ptrace_traceme
* Remove unused mmap_min_addr bit
* Convert auditing to use namespace field instead of apparmors fully qualified
  domain names

Misc fixes and cleanups as result of above changes
* changed apparmor type reporting from audit= to apparmor= name pair so as
  not to have duplicate audit= name,value pair
* turn on apparmor audit type reporting by default
* converted change_profile onexec parameter of
* merged kvmalloc and dfa variation into a single lib kvmalloc routine
* fixed meta_read permission mapping bug
* removed redundant pid= in audit output
* removed unused delegate information removed from apparmor permission struct

  A Detailed list of all changes and patches are available from the AppArmor
  git repository, from commit a861e63c970d912a59c194be0fe09975c10b6a9a..


The AppArmor project has recently transitioned away from Novell forge.
Code and Documentation can be found at the following locations
* Mailing List - apparmor@lists.ubuntu.com
* Documentation (wip) - http://apparmor.wiki.kernel.org/
* User space tools -  https://launchpad.net/apparmor
* Kernel module -
  git://git.kernel.org/pub/scm/linux/kernel/git/jj/apparmor-dev.git


