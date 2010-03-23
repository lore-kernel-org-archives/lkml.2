Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab0CWAcM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 20:32:12 -0400
Received: from cantor.suse.de ([195.135.220.2]:45243 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755004Ab0CWAcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 20:32:10 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/18] Allow different tracers to be compiled independently
Date: Tue, 23 Mar 2010 01:32:02 +0100
Message-Id: <1269304340-25372-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Hi,

  currently, when one tracer is selected, most of tracepoints for other
tracers also gets pulled into the kernel. So for example it's not possible
to enable BLK_DEV_IO_TRACE without polluting slab allocation paths with
tracepoint checks (see changelog of patch 01). This patch set adds a
possibility for each set of trace points to be compile-enabled separately.
  The first patch contains the necessary magic in linux/tracepoint.h. Other
patches just tell tracing framework about correspoding config options
and possibly introduce them if they did not exist before.
  The patches in this patch set are actually completely independent so 
they can be merged via respective subsystem trees. But changes are rather
tiny so I don't expect much conflicts...

								Honza
