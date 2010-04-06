Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502Ab0DFTEH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 15:04:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58297 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757325Ab0DFTD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 15:03:58 -0400
Date: Tue, 6 Apr 2010 12:03:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Borislav Petkov <bp@alien8.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux
 2.6.34-rc3)
Message-Id: <20100406120315.53ad7390.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1004061053450.3487@i5.linux-foundation.org>
References: <20100402175937.GA19690@liondog.tnic>
	<alpine.LFD.2.00.1004021059010.3634@i5.linux-foundation.org>
	<20100406173754.7E5A.A69D9226@jp.fujitsu.com>
	<4BBB475A.7070002@redhat.com>
	<1270568096.1814.145.camel@barrios-desktop>
	<alpine.LFD.2.00.1004060841460.3487@i5.linux-foundation.org>
	<1270571019.1814.163.camel@barrios-desktop>
	<alpine.LFD.2.00.1004060926430.3487@i5.linux-foundation.org>
	<1270572327.1711.3.camel@barrios-desktop>
	<alpine.LFD.2.00.1004060951030.3487@i5.linux-foundation.org>
	<4BBB69A9.5090906@redhat.com>
	<alpine.LFD.2.00.1004061053450.3487@i5.linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Apr 2010 11:28:52 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> For example, maybe some list corruption causes us to do that 
> "anon_vma_chain_link()" _twice_ on the same avc entry. So we do that 
> "list_add_tail(&avc->same_anon_vma, &anon_vma->head);" on an entry that 
> already had "same_anon_vma" on one list.

The lib/list_debug.c stuff might detect such things.  I wonder if
either Borislav or Steinar had CONFIG_DEBUG_LIST enabled?
