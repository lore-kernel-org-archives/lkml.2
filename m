Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab1GOW5g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 18:57:36 -0400
Received: from smtp-out.google.com ([216.239.44.51]:61021 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab1GOW5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 18:57:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:sender:date:from:to:cc:subject:message-id:
	references:mime-version:content-type:content-disposition:in-reply-to:
	x-operating-system:user-agent:x-system-of-record;
	b=jimo8SeTlEDomb9PRHZ5+/Sqr7hdskfLQ7nJS/VxFFVHRj3BXsAAxgqRlWAjf6Ctv
	8cXB1lVlVJzuqfBObvK4Q==
Date: Fri, 15 Jul 2011 15:57:07 -0700
From: Mandeep Singh Baines <msb@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mandeep Singh Baines <msb@chromium.org>, Huang Ying <ying.huang@intel.com>,
        Andi Kleen <ak@linux.intel.com>, Hugh Dickins <hughd@chromium.org>,
        Olaf Hering <olaf@aepfle.de>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] panic, vt: do not force oops output when panic_timeout
 < 0
Message-ID: <20110715225707.GE17254@google.com>
References: <1308612129-12488-1-git-send-email-msb@chromium.org>
 <1308612129-12488-2-git-send-email-msb@chromium.org>
 <20110622223039.GA13916@google.com>
 <20110706163312.17c104dc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110706163312.17c104dc.akpm@linux-foundation.org>
X-Operating-System: Linux/2.6.32-gg426-generic (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton (akpm@linux-foundation.org) wrote:
> On Wed, 22 Jun 2011 15:30:39 -0700
> Mandeep Singh Baines <msb@chromium.org> wrote:
> 
> > Mandeep Singh Baines (msb@chromium.org) wrote:
> > > Avoid risk (of screen_unblank) and wasted cycles unblanking if
> > > you intend to reboot immediately.
> > > 
> > 
> > The original patch doesn't work. It worked fine when I tested with
> > a serial port. When I disabled the serial out, my machine started to
> > get wedged on a panic. I guess screen_unblank was in bust_spinlocks
> > for a reason. It probably bust some spin_locks somewhere.
> > 
> > Below is a replacement for this patch which calls screen_unblank but
> > does not force output when the panic timeout is negative (no wait).
> > 
> > -- >8 -- (snip)
> > 
> > Don't force output if you intend to reboot immediately.
> > 
> > This patch depends on:
> > 
> > http://lkml.kernel.org/r/1308612129-12488-1-git-send-email-msb@chromium.org
> 
> Please fold this into that and resend the patch series.  Please add
> the needed update to Documentation/kernel-parameters.txt.

Done:

http://lkml.kernel.org/r/1310770401-10739-1-git-send-email-msb@chromium.org
