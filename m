Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932613Ab2DKQhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 12:37:19 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:44315 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760659Ab2DKQgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 12:36:33 -0400
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH v5 0/5] tools: Add a toplevel Makefile
Date: Wed, 11 Apr 2012 18:36:13 +0200
Message-Id: <1334162178-17152-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.9.3.362.g71319
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Hi all,

this is v5 of the patchset incorporating most of Sam's comments from
yesterday.

Changelog:
==========

* v4:

this is basically a new rediff of the patchset against 3.4-rc2 along
with integrating all comments/reviews I got from the last iteration. If
there are none this time, I would like to suggest merging this, maybe
through -tip or Arnaldo's perf tree.

State of the affairs on how to use it are in the 4/4 patch, adding them
here too:

Now you can do

$ make tools/<toolname>

from the toplevel kernel directory and have the respective tool built.

If you want to build and install it, do

$ make tools/<toolname>_install

$ make tools/<toolname>_clean

should clean the respective tool directories.

If you want to clean all in tools, simply do

$ make tools/clean

Also, if you want to get what the possible targets are, simply calling

$ make tools/

should give you the short help.

$ make tools/install

installs all tools, of course. Doh.

Thanks.

* v3:

Yet another version of the toplevel Makefile integration of tools/.
This round gives you the ability to build the tools from the toplevel
Makefile (explanation below can be found also in patch 4/4's commit
message):

"Now you can do

$ make tools/<toolname>

from the toplevel kernel directory and have the respective tool built.

If you want to build and install it, do

$ make tools/<toolname> tinstall

The install target is called "tinstall" so that there's no conflict with
the main kernel install target and should mean "tool install".

$ make tools/ <toolname>_clean

should clean the respective tool directories.

If you want to clean all in tools, simply do

$ make  tools/ cleanall

Also, if you want to get what the possible targets are, simply calling

$ make tools/

should give you the short help."

Also included are all suggestions from the last time.

Thanks.

* v2:

here's a refreshed version from yesterday incorporating all comments and
suggestions along with a third patch that adds a 'help' target as the
default one causing the following below. Btw, Arnaldo, could you please
pick those up if there are no complaints since the first patch touches
perf and I don't have a clear idea who else to send it to anyway :).

Thanks.

$ make
Possible targets:

  cpupower   - a tool for all things x86 CPU power
  firewire   - the userspace part of nosy, an IEEE-1394 traffic sniffer
  lguest     - a minimal 32-bit x86 hypervisor
  perf       - Linux performance measurements tool
  slub       - slabs reporting tool
  turbostat  - Intel CPU idle stats and freq reporting tool
  usb        - USB testing tools
  virtio     - vhost test module
  x86_energy_perf_policy - Intel energy policy tool

Cleaning targets:

  all of the above with the "_clean" string appended cleans
    the respective build directory.
  clean: a summary clean target to clean _all_ folders


* v1:

this is a refresh and carve-out of an old patchset. It adds a toplevel
Makefile to tools/ so that one can build the tool of her/his liking by
simply doing

$ cd tools/
$ make <toolname>

By default, we build perf. There's also a scripts/Makefile.lib now which
should contain all make-related generic stuff which can be used by all
tools' build process after including this file.

</Changelog>

Any comments/suggestions are welcome,
thanks.
