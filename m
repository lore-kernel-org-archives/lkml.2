Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722Ab2EGNK1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 09:10:27 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45380 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756105Ab2EGNK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 09:10:26 -0400
Date: Mon, 7 May 2012 15:10:21 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Don Zickus <dzickus@redhat.com>
Cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/2] x86, reboot: revert stop_other_cpus to using IRQ
 with NMI fallback
Message-ID: <20120507131021.GE23858@gmail.com>
References: <1333052651-8200-1-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333052651-8200-1-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Don Zickus <dzickus@redhat.com> wrote:

> The end result of this more 
> complicated-looking-diff-than-it-really-is, is a patch that 
> mostly reverts
> 
> 3603a25 x86, reboot: Use NMI instead of REBOOT_VECTOR to stop cpus
> 
> and instead just sticks another if-case after the REBOOT_IRQ 
> and checks to see if online_cpus are still > 1, and if so, 
> clobber the rest of the cpus with an NMI.

Ok, would be nice to shape this as a 'dumb' revert as-is, and do 
the simple change in a separate patch, or so. That makes it 
easier to review (and easier to debug, should it break).

Thanks,

	Ingo
