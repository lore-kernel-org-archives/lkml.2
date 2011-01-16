Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab1APADf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 19:03:35 -0500
Received: from lo.gmane.org ([80.91.229.12]:60006 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875Ab1APADe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 19:03:34 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: walt <w41ter@gmail.com>
Subject: Re: 2.6.37-ck1
Date: Sat, 15 Jan 2011 16:03:14 -0800
Message-ID: <4D3235C2.7020104@gmail.com>
References: <201101061619.06992.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: adsl-69-234-196-59.dsl.irvnca.pacbell.net
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:2.0b8pre) Gecko/20101119 Thunderbird/3.3a1
In-Reply-To: <201101061619.06992.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2011 09:19 PM, Con Kolivas wrote:
> These are patches designed to improve system responsiveness and interactivity
> with specific emphasis on the desktop, but suitable to any workload.
>
>
> Apply to 2.6.37:
> http://www.kernel.org/pub/linux/kernel/people/ck/patches/2.6/2.6.37/2.6.37-
> ck1/patch-2.6.37-ck1.bz2

Thanks Con.  I can't build a ck kernel without CONFIG_HOTPLUG_CPU but I don't
know if this is a bug or a feature :)

Your latest sched_bfs.c encloses the subroutine sched_set_stop_task() inside of
an #ifdef CONFIG_HOTPLUG_CPU section.

But the most recent stop_machine.c uses that subroutine twice -- once inside of
an #ifdef CONFIG_HOTPLUG_CPU section, and again outside of that section.

The result is that stop_machine.o still needs sched_set_stop_task() even if
CONFIG_HOTPLUG_CPU is not defined, so the build fails in the link stage with
a missing symbol error.

Thanks for any suggestions/clarifications.

