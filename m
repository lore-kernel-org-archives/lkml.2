Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485Ab0HRIxN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 04:53:13 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:35082 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752453Ab0HRIxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 04:53:10 -0400
X-Sasl-enc: SAGcUDpj1bB37/QeKDUuy3aAOjVsvjmjEE6HfcA4W+n6 1282121589
Message-ID: <4C6B9F84.9010000@ladisch.de>
Date: Wed, 18 Aug 2010 10:53:24 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Yong Zhang <yong.zhang0@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: lockdep false positive? -- firewire-core transaction timer vs.
 scsi-core host lock
References: <tkrat.1e48e021935dc8b7@s5r6.in-berlin.de>	<20100817143509.GC2838@zhy> <4C6AB76C.9060809@s5r6.in-berlin.de> <4C6B8562.1070902@ladisch.de> <4C6B9547.8060509@s5r6.in-berlin.de>
In-Reply-To: <4C6B9547.8060509@s5r6.in-berlin.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Clemens Ladisch wrote:
> > Because we might be in interrupt context, replace del_timer_sync() with
> > del_timer().
> 
> Again, is the term "interrupt contexts" meant to include softIRQ contexts?

Yes:
http://www.kernel.org/pub/linux/kernel/people/rusty/kernel-locking/g618.html#GLOSS-INTERRUPTCONTEXT
