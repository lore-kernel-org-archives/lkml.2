Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab0DFPmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 11:42:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64937 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951Ab0DFPmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 11:42:04 -0400
Message-ID: <4BBB55DC.8070509@redhat.com>
Date: Tue, 06 Apr 2010 11:40:12 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Borislav Petkov <bp@alien8.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux 2.6.34-rc3)
References: <20100402175937.GA19690@liondog.tnic>	 <alpine.LFD.2.00.1004021059010.3634@i5.linux-foundation.org>	 <20100406173754.7E5A.A69D9226@jp.fujitsu.com> <4BBB475A.7070002@redhat.com> <1270568096.1814.145.camel@barrios-desktop>
In-Reply-To: <1270568096.1814.145.camel@barrios-desktop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2010 11:34 AM, Minchan Kim wrote:

> Let's see the unlink_anon_vmas.
>
> 1. list_for_each_entry_safe(avc,next, vma->anon_vma_chain, same_vma)
> 2. 	anon_vma_unlink
> 3. 		spin_lock(anon_vma->lock)<-- HERE LOCK.
> 4.		list_del(anon_vma_chain->same_anon_vma);
>
> What if anon_vma is destroyed and reuse by SLAB_XXX_RCU for another
> anon_vma object between 2 and 3?
> I mean how to make sure 3) does lock valid anon_vma?
>
> I hope it is culprit.

How can the anon_vma get destroyed and reused, when this
anon_vma_chain still has a reference to it (and the
anon_vma has not been freed yet)?

What combination of circumstances is necessary for
your bug hypothetical to happen?
