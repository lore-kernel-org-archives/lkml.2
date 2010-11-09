Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab0KIWLe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 17:11:34 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:47041 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab0KIWLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 17:11:33 -0500
MIME-Version: 1.0
In-Reply-To: <1289339119.2191.92.camel@laptop>
References: <1289339119.2191.92.camel@laptop>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 9 Nov 2010 23:11:17 +0100
Message-ID: <AANLkTimb=R0aqtfL=eZpwj=KqJchHU+nhMnjk5ME9BNr@mail.gmail.com>
Subject: Re: [RFC][PATCH] perf: sysfs type id
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Lin Ming <ming.m.lin@intel.com>, Stephane Eranian <eranian@google.com>,
        "robert.richter" <robert.richter@amd.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        fweisbec <fweisbec@gmail.com>, paulus <paulus@samba.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 9, 2010 at 22:45, Peter Zijlstra <peterz@infradead.org> wrote:
> The below is a RFC patch adding dynamic type ids to perf.
>
> We need to represent PMUs in sysfs because we want to allow multiple
> (loadable) PMUs and need a way to identify them.
>
> This patch creates a new device class "pmu" and adds a single attribute
> "type" to it. This device attribute will expose the dynamic type id as
> required by perf_event_attr::type.
>
> The sysfs layout looks like:
>
> [root@westmere ~]# cd /sys/class/pmu/

Please use a 'bus_type' instead of 'class'.

I'm very sure, some day, you'll need global attributes for the pmu
stuff, and class -- unlike bus -- has its own subdir where you can go
wild, without mixing things with the list-of-devices. :)

No new stuff should use 'class', it's not extensible.

Kay
