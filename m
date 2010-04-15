Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705Ab0DOCyP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 22:54:15 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:42042 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756667Ab0DOCyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 22:54:13 -0400
Date: Thu, 15 Apr 2010 11:54:10 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: David VomLehn <dvomlehn@cisco.com>
Cc: linux-arch@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/23] Make register values available to panic notifiers
Message-ID: <20100415025409.GB8014@linux-sh.org>
References: <20100412060609.GA25273@dvomlehn-lnx2.corp.sa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100412060609.GA25273@dvomlehn-lnx2.corp.sa.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 11, 2010 at 11:06:09PM -0700, David VomLehn wrote:
> o  A save_ptregs() function for the processor. I've taken a whack at
>    doing this for all of the processors. I have tested x86 and MIPS
>    versions. I was able to find cross compilers for ARM, ... and the
>    code compiles cleanly. Everything else, well, what you see is sheer
>    fantasy. You are welcome to chortle with merriment.

Perhaps I'm missing something obvious, but is there some reason why you
can't just reuse the crash_setup_regs() code? MIPS doesn't implement it
presumably because it's lacking kexec crash kernel support, but it would
make sense to make current ptregs saving more generic if there are going
to be multiple users for it.
