Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125Ab1EKVLQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 17:11:16 -0400
Received: from c-76-97-164-112.hsd1.ga.comcast.net ([76.97.164.112]:55110 "EHLO
	deneb.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755991Ab1EKVGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 17:06:42 -0400
X-Greylist: delayed 3155 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 May 2011 17:06:39 EDT
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] arch/c6x: new architecture port for linux
Date: Wed, 11 May 2011 16:13:47 -0400
Message-Id: <1305144843-5058-1-git-send-email-msalter@redhat.com>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds support for a new architecture (arch/c6x) to
Linux. This architecture supports members of the Texas Instruments
family of C64x single and multicore DSPs. The multicore DSPs do not
support cache coherancy, so are not suitable for SMP. Also, these are
no-mmu processors. This core architecture is VLIW with an instruction
set optimized for DSP applications. For details on the processors:

  http://processors.wiki.ti.com/index.php/Main_Page

This port has a long history going back at least as far as 2.6.13 but
was never a good candidate for upstreaming due to lack of a gcc port.
These previous kernels were built with proprietary TI tools using COFF.
However, a gcc port now exists:

  http://www.codesourcery.com/sgpp/lite/c6000/portal/release1783

Along with supporting the GNU toolchain work, Texas Instruments has also
been working on bringing the kernel port up to date and suitable for
contribution to the community. This is the start of that process and
hopefully we can quickly make whatever changes are necessary to get this
port included in the upstream kernel.

There are a few small patches to generic parts of the kernel including
bug fixes for a few generic headers. The most significant patch for the
generic kernel is the support for a new ELF based binary format called
DSBT. DSBT stands for Data Segment Base Table and provides a mechanism
for dynamic shared objects for systems without an MMU. In this regard it
is similar to the existing FDPIC support in the kernel but it uses a
very different approach. Whereas FDPIC ties data segment pointers to
function pointers, DSBT uses data accesses relativer to a dedicated
data pointer (DP) register. Each data segment in a DSO starts with a
table of DP values for each DSO linked into the process. Each DSO has
a unique index into that table. When a function call is made to another
DSO, the callee will save the current DP and retrieve its own DP from
the table indexed on the callee's known index. The advantage of this
over FDPIC is that function pointers require no special handling. The
main disadvantage is that DSOs in a system must have unique indices to
access their DP. These indices can be assigned at static link time when
the DSOs are built or later with a prelink-like tool when the rootfs is
composed.

The project wiki for linux-c6x is at:

  http://www.linux-c6x.org

and the GIT tree holding the attached patches is at:

  git@linux-c6x.org:/git/projects/linux-c6x-upstreaming.git

TIA for any feedback and/or guidance on this port.

