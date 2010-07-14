Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627Ab0GNX3a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 19:29:30 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40159 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522Ab0GNX32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 19:29:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=DeJF1MW2fSwqFoH3mtQ+W/BQM+85g/N4bvEBj+mff5bKnQXYb4jUKtTcnx3+eiJVFx
         y/PqVgW4sZ6gOy22MPw9PPNp3AD18HxPdl+xn2jEGZ91N4hlshmrqISDnA1tyu3dWEt6
         bqq3+1d5SUIxMdGnXBMc/aJ408T74pZrX4YwQ=
Message-ID: <4C3E4852.9010306@gmail.com>
Date: Thu, 15 Jul 2010 01:29:22 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [patch 0/2] x86: NMI-safe trap handlers
References: <20100714154923.947138065@efficios.com> <20100714170606.GA22373@basil.fritz.box> <20100714170805.GC4955@Krystal> <20100714185617.GB22373@basil.fritz.box>
In-Reply-To: <20100714185617.GB22373@basil.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 07/14/2010 08:56 PM, Andi Kleen wrote:
> On Wed, Jul 14, 2010 at 01:08:05PM -0400, Mathieu Desnoyers wrote:
>> * Andi Kleen (andi@firstfloor.org) wrote:
>>>> x86_32 cannot use vmalloc_sync_all() to sychronize the TLBs from
>>>> every processes because the vmalloc area is mapped in a different
>>>> address space for
>>> That doesn't make sense. vmalloc_all_sync() should work on 32bit
>>> too.  It just needs to walk all processes and fix up every page
>>> table.

Yeah, vmalloc_sync_all() synchronizes everything by walking every page
table, so it should work.  I was saying that just flushing TLB
wouldn't cut it because multiple top level page table entries can be
used to map vmalloc areas.  It seems that both 32 and 64bit does that
tho.

Thanks.

-- 
tejun
