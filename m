Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482Ab0KWTSI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 14:18:08 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:60470 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756425Ab0KWTSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 14:18:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=GOQyJjHcAHBDGECUqyKvoFgBYB1BWRd1gV5fHmTsnel1QAo57PyNkouWXFKQxS48bT
         O1rHi8IW1sLma9v4QlT+6HcvX1CiNsTLy+bc8IhL36EH7w2oHHqHeww7l+EBT7nUDtDa
         PmcFR9CgPUkR6H26SB7OSLidBQQipg0+D74WY=
Date: Tue, 23 Nov 2010 22:18:01 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Don Zickus <dzickus@redhat.com>, sedat.dilek@gmail.com,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86, perf, nmi: Disable perf if counters are not
	accessable
Message-ID: <20101123191801.GD5997@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 08:07:47PM +0100, Peter Zijlstra wrote:
> On Tue, 2010-11-23 at 22:04 +0300, Cyrill Gorcunov wrote:
> > On Tue, Nov 23, 2010 at 07:27:07PM +0100, Peter Zijlstra wrote:
> > > On Tue, 2010-11-23 at 19:21 +0100, Sedat Dilek wrote:
> > > > Due to BIOS l(ocal)apic is not possible:
> > > > 
> > > > # dmesg | grep -i apic
> > > > [    0.000000] Using APIC driver default
> > > > [    0.000000] Local APIC disabled by BIOS -- you can enable it with "lapic"
> > > > [    0.000000] APIC: disable apic facility
> > > > [    0.000000] APIC: switched to apic NOOP
> > > > [    0.008891] no APIC, boot with the "lapic" boot parameter to force-enable it.
> > > > [    0.036141] Local APIC not detected. Using dummy APIC emulation. 
> > > 
> > > Have you tried booting with "lapic" as the second last msg suggests you
> > > do?
> > 
> >  Peter, Don, might not we need something like the patch below -- ie to check for
> > apic earlier and do not acquire cpu for PERF cpu bit, and its cpu model, etc
> > if there is no active apic? And perhaps for nmi-watchdog, we should not try
> > to creat perf event for same reason and simply report that nmi-watchdog is
> > disabled (though of course hpet based one should try to continue).
> > 
> >  No?
> > 
> 
> Ah, no.. now I get what you mean.
> 
> We can use the pmu without interrupt with we miss the lapic, that is
> perf-stat will still work.
> 

Yeah, I forgot about perf-stat

 Cyrill
