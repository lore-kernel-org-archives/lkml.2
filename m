Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab0KJNBx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 08:01:53 -0500
Received: from smtp-out.google.com ([74.125.121.35]:33494 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755875Ab0KJNBw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 08:01:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OHSsD4eUwmX3/W44IX/9gyiYbk6oAiD2HqMFQyyEb2BmtL6bxQwzhCGUbvwhzjBksh
         ktGT+B/D9P/2f70lkg7Q==
MIME-Version: 1.0
In-Reply-To: <1289339119.2191.92.camel@laptop>
References: <1289339119.2191.92.camel@laptop>
Date: Wed, 10 Nov 2010 14:01:48 +0100
Message-ID: <AANLkTi=ojOnLyRO4hTgYdCCXLsN0wUeTcme=5h8-mjdz@mail.gmail.com>
Subject: Re: [RFC][PATCH] perf: sysfs type id
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Lin Ming <ming.m.lin@intel.com>,
        "robert.richter" <robert.richter@amd.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        fweisbec <fweisbec@gmail.com>, paulus <paulus@samba.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

On Tue, Nov 9, 2010 at 10:45 PM, Peter Zijlstra <peterz@infradead.org> wrote:
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
> [root@westmere pmu]# ls -la
> total 0
> drwxr-xr-x  2 root root 0 2010-11-09 22:22 .
> drwxr-xr-x 47 root root 0 2010-11-09 22:22 ..
> lrwxrwxrwx  1 root root 0 2010-11-09 22:22 breakpoint -> ../../devices/virtual/pmu/breakpoint
> lrwxrwxrwx  1 root root 0 2010-11-09 22:22 cpu -> ../../devices/virtual/pmu/cpu
> lrwxrwxrwx  1 root root 0 2010-11-09 22:22 frob -> ../../devices/virtual/pmu/frob
> lrwxrwxrwx  1 root root 0 2010-11-09 22:22 software -> ../../devices/virtual/pmu/software
> lrwxrwxrwx  1 root root 0 2010-11-09 22:22 tracepoint -> ../../devices/virtual/pmu/tracepoint
> [root@westmere pmu]# cd frob/
> [root@westmere frob]# ls -la
> total 0
> drwxr-xr-x 3 root root    0 2010-11-09 22:22 .
> drwxr-xr-x 7 root root    0 2010-11-09 22:22 ..
> drwxr-xr-x 2 root root    0 2010-11-09 22:23 power
> lrwxrwxrwx 1 root root    0 2010-11-09 22:23 subsystem -> ../../../../class/pmu
> -r--r--r-- 1 root root 4096 2010-11-09 22:23 type
> -rw-r--r-- 1 root root 4096 2010-11-09 22:22 uevent
> [root@westmere frob]# cat type
> 6

And then, what do you do with 6?
I assume you have to pass it in the attr struct.
How do you plan on doing this while keeping what is already there?
