Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004Ab2BBXBH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 18:01:07 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35766 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321Ab2BBXBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 18:01:05 -0500
MIME-Version: 1.0
In-Reply-To: <4F2AB614.1060907@de.ibm.com>
References: <4F2AB614.1060907@de.ibm.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Thu, 2 Feb 2012 18:00:45 -0500
Message-ID: <CAHGf_=rm286b5FWVRQ8Ob0vakxNcNOHPUksCtnZj4PvOEz47Jg@mail.gmail.com>
Subject: Re: ksm/memory hotplug: lockdep warning for ksm_thread_mutex vs. (memory_chain).rwsem
To: gerald.schaefer@de.ibm.com
Cc: Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Martin Schwidefsky <martin.schwidefsky@de.ibm.com>,
        Heiko Carstens <h.carstens@de.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Chris Wright <chrisw@sous-sol.org>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/2 Gerald Schaefer <gerald.schaefer@de.ibm.com>:
> Setting a memory block offline triggers the following lockdep warning. This
> looks exactly like the issue reported by Kosaki Motohiro in
> https://lkml.org/lkml/2010/10/25/110. Seems like the resulting commit a0b0f58cdd
> did not fix the lockdep warning. I'm able to reproduce it with current 3.3.0-rc2
> as well as 2.6.37-rc4-00147-ga0b0f58.
>
> I'm not familiar with lockdep annotations, but I tried using down_read_nested()
> for (memory_chain).rwsem, similar to the mutex_lock_nested() which was
> introduced for ksm_thread_mutex, but that didn't help.

Heh, interesting. Simple question, do you have any user visible buggy
behavior? or just false positive warn issue?

*_nested() is just hacky trick. so, any change may break their lie.
Anyway I'd like to dig this one. thanks for reporting.
