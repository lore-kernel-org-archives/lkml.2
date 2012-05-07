Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736Ab2EGI1e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 04:27:34 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:46344 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636Ab2EGI1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 04:27:32 -0400
X-AuditID: 9c930179-b7c19ae000000486-48-4fa7876febc8
From: Namhyung Kim <namhyung.kim@lge.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7] perf ui/gtk: Use struct perf_error_ops
References: <1335761711-31403-1-git-send-email-namhyung.kim@lge.com>
	<1335761711-31403-8-git-send-email-namhyung.kim@lge.com>
	<alpine.LFD.2.02.1204300923010.2090@tux.localdomain>
	<87ipghsjsk.fsf@sejong.aot.lge.com> <20120507081051.GD16608@gmail.com>
Date: Mon, 07 May 2012 17:26:06 +0900
In-Reply-To: <20120507081051.GD16608@gmail.com> (Ingo Molnar's message of
	"Mon, 7 May 2012 10:10:51 +0200")
Message-ID: <87zk9kqtwh.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 7 May 2012 10:10:51 +0200, Ingo Molnar wrote:
> * Namhyung Kim <namhyung.kim@lge.com> wrote:
>
>> Hi,
>> 
>> On Mon, 30 Apr 2012 09:31:28 +0300 (EEST), Pekka Enberg wrote:
>> > On Mon, 30 Apr 2012, Namhyung Kim wrote:
>> >> Define and use perf_gtk_eops to provide a GTK2 message
>> >> dialog for error reporting. To do that, we need global
>> >> main_window variable for tracking UI state.
>> >> 
>> > I think this is an usability glitch waiting to happen - especially so if 
>> > you use it for warnings. There's no reason to require the user to react to 
>> > warning messages in the GUI because there's absolutely nothing they can do 
>> > about them.
>> >
>> > I guess we could do something like the "ui helpline" thing used by the 
>> > newt front-end if we really wanted to.
>> >
>> > 			Pekka
>> 
>> I did quick grep on ui__warning and found that most of its 
>> users are trying to show the messages before exiting. I think 
>> some (at least) of them can be converted to ui__error(). And 
>> as existing implementation (TUI) already requires user input 
>> for this, I thought it's ok.
>> 
>> But I agreed with you that ui__warning should not be used for 
>> showing non-critical messages and converted to helpline-style 
>> ones.
>
> If they are in essence ui__error() already then please convert 
> them to ui__error() instead of perpetuating the mistake - don't 
> force annoying pop-ups for warnings that may or may not be 
> fatal. Spurious pop-ups are sad and people hate them.
>

Ok, will do that in another patch (series). So you mean ui__warning
should not be a pop-up dialog, right?

Thanks,
Namhyung
