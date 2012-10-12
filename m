Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933175Ab2JLNgR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 09:36:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51345 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932805Ab2JLNf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 09:35:59 -0400
Date: Fri, 12 Oct 2012 15:35:54 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Ma, Ling" <ling.ma@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 2/2] [x86] Optimize copy_page by re-arranging instruction sequence and saving register
Message-ID: <20121012133554.GA16230@one.firstfloor.org>
References: <1349958548-1868-1-git-send-email-ling.ma@intel.com> <m2bog9t9cr.fsf@firstfloor.org> <B2310DA9850C8743AA7AA0055500E90F0FD709C4@SHSMSX102.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B2310DA9850C8743AA7AA0055500E90F0FD709C4@SHSMSX102.ccr.corp.intel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I tested new and original version on core2, the patch improved performance about 9%,

That's not useful because core2 doesn't use this variant, it uses the
rep string variant. Primary user is P4.

> Although core2 is out-of-order pipeline and weaken instruction sequence requirement, 
> because of ROB size limitation, new patch issues write operation earlier and
> get more parallelism possibility for the pair of write and load ops and better result.
> Attached core2-cpu-info (I have no older machine)

If you can't test the CPUs who run this code I think it's safer if you
add a new variant for Atom, not change the existing well tested code.
Otherwise you risk performance regressions on these older CPUs.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
