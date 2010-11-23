Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381Ab0KWPWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 10:22:17 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51242 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322Ab0KWPWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 10:22:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type;
        b=hwtrYyU/sHkSZuQMXf9yn2ML7PldJimch2qU76uaRghpgItH3J3f4lZu8ypbw62FG6
         zBZqZf2hosiBb3QZuamU3Um09LaGgFem0Wlh5e5XOlBzvVITg+blPyaAhzu9vmcIppAz
         cym+I2My0GxRKGRGUvcIy7glkIrvZE25wyB1g=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Tue, 23 Nov 2010 16:15:05 +0100
Message-ID: <AANLkTikzSY09i=C+A2Y=_gVa-44r_bN76P-U2-NZMnpz@mail.gmail.com>
Subject: Re: [PATCH] x86, perf, nmi: Disable perf if counters are not accessable
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, dzickus@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am seeing for a while this warning in my system-wide logs:

Nov 23 11:54:14 tbox kernel: [    0.040335] NMI watchdog failed to
create perf event on cpu0: ffffffa1

As I saw this patch from [1], I was hoping it's also fixing my problem
on an Intel Pentium-M (Banias) Single-Core CPU:

"So I changed it to:

static bool check_hw_exists(void)
{
        u64 val, val_new = 0;
        int ret = 0;
        val = 0xabcdUL;
        ret |= checking_wrmsrl(x86_pmu.perfctr, val);
        ret |= rdmsrl_safe(x86_pmu.perfctr, &val_new);
        if (ret || val != val_new)
                return false;
        return true;
}
And have applied the patch,

Thanks Don!"

Where did you apply it? Shouldn't that be in linux-2.6-tip perf/* GIT tree?

Regards,
- Sedat -

[1] http://lkml.org/lkml/2010/11/23/121
[2] http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=summary
