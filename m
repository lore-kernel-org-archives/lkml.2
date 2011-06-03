Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449Ab1FCKDF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 06:03:05 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:23792 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405Ab1FCKDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 06:03:03 -0400
X-RZG-AUTH: :IGUXYVOIf/Z0yAghYbpIhzghmj8icP68r1arC3zTx2B9G7/f7yb6+x1CF1B3oIP27v4=
X-RZG-CLASS-ID: mo00
Message-ID: <4DE8B13D.9020302@die-jansens.de>
Date: Fri, 03 Jun 2011 12:02:37 +0200
From: Arne Jansen <lists@die-jansens.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/locking] sched: Add p->pi_lock to task_rq_lock()
References: <20110405152729.232781355@chello.nl>	 <tip-0122ec5b02f766c355b3168df53a6c038a24fa0d@git.kernel.org>	 <4DE64596.5010006@die-jansens.de> <1306946120.2497.606.camel@laptop>	 <4DE674EB.1000200@die-jansens.de> <1306951751.2497.626.camel@laptop>	 <1306953870.2497.627.camel@laptop> <4DE6936F.7090700@die-jansens.de>	 <BANLkTimXXR1mJDtdCsbXF410sd3irFSitQ@mail.gmail.com> <1307092535.2353.2973.camel@twins>
In-Reply-To: <1307092535.2353.2973.camel@twins>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03.06.2011 11:15, Peter Zijlstra wrote:
> On Thu, 2011-06-02 at 06:09 +0900, Linus Torvalds wrote:
>> Boot-time hang - maybe due to the mis-merge that re-introduced the
>> infinite media change signals for ide-cd?
>>
>> I just pushed out a fix, it may not have mirrored out yet.
>>
>> I dunno. Worth checking out before spending a lot of time bisecting.
> 
> Right, so that wasn't it. I haven't done a full bisect yet because I
> noticed it died on a usb suspend line every single time and that machine
> only had a single usb device, a memory stick, in it. So I simply pulled
> the stick and voila it booted. So something is screwy with usb suspend
> or something.
> 
> This of course means that I'm now completely unable to reproduce the
> issue at hand :/
> 
> Maybe if I try another box..
> 
> Anyway, Arne, how long did you wait before power cycling the box? The
> NMI watchdog should trigger in about a minute or so if it will trigger
> at all (its enabled in your config).

No, it doesn't trigger, but the hang is not as complete as I first
thought. A running iostat via ssh continues to give output for a while,
the serial console still reacts to return and prompts for login. But
after a while more and more locks up. The console locks as soon as I
sysrq-t.
Maybe it has also something to do with the place where I added the
printks (btrfs_scan_one_device). Also the 10k-print gets triggered
several times (though I only see 10 lines of output). Maybe you can
send me your test-module and I'll try that, so we have more equal
conditions.
What also might help: the maschine I'm testing with is a quad-core
X3450 with 8GB RAM.
