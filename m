Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab0DYRQ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 13:16:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58679 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752830Ab0DYRQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 13:16:56 -0400
Date: Sun, 25 Apr 2010 10:15:07 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@suse.de>,
       Rik van Riel <riel@redhat.com>, John Stoffel <john@stoffel.org>,
       Hedi Berriche <hedi@sgi.com>, Mike Travis <travis@sgi.com>,
       Ingo Molnar <mingo@elte.hu>, Jack Steiner <steiner@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Robin Holt <holt@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch 1/1] init: Provide a kernel start parameter to increase
 pid_max v2
In-Reply-To: <20100425071606.GB1275@ucw.cz>
Message-ID: <alpine.LFD.2.00.1004251002480.3739@i5.linux-foundation.org>
References: <20100421165934.GN16427@zorg.emea.sgi.com> <4BCF336B.1050706@redhat.com> <19407.20109.308816.104856@stoffel.org> <20100421193350.GU16427@zorg.emea.sgi.com> <19407.23456.469074.256306@stoffel.org> <20100421222414.GA26241@suse.de> <4BCF80F2.2010906@redhat.com>
 <20100421232200.GA22877@suse.de> <20100422102852.72837494@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.1004220743080.9086@i5.linux-foundation.org> <20100425071606.GB1275@ucw.cz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 25 Apr 2010, Pavel Machek wrote:
> 
> Issue with max_pids is that it can break userspace, right?

Iirc, some _really_ old code used 'short' for pid_t, and we wanted to be 
really safe when we raised the limits. 

I seriously doubt we need to worry about old binaries like that on any 16+ 
CPU machines, though.

The other issue is just the size of the pidmap[] array. Instead of walking 
all the processes to see "is this pid in use" (like I think the original 
Linux kernel did), we have a bitmap of used pids. When you raise pid_max, 
that bitmap obviously still needs to be big enough. Right now we allocate 
that statically (rather than growing it dynamically), so we end up having 
a _hard_ limit of PID_MAX_LIMIT too.

On 32-bit, I think that still maximum limit ends up being basically 32767. 
So again, on a _legacy_ system, you end up being limited in the number of 
pid_t entries.

				Linus
