Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937Ab0HaIDj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 04:03:39 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:36783 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756889Ab0HaIDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 04:03:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=fFbqqhFab1kVm0cIeIkbUiAu3OEop+JnkyscZKe0mZpr2CoWHGM3RMGjanoKK8ZoDC
         SWmVYrVvV3u5n/uV6wi+is7Kt1J2QR8gHckA+h5G/HXD8c5CuGdg6yPGBAGxll5ryss1
         mbsMHonThBsEbslB4dndMIe2RyDpjiXCHrnqY=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <AANLkTikJMMn5gPwkBJcL7=KYR5wK-DKW=mqoR6Ks0jRH@mail.gmail.com>
References: <4c76802d.aae9d80a.115d.70fe@mx.google.com>
	<tip-fa66f07aa1f0950e1dc78b7ab39728b3f8aa77a1@git.kernel.org>
	<AANLkTikJMMn5gPwkBJcL7=KYR5wK-DKW=mqoR6Ks0jRH@mail.gmail.com>
Date: Tue, 31 Aug 2010 10:03:33 +0200
Message-ID: <AANLkTi=eLkP2foZYN1o36zZ3VgLr5N7WTDhmJw3uP0uo@mail.gmail.com>
Subject: Re: [tip:perf/urgent] perf_events: Fix time tracking for events with
 pid != -1 and cpu != -1
From: stephane eranian <eranian@googlemail.com>
To: Lin Ming <lin@ming.vg>
Cc: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 3:10 AM, Lin Ming <lin@ming.vg> wrote:
>>
>> perf_events: Fix time tracking for events with pid != -1 and cpu != -1
>
> Hi,
>
> I thought pid != -1 and cpu != -1 is not valid.
>

This is in per-thread mode. This is what happens when you do
perf record foo for instance. This is sampling, but you can do
the same with counting.


> # perf top -p 23268 -C 1
> WARNING: PID switch overriding CPU
>
> In which case this could be valid?
>
> Thanks,
> Lin Ming
>
>>
>> Per-thread events with a cpu filter, i.e., cpu != -1, were not
>> reporting correct timings when the thread never ran on the
>> monitored cpu. The time enabled was reported as a negative
>> value.
>
