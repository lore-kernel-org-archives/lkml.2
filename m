Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab1EQCO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 22:14:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:62254 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab1EQCOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 22:14:25 -0400
X-Authority-Analysis: v=1.1 cv=y6zMVzRGPZqd+EkIbWgKRW0ZY5+85Abqc3bXR1aXymM= c=1 sm=0 a=vhdKIqpQuCYA:10 a=Vqm_N0ay2SsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=wzGh6e_GSShufbRezZoA:9 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110517021027.390391519@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 16 May 2011 22:10:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC][PATCH 0/2] kbuild: create force-deps for fixdep for recordmcount
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While doing a ktest patchcheck on several patches I've pulled,
an update to recordmcount caused ftrace to fail. This is because
ktest does a make mrproper for the first patch, but just uses the
dependencies for the patches after that. But one of the patches
modified both the way recordmcount worked, and what ftrace expected
in the kernel. Since modification of recordmcount does not force
updates to all object files, the expectation that ftrace had on
the object files was incorrect and caused ftrace to fail.

This is an RFC to modify fixdep to allow addition of files that would
be added as dependencies to all objects in the kernel.

Thoughts?

Steven Rostedt (2):
      kbuild: Add force-deps to fixdep
      ftrace/kbuild: Add recordmcount files to force full build

----
 scripts/Kbuild.include |    3 ++-
 scripts/Makefile.build |    6 ++++--
 scripts/basic/fixdep.c |   18 ++++++++++++++++--
 3 files changed, 22 insertions(+), 5 deletions(-)
