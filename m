Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab0JSWLz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 18:11:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60615 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753683Ab0JSWLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 18:11:54 -0400
Message-ID: <4CBE1781.1050000@zytor.com>
Date: Tue, 19 Oct 2010 15:11:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Daniel Drake <dsd@laptop.org>
CC: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org, dilinger@queued.net,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@amd64.org>,
        "Roedel, Joerg" <Joerg.Roedel@amd.com>
Subject: Re: [PATCH] OLPC: Add XO-1 suspend/resume support
References: <20101019220159.0DBBE9D401B@zog.reactivated.net>
In-Reply-To: <20101019220159.0DBBE9D401B@zog.reactivated.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2010 03:01 PM, Daniel Drake wrote:
> Add code needed for basic suspend/resume of the XO-1 laptop.
> 
> swsusp_pg_dir needs to be exposed as it is used by the assembly
> code run in the wakeup path.
> 

Okay... this is Yet Another Reason why we need to unify all the bloody
trampoline page tables.

What it comes down to is that there are several users which need a 1:1
mapped pagetable and a chunk of memory < 1 MiB, and they should all be
combined and linked together, and share a single pagetable set that
sticks around.

Borislav has already been doing some of this work:

[PATCH] x86-32, mm: Add an initial page table for core bootstrapping

I thought that patch was already in -tip, but it looks like it's not...
Borislav/Joerg... was there a newer patch or did we just miss the final
version?  I remember we talked about this at some length, but it looks
like I dropped the ball (I was on vacation when the above message was
posted.)

	-hpa
