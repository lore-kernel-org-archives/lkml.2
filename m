Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238Ab1EQT6H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 15:58:07 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60402 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932184Ab1EQT6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 15:58:04 -0400
Date: Tue, 17 May 2011 21:57:57 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Don Zickus <dzickus@redhat.com>, Huang Ying <ying.huang@intel.com>,
        Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [RFC] ACPI, APEI, Generic Hardware Error Source (GHES)
 injecting support
Message-ID: <20110517195757.GA31067@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@elte.hu>, Don Zickus <dzickus@redhat.com>,
	Huang Ying <ying.huang@intel.com>, Len Brown <lenb@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>,
	"Luck, Tony" <tony.luck@intel.com>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
References: <1304996921-24881-1-git-send-email-ying.huang@intel.com>
 <20110516193301.GF29881@redhat.com>
 <4DD218B1.7080601@intel.com>
 <20110517135027.GJ31888@redhat.com>
 <20110517191803.GC29574@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110517191803.GC29574@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 09:18:03PM +0200, Ingo Molnar wrote:
> So for example [sufficienty privileged] user-space could inject *any*
> perf event - for example a PERF_COUNT_HW_CACHE_MISSES event (for test
> purposes) and any tooling that runs could not tell apart this injected
> event from a real event.

Yeah about that, I was recently speculating how that would work. So do we do

$ perf record ...

in the one xterm, and, in the other,

$ perf inject

so that while recording, we can inject some events from userspace? Or
do we inject it, it gets buffered somewhere in the meantime and then
the next perf record session sees it along with the remaining injection
events?

The ras inject part would obviously only use the callback and the
injection will happen immediately.

Hmm...

-- 
Regards/Gruss,
    Boris.
