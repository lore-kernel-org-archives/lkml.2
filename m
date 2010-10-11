Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab0JKQOI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 12:14:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:40325 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641Ab0JKQOH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 12:14:07 -0400
Subject: Re: [PATCH -v3 3/6] x86, NMI, Rewrite NMI handler
From: Peter Zijlstra <peterz@infradead.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>
In-Reply-To: <1286606987-19879-3-git-send-email-ying.huang@intel.com>
References: <1286606987-19879-1-git-send-email-ying.huang@intel.com>
	 <1286606987-19879-3-git-send-email-ying.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 11 Oct 2010 18:13:55 +0200
Message-ID: <1286813635.2336.617.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-10-09 at 14:49 +0800, Huang Ying wrote:
> notify_die(DIE_NMI_IPI);
> notify_die(DIE_NMI);
> /* process io port 0x61 */
> nmi_watchdog_touch();
> unknown_nmi(); 

Why keep NMI_IPI? What the heck is it for?

I'd like to see:

 DIE_NMI
 DIE_NMI_UNKNOWN

In DIE_NMI we walk the chain and deal with NMIs, in DIE_NMI_UNKNOWN we
try to consume extra NMIs where possible (like the much discussed extra
PMU interrupts).


