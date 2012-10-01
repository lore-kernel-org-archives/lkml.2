Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562Ab2JAOlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 10:41:19 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:55154
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751142Ab2JAOlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 10:41:18 -0400
Date: Mon, 1 Oct 2012 10:41:17 -0400
From: Christoph Hellwig <hch@infradead.org>
To: linux-kernel@vger.kernel.org
Subject: linux 3.6 compile error in samples/seccomp/bpf-helper.c
Message-ID: <20121001144117.GA333@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems like the seccomp example somehow expect linux/seccomp.h to
be installed instead of grabbing it from the kernel tree:

/home/hch/work/linux-2.6/samples/seccomp/bpf-direct.c:21:27: fatal error: linux/seccomp.h: No such file or directory
compilation terminated.
/home/hch/work/linux-2.6/samples/seccomp/bpf-fancy.c:13:27: fatal error: linux/seccomp.h: No such file or directory compilation terminated.
make[4]: *** [samples/seccomp/bpf-direct.o] Error 1
make[4]: *** Waiting for unfinished jobs....
In file included from
/home/hch/work/linux-2.6/samples/seccomp/bpf-helper.c:15:0:
/home/hch/work/linux-2.6/samples/seccomp/bpf-helper.h:20:50: fatal error: linux/seccomp.h: No such file or directory compilation terminated.

