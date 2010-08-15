Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488Ab0HOWyB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 18:54:01 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56454 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060Ab0HOWyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 18:54:00 -0400
Date: Sun, 15 Aug 2010 18:53:59 -0400
From: Christoph Hellwig <hch@infradead.org>
To: acme@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: callchain sampling bug in perf?
Message-ID: <20100815225359.GA32152@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to play with perf record -g, that is sampling the callchains.
Doing this with simple workloads works fine, but when I try to do this
with compilebench a lot of samples seem to get lost.

I'm doing the following:

perf probe --add xlog_sync
perf record -g -e probe:xlog_sync -- ./compilebench

Trying to report it I do not get any callchains at all:

[root@virtlab106 compilebench-0.6]# perf report -g flat -n
# Events: 9K cycles
#
# Overhead  Samples         Command      Shared Object     Symbol
# ........ ..........  ............  .................  .........
#
    70.41%       6757  compilebench  [kernel.kallsyms]  [k] xlog_sync
    22.61%       2170          sync  [kernel.kallsyms]  [k] xlog_sync
     3.89%        373            sh  [kernel.kallsyms]  [k] xlog_sync
     2.50%        240        python  [kernel.kallsyms]  [k] xlog_sync
     0.33%         32         :3881  [kernel.kallsyms]  [k] xlog_sync
     0.13%         12         :3971  [kernel.kallsyms]  [k] xlog_sync
     0.11%         11         :3956  [kernel.kallsyms]  [k] xlog_sync
     0.01%          1         :3972  [kernel.kallsyms]  [k] xlog_sync

Doing a perf report -g flat,0.0 -n shows lots of callgraph, but the
percentag for them doesn't add up at all.

