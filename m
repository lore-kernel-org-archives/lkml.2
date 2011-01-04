Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab1ADQ7L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 11:59:11 -0500
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:49182 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751388Ab1ADQ7I convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 11:59:08 -0500
From: Johan MOSSBERG <johan.xx.mossberg@stericsson.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kyungmin Park <kmpark@infradead.org>
Cc: Michal Nazarewicz <m.nazarewicz@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Daniel Walker <dwalker@codeaurora.org>, Mel Gorman <mel@csn.ul.ie>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Ankita Garg <ankita@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Date: Tue, 4 Jan 2011 17:23:37 +0100
Subject: RE: [PATCHv8 00/12] Contiguous Memory Allocator
Thread-Topic: [PATCHv8 00/12] Contiguous Memory Allocator
Thread-Index: AcuiiS90kNZ0eylkRWqEG7I2bbqFpQJmotlg
Message-ID: <C832F8F5D375BD43BFA11E82E0FE9FE00829C13EB2@EXDCVYMBSTM005.EQ1STM.local>
References: <cover.1292443200.git.m.nazarewicz@samsung.com>
 <AANLkTim8_=0+-zM5z4j0gBaw3PF3zgpXQNetEn-CfUGb@mail.gmail.com>
 <20101223100642.GD3636@n2100.arm.linux.org.uk>
In-Reply-To: <20101223100642.GD3636@n2100.arm.linux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King wrote:
> Has anyone addressed my issue with it that this is wide-open for
> abuse by allocating large chunks of memory, and then remapping
> them in some way with different attributes, thereby violating the
> ARM architecture specification?

I seem to have missed the previous discussion about this issue.
Where in the specification (preferably ARMv7) can I find
information about this? Is the problem that it is simply
forbidden to map an address multiple times with different cache
setting and if this is done the hardware might start failing? Or
is the problem that having an address mapped cached means that
speculative pre-fetch can read it into the cache at any time,
possibly causing problems if an un-cached mapping exists? In my
opinion option number two can be handled and I've made an attempt
at doing that in hwmem (posted on linux-mm a while ago), look in
cache_handler.c. Hwmem currently does not use cma but the next
version probably will.

/Johan Mossberg
