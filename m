Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420Ab2GVSpm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 14:45:42 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:41669 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab2GVSpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 14:45:41 -0400
MIME-Version: 1.0
In-Reply-To: <500C4013.2080101@mageia.org>
References: <CALELsEM07z6BckpSvEUrdJU5T3715uED=9g=K3OicnjRP=O6nw@mail.gmail.com>
 <500C4013.2080101@mageia.org>
From: Alexandre Ferrando <alferpal@gmail.com>
Date: Sun, 22 Jul 2012 20:45:00 +0200
Message-ID: <CALELsENtvcwzq+BO_L3Jo-2_kMtFJRpjgnmPiWjyFvR-_7V7oQ@mail.gmail.com>
Subject: Re: PROBLEM: Build fails in 3.4.6
To: Thomas Backlund <tmb@mageia.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 July 2012 20:01, Thomas Backlund <tmb@mageia.org> wrote:
> 22.07.2012 18:02, Alexandre Ferrando skrev:
>> Summary: Linux kernel 3.4.6 fails to build in some cases when
>> CONFIG_NO_HZ is set
>>
>> Full description: Kernel build using configurations [ 0 ] (mine,
>> trying to build the zen kernel) and [ 1 ] (from someone using
>> slackware) fail to build with this error message when CONFIG_NO_HZ is
>> set:
>>
>> kernel/built-in.o: In function `tick_nohz_stop_sched_tick.isra.9':
>> tick-sched.c:(.text+0x4a3e9): undefined reference to `calc_load_enter_idle'
>> kernel/built-in.o: In function `tick_nohz_idle_exit':
>> (.text+0x4a767): undefined reference to `calc_load_exit_idle'
>>
>> Unsetting CONFIG_NO_HZ solves the issue.
>>
>> However, CONFIG_NO_HZ seems not to be the root of the problem because
>> this configuration [ 2 ] of the zen kernel and Arch's stock kernel [ 3
>> ] both build with CONFIG_NO_HZ set
>
> This fallout comes from the BFS scheduler patch in zen kernel that is
> not updated/adapted for the:
>
> sched-nohz-rewrite-and-fix-load-avg-computation-again.patch
>
> that went into 3.4.6
>
>
> --
> Thomas
>
>

Thank you for pointing out the root of the issue.

I apologize for bringing in an issue related to code not included into
the mainstream kernel.
