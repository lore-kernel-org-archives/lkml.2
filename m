Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab0I2Ppd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 11:45:33 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:56453 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab0I2Ppc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 11:45:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hlBoe2fGkLzk9hK/TMEFAOoxRPEpa3MrrJKwLleYXMlvWcfqHr4GkPSTf8U9L3ceK3
         8eHRayzk5yAH+4aooMb23len8Q038oLoDVq5cmhbBpAbJQkfv8faoaoSB1bUUHpdwVdb
         L2BTUaZE7XAxGfBW+oqoksKhbI/T7YrSkeUiY=
Date: Wed, 29 Sep 2010 19:45:28 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: Robert Richter <robert.richter@amd.com>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [tip:perf/urgent] perf, x86: Catch spurious interrupts after
	disabling counters
Message-ID: <20100929154528.GD9440@lenovo>
References: <tip-63e6be6d98e1a2bcdca86872b67052e51ab6afa1@git.kernel.org> <AANLkTimB2gf=2zYCwiKEgozt_Rsa1Cpb6JuLSzmHusFX@mail.gmail.com> <20100929125301.GG13563@erda.amd.com> <20100929125453.GH13563@erda.amd.com> <AANLkTimoE8wAhT+yxXBPnZvTTGrAtDjdaXPBN3Xg28eL@mail.gmail.com> <AANLkTi=WYU2=4Hu7tb+TSrhJw9K9du19_KjMcG3ij=qn@mail.gmail.com> <20100929150140.GK13563@erda.amd.com> <20100929151253.GL13563@erda.amd.com> <20100929152745.GC9440@lenovo> <AANLkTikvYreYiyCbGeG02j+r4dWVLRH7BqeeG9O=VTNN@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikvYreYiyCbGeG02j+r4dWVLRH7BqeeG9O=VTNN@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 05:33:07PM +0200, Stephane Eranian wrote:
> Robert,
> 
> There is something else bothering me with cpuc->running.
> 
> It is not reset outside of the interrupt handler. So what if
> event scheduling shuffles things around and an event is
> moved somewhere else. Don't you need to clear the
> cpuc->running[idx] for the old counter index?
> 
> 

Both bitmasks are set and test with same index though it might
be a bit obscure scheme (we could be clearing this bit in
x86_pmu_stop but it just a wasting cycles).

Btw, since x86 architectural and p4 are using same tests for
running I presume better to have some helper rather then
open coded pile?

Cyrill
