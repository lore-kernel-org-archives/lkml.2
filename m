Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100Ab1GAXbc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 19:31:32 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50397 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757689Ab1GAXbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 19:31:31 -0400
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, Arnaud Lacombe <lacombar@gmail.com>,
        Steven Rostedt <srostedt@redhat.com>
Subject: [RFC 0/4] streamline_config clean-ups
Date: Fri,  1 Jul 2011 19:31:12 -0400
Message-Id: <1309563076-5050-1-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.3.4.574.g608b.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following series attempts to merge some redundants stuff in the kconfig
Makefile, namely how streamline_config learns about its environment, avoids
multi-line shell command in kconfig's Makefile. Seconds commit also removes the
non-portable usage of sed(1) as -i is not POSIX compliant.

Comments appreciated!

 - Arnaud

ps: I'm not really a huge fan of the direct export of MAKECMDGOALS, maybe should
it be KBUILD_MAKECMDGOALS.

Arnaud Lacombe (4):
  kbuild: export MAKECMDGOALS
  kconfig/streamline_config.pl: directly access LSMOD
  kconfig/streamline_config.pl: merge local{mod,yes}config
  kconfig/streamline_config.pl: move config generation to script

 Makefile                             |    3 ++
 scripts/kconfig/Makefile             |   40 +--------------------------------
 scripts/kconfig/localconfig.sh       |   20 +++++++++++++++++
 scripts/kconfig/streamline_config.pl |   19 +++++++++++++--
 4 files changed, 41 insertions(+), 41 deletions(-)
 create mode 100755 scripts/kconfig/localconfig.sh

-- 
1.7.3.4.574.g608b.dirty

