Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab2IBP4g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 11:56:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49834 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886Ab2IBP4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 11:56:34 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.1209021005090.22050@twin.jikos.cz>
References: <CALKntY00bG_wVpOGM_L9ENLqROgSO_TttXJeTkgkERdtpnwi_A@mail.gmail.com>
	<alpine.LRH.2.00.1209021005090.22050@twin.jikos.cz>
Date: Sun, 2 Sep 2012 08:56:34 -0700
Message-ID: <CALKntY1XnHG7BAnu4yYU_8iwDttAhuxqu1bBu7YuxXMP4nF+JQ@mail.gmail.com>
Subject: Re: linux page table
From: Xin Tong <xerox.time.tech@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 2, 2012 at 1:10 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Sat, 1 Sep 2012, Xin Tong wrote:
>
>> When a process is created in Linux, corresponding page table is
>> implemented. In the current x86 linux, the page table is a multi-level
>> page table and CR3 points to the first level of the page table.  I
>> have 2 questions.
>>
>> 1. is the value in CR3 virtual address or physical address ?
>
> Physical, otherwise you will have chicken-egg problem.
>
>> 2. can the address of the first level of the page table during a
>> process's lifetime change ?
>
> In theory it would be possible to implement. But I don't see a scenario
> when it might be useful.
>
>> 3. can two different processes have their CR3 being the same value
>> even though they have different first level page tables ?
>
> Yes, if they are created by clone(CLONE_VM). In such case they share the
> same mm_struct, and therefore mm_struct->pgd (which is exactly what is
> loaded into cr3 in switch_mm()) is the same.
>

Is this the COW mechanism in linux. what if the cloned process need to
have set of its own pages later. do the CR3s for the 2 processes
become different at that point ?

> LKML is however very inappropriate list for such questions. Please ask on
> kernelnewbies list next time.
>

Thank you for letting me know. Will do next time.
> --
> Jiri Kosina
> SUSE Labs
>
