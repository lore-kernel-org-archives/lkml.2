Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796Ab2BCPiM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 10:38:12 -0500
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:38676 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420Ab2BCPiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 10:38:10 -0500
Message-ID: <4F2BFF4C.5050905@de.ibm.com>
Date: Fri, 03 Feb 2012 16:37:48 +0100
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Reply-To: gerald.schaefer@de.ibm.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
CC: Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Martin Schwidefsky <martin.schwidefsky@de.ibm.com>,
        Heiko Carstens <h.carstens@de.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Chris Wright <chrisw@sous-sol.org>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: ksm/memory hotplug: lockdep warning for ksm_thread_mutex vs.
 (memory_chain).rwsem
References: <4F2AB614.1060907@de.ibm.com> <CAHGf_=rm286b5FWVRQ8Ob0vakxNcNOHPUksCtnZj4PvOEz47Jg@mail.gmail.com>
In-Reply-To: <CAHGf_=rm286b5FWVRQ8Ob0vakxNcNOHPUksCtnZj4PvOEz47Jg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12020315-0542-0000-0000-000000E442B6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03.02.2012 00:00, KOSAKI Motohiro wrote:
> 2012/2/2 Gerald Schaefer<gerald.schaefer@de.ibm.com>:
>> Setting a memory block offline triggers the following lockdep warning. This
>> looks exactly like the issue reported by Kosaki Motohiro in
>> https://lkml.org/lkml/2010/10/25/110. Seems like the resulting commit a0b0f58cdd
>> did not fix the lockdep warning. I'm able to reproduce it with current 3.3.0-rc2
>> as well as 2.6.37-rc4-00147-ga0b0f58.
>>
>> I'm not familiar with lockdep annotations, but I tried using down_read_nested()
>> for (memory_chain).rwsem, similar to the mutex_lock_nested() which was
>> introduced for ksm_thread_mutex, but that didn't help.
> 
> Heh, interesting. Simple question, do you have any user visible buggy
> behavior? or just false positive warn issue?
> 
> *_nested() is just hacky trick. so, any change may break their lie.
> Anyway I'd like to dig this one. thanks for reporting.

There is no real deadlock and no user visible buggy behaviour, the memory is
being offlined as requested. I think your conclusion from last time is still
valid, that both locks are inside mem_hotplug_mutex and there can't be a
deadlock. Question is how to convince lockdep of this.

