Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab0DNDmA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 23:42:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64459 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751583Ab0DNDl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 23:41:58 -0400
Message-ID: <4BC539DD.5040003@cn.fujitsu.com>
Date: Wed, 14 Apr 2010 11:43:25 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Michal Marek <mmarek@suse.cz>,
       linux-kbuild@vger.kernel.org, Tim Bird <tim.bird@am.sony.com>
Subject: [PATCH 0/6] kconfig: add support to show hidden options which have
 prompts
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Usage:
  (in menuconfig)
  Press <Z> to show all config symbols which have prompts.

Quote Tim Bird (http://lkml.org/lkml/2010/3/19/319):

| I've been bitten by this numerous times.  I most often
| use ftrace on ARM, but when I go back to x86, I almost
| always go through a sequence of searching for the
| function graph tracer in the menus, then realizing it's
| completely missing until I disable CC_OPTIMIZE_FOR_SIZE.
|
| Is there any way to have the menu item appear, but be
| unsettable unless the SIZE option is disabled?  I'm
| not a Kconfig guru...

I myself found this useful too. For example, I need to test
ftrace/tracing and want to be sure all the tracing features are
enabled, so I  enter the "Tracers" menu, and press <Z> to
see if there is any config hidden.

I noticed gconfig and xconfig have a button "Show all options",
but that's a bit too much, and I think normally what we are not
interested in those configs which have no prompt thus can't be
changed by users.

Exmaple:

      --- Tracers
      -*-   Kernel Function Tracer
      - -     Kernel Function Graph Tracer
      [*]   Interrupts-off Latency Tracer
      - -   Preemption-off Latency Tracer
      [*]   Sysprof Tracer

Here you can see 2 tracers are not selectable, and then can find
out how to make them selectable.

I also add this support for gconfig, but haven't done for xconfig.

btw: are there many users using gconfig/xconfig today ?

---
 Documentation/kbuild/kconfig-language.txt |    2 +-
 scripts/kconfig/gconf.c                   |  113 ++++++++++-------------------
 scripts/kconfig/gconf.glade               |   26 +++++--
 scripts/kconfig/lkc_proto.h               |    3 +-
 scripts/kconfig/lxdialog/inputbox.c       |    4 +-
 scripts/kconfig/lxdialog/menubox.c        |   22 +++---
 scripts/kconfig/mconf.c                   |   22 +++++-
 scripts/kconfig/menu.c                    |   12 +++-
 scripts/kconfig/zconf.tab.c_shipped       |   21 +++++-
 scripts/kconfig/zconf.y                   |   21 +++++-
 10 files changed, 136 insertions(+), 110 deletions(-)
