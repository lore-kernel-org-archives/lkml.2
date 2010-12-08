Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635Ab0LHVRA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 16:17:00 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:42489 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756464Ab0LHVQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 16:16:58 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Jason Wessel <jason.wessel@windriver.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haren Myneni <hbabu@us.ibm.com>
References: <1291234036.32004.2008.camel@laptop>
	<m162vdp3l4.fsf@fess.ebiederm.org> <20101202052321.GH18100@redhat.com>
	<1291275270.4023.20.camel@twins> <20101202161502.GL18100@redhat.com>
	<1291764620.2032.1293.camel@laptop>
	<20101208140103.GM21786@redhat.com> <1291818005.28378.38.camel@laptop>
	<20101208144245.GB31703@redhat.com> <1291819684.28378.70.camel@laptop>
	<20101208150243.GC31703@redhat.com> <1291821307.28378.93.camel@laptop>
Date: Wed, 08 Dec 2010 13:16:41 -0800
In-Reply-To: <1291821307.28378.93.camel@laptop> (Peter Zijlstra's message of
	"Wed, 08 Dec 2010 16:15:07 +0100")
Message-ID: <m1mxogezie.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+Qir3W0gXOpdeP+l/nE6+i5FSeTB+dZ6I=
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: infradead.org]
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Peter Zijlstra <peterz@infradead.org>
X-Spam-Relay-Country: 
Subject: Re: perf hw  in kexeced kernel broken in tip
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Wed, 2010-12-08 at 10:02 -0500, Vivek Goyal wrote:
>
>> >but its kdump so its mostly broken by design anyway ;-)
>> 
>> Kdump has its share of problems especially with the fact that
>> kernel/drivers find devices in bad state and are not hardened enough
>> to deal with that. But on bare metal what's the better way of capturing
>> kernel crash dump? Trying to do anything post crash in the kernel is
>> also not very reliable either.
>
> /me <3 RS-232
>
> I haven't found anything better than that... 

True.  But it can be a pain to operate RS-232 at production scale, or to
convince customers to hook up RS-232 just in case your released software
happens to crash.

> And poking at the RS-232 requires less of the kernel to be functional
> than booting into a new kernel (whose image might have been corrupted by
> the dying kernel, etc..)

For debugging a reproducible failure RS-232 wins.  For everything else
there is kdump.  It sucks but it is at least fixable.

And really the kdump kernel should be running a minimalistic hardware
config so you only have to get the chunks of hardware you really care
about working.

As for corruption the kdump kernel lives in an area of memory that we
never DMA to in the primary kernel, and we check a sha256 hash before we
start booting the kdump kernel.  In general kdump fails safe. That is if
it can't makes things work it fails to boot and does nothing to your
system.  Definitely not perfect but if you don't have RS-232 it is the
best I have seen.

Eric


