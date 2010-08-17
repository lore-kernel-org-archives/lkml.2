Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935Ab0HQQX1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 12:23:27 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:36860 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757844Ab0HQQX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 12:23:26 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4C6AB76C.9060809@s5r6.in-berlin.de>
Date: Tue, 17 Aug 2010 18:23:08 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Yong Zhang <yong.zhang0@gmail.com>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: lockdep false positive? -- firewire-core transaction timer vs.
 scsi-core host lock
References: <tkrat.1e48e021935dc8b7@s5r6.in-berlin.de> <20100817143509.GC2838@zhy>
In-Reply-To: <20100817143509.GC2838@zhy>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yong Zhang wrote:
> I suspect it's introduced by commit 5c40cbfefa828208c671e2f58789e4dd04f79563
> which call del_timer_sync() in softirq.
> 
> comments on del_timer_sync() say "It must not be called from interrupt contexts."

I hope the del_timer_sync kerneldoc comment is about hardIRQ context,
*otherwise* commit 5c40cbfe is defective indeed.

The firewire stack calls del_timer_sync in process or softIRQ context
(firewire-ohci tasklets, block layer soft IRQ, networking soft IRQ...)
but never from hardIRQ.
-- 
Stefan Richter
-=====-==-=- =--- =---=
http://arcgraph.de/sr/
