Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800Ab0ICIdh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 04:33:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:38777 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab0ICIdf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 04:33:35 -0400
Subject: Re: [PATCH 4/4] [x86] perf: fix accidentally ack'ing a second
 event on intel perf counter
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Don Zickus <dzickus@redhat.com>, Robert Richter <robert.richter@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>
In-Reply-To: <AANLkTin2KVPpkQWUa_GQ66q+wvZpfYHOKAfWbG-+K5FD@mail.gmail.com>
References: <AANLkTimA-AZWJugaLR3VPGVhBaJid=t=a1rPVNUE_8Dh@mail.gmail.com>
	 <20100901145728.GM22783@erda.amd.com>
	 <AANLkTikOaCL8FqQuUQsYPxm19WZOdarp8AMAugN0mnqQ@mail.gmail.com>
	 <20100902141900.GG4879@redhat.com>
	 <AANLkTin2KVPpkQWUa_GQ66q+wvZpfYHOKAfWbG-+K5FD@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 03 Sep 2010 10:33:03 +0200
Message-ID: <1283502783.1783.172.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-02 at 16:39 +0200, Stephane Eranian wrote:
> I managed to reproduce on core i7 860 (without patch4).
> Looking at the code again, I am dubious you ever execute
> the retry goto. If the PMU is disabled and you've just
> cleared the OVF_STAT, then I don't see where the new
> overflows would come from. But that's a separate problem.
> 
> One thing I did is to compare status obtained via OVFL_STATUS
> with one that I build manually by inspecting each individual
> counter. The two returned bitmasks should always be identical
> (with PEBS disabled).  When I got the spurious NMI, it did not
> trip my status validation. So the OVFL_STATUS is valid.
> 
> I found something else that looked fishy. I am experimenting
> with it. I will report back. 

One thing we still need to do is on init detect if the BIOS is using one
of the PMCs and simply disable all of perf and print a nice big message
to the user to request a new BIOS from their vendor.


