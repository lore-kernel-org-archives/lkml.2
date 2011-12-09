Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab1LISJN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 13:09:13 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:36256 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309Ab1LISJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 13:09:08 -0500
From: Borislav Petkov <bp@amd64.org>
To: X86-ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 0/5] x86, microcode, AMD: Size checking fixes
Date: Fri,  9 Dec 2011 19:08:50 +0100
Message-Id: <1323454135-16777-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.8.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Hi all,

this is a patchset that reworks and fixes ucode size checking. The meat
of it is contained in 3/5 which reworks the code to iterate over the
patches in the microcode binary image _without_ vmalloc-ing space for
every patch in succession in order to look at it and go on to the next,
if it doesn't fit.

In any case, we end up loading at most one patch so before we copy it
in local storage we do all possible checks on it now, and copy it only
then, if all checks are passed.

Also, for simplicity, we alloc a single 4K page as a buffer for it which
we keep per CPU as long as the ucode module is loaded and free upon
exit. This simplifies all allocations/cleanup paths significantly.

Suggestions are welcome,
thanks.
