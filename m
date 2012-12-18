Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083Ab2LRRjW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 12:39:22 -0500
Received: from plane.gmane.org ([80.91.229.3]:54155 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753092Ab2LRRjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 12:39:21 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Akemi Yagi <amyagi@gmail.com>
Subject: Re: [PATCH 3/3] perf tools: Fix a misuse of for_each_set_bit() in
 session.c
Date: Tue, 18 Dec 2012 17:39:06 +0000 (UTC)
Message-ID: <kaq9nq$sot$1@ger.gmane.org>
References: <1346053107-11946-1-git-send-email-feng.tang@intel.com>
	<1346053107-11946-4-git-send-email-feng.tang@intel.com>
	<871uisepf8.fsf@sejong.aot.lge.com> <20120827161815.4a1a84c7@feng-i7>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: energy.scripps.edu
User-Agent: Pan/0.133 (House of Butterflies)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Aug 2012 16:18:15 +0800, Feng Tang wrote:

> It's a compile error:
> 
> cc1: warnings being treated as errors util/session.c: In function
> ‘perf_session_deliver_event’: util/include/linux/bitops.h:104: error:
> dereferencing pointer ‘p’ does break strict-aliasing rules
> util/include/linux/bitops.h:96: error: dereferencing pointer ‘p’ does
> break strict-aliasing rules util/session.c:907: note: initialized from
> here util/include/linux/bitops.h:96: note: initialized from here make:
> *** [util/session.o] Error 1
> make: *** Waiting for unfinished jobs....
> 
> Casting the @mask to (void *) still sees the same error
> 
> Thanks,
> Feng

We (ELRepo) are seeing the same error while building kernel 3.7 for RHEL 
6.3 on a 32-bit system. The perf package would build fine if we run 
rpmbuild with the 'i686' target specified on a 64-bit system.

http://elrepo.org/bugs/view.php?id=335

Akemi

