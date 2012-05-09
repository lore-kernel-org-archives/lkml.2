Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758302Ab2EILRR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 07:17:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48154 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758021Ab2EILRP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 07:17:15 -0400
Message-ID: <1336555184.2527.6.camel@twins>
Subject: Re: [PATCH 0/5] [x86]: Improve secondary CPU bring-up process
 robustness
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Igor Mammedov <imammedo@redhat.com>
Cc: linux-kernel@vger.kernel.org, rob@landley.net, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, luto@mit.edu,
        suresh.b.siddha@intel.com, avi@redhat.com, johnstul@us.ibm.com,
        arjan@linux.intel.com, linux-doc@vger.kernel.org
Date: Wed, 09 May 2012 11:19:44 +0200
In-Reply-To: <1336559102-28103-1-git-send-email-imammedo@redhat.com>
References: <1336559102-28103-1-git-send-email-imammedo@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 12:24 +0200, Igor Mammedov wrote:
> Target audience for this patches is mostly virt. environments, where
> physical CPUs are shared beetween many guests and on overcommited
> host it can uncover different race conditions during secondary CPU
> bring-up.

The good news is that you're working on this, the bad news is that all
this code is slated for the scrap heap :-)

Thomas is currently in the process of doing a massive overhaul of the
hotplug code, included in that would be the stuff you're touching.

Every architecture does this hand-shake differently and probably buggy,
all that needs to move into generic code. The only bits needed in the
arch code are the cpu wakeup and initial trampoline, the rest should be
generic.

I'm not quite sure how far along he is, but it would be awesome if you
could help him out somehow.
