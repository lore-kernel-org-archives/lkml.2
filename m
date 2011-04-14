Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932546Ab1DNJ1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 05:27:35 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38045 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757316Ab1DNJ1e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 05:27:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=edEgcVsgOA4lQhYU/Q4MvDBdg/xHOAzBVsqmOftTWgsJqQjQWM+3jjgjynWM6IccrL
         f1zXQiZG4uRMt7aWjisVU5NcA3ILbgGhDnKTc5Xx+g5nhYZT+wrupawLmU//KM5gUarz
         s6l8Oegs9mS/Lg66RBMOJzq9ujK316K5qhu28=
MIME-Version: 1.0
In-Reply-To: <20110414080506.GA23965@elte.hu>
References: <20110406223036.GA15721@digium.com>
	<201104132133.51958.maciej.rutecki@gmail.com>
	<4DA6011F.7070405@openvz.org>
	<20110414064737.GB15535@elte.hu>
	<BANLkTinC18PetP=dzCsfOL_v_1hGv0jUag@mail.gmail.com>
	<20110414080506.GA23965@elte.hu>
Date: Thu, 14 Apr 2011 13:27:33 +0400
X-Google-Sender-Auth: xLymfwo8TQpKUeDP328QTgufWjY
Message-ID: <BANLkTi=Uc+hb9Zgddx=kGCTiwLpCVAV+bQ@mail.gmail.com>
Subject: Re: [regression 2.6.39-rc2][bisected] "perf, x86: P4 PMU - Read
 proper MSR register to catch" and NMIs
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, maciej.rutecki@gmail.com,
        Shaun Ruffell <sruffell@digium.com>, Don Zickus <dzickus@redhat.com>,
        linux-kernel@vger.kernel.org, Lin Ming <ming.m.lin@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 12:05 PM, Ingo Molnar <mingo@elte.hu> wrote:
...
>> If there is no counters overflowed I believe we should not poke LVTPC until
>> we sure NMI comes from it (and counter overflow is the only sign that NMI
>> came from LVTPC as far as I may say, and I see also a possibility for race if
>> counter signal reaches LVTPC and it is being processed inside apic chip
>> {which might take some time too before real NMI signal appears in cpu} and as
>> result hard to tell what we get in output -- double nmi again or something
>> else).
>
> Well, we unmasked unconditionally before. If we unmask conditionally now, we
> risk not unmasking. We risk a completely stuck PMU (there wont ever come *any*
> NMI from it if we ever forget to unmask) versus spurious NMIs.
>
> Maybe we can do it - but it will need a lot of testing on a lot of CPU types to
> make sure there's no other CPU quirks in this area ...
>
> So unless the conditional unmasking fixes a real bug (in kgdb or elsewhere)
> lets unmask unconditionally now to fix the P4 regression in .39 - and queue up
> a *separate* patch that moves it even further down and makes it conditional -
> but queue that up for .40.
>
> Thanks,
>
>        Ingo
>

OK. Ingo I'll send a patch from Don with all tested-by (including me) and my ack
as only get back home. (I don't mind if Don beat me on this ;)
