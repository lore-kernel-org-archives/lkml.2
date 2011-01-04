Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751285Ab1ADNwk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 08:52:40 -0500
Received: from smtp-out.google.com ([216.239.44.51]:35865 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab1ADNwi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 08:52:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bZMPc7bCp3WVMnY44l6TobQcwHlMz/bh8jv2wGDyUbQt9NnwwNNq7eKSs5j+hJYSbS
         LMFtP72Tq6tPYqXXx/gA==
MIME-Version: 1.0
In-Reply-To: <1294148675.2016.139.camel@laptop>
References: <1293464211.2695.104.camel@localhost>
	<AANLkTimp9VgD4qhOVmq-k1Ckzti9eeV8pf6Jvt5YB6nx@mail.gmail.com>
	<1293526288.2457.4.camel@minggr.sh.intel.com>
	<1294052312.2016.50.camel@laptop>
	<4D222926.9010206@zytor.com>
	<1294139419.2016.115.camel@laptop>
	<AANLkTinGmgB7YhRjnsGMjj2knDuJ8XFps9oyW4+EGOr5@mail.gmail.com>
	<1294148675.2016.139.camel@laptop>
Date: Tue, 4 Jan 2011 14:52:36 +0100
Message-ID: <AANLkTima_wh1Nd2E-zQAcymmux1O0e1GzVEdnhLEMOo5@mail.gmail.com>
Subject: Re: [PATCH 4/7] perf: Check if HT is supported and enabled
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Lin Ming <ming.m.lin@intel.com>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 4, 2011 at 2:44 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Tue, 2011-01-04 at 14:38 +0100, Stephane Eranian wrote:
>> My solution at the time (2.6.30) was to do:
>>         ht_enabled = cpumask_weight(__get_cpu_var(cpu_sibling_map)) > 1;
>
> Won't that report a machine a HT disabled when you offline a sibling?

I think you're right. I was not dealing with hotplug CPU.

> Which kinda defeats the purpose of our usage here, since we need to know
> it before either sibling comes online.

Then, it seems the only hope is to peek at a MSR that reports the BIOS setting.
But I don't know which one it is.

Couldn't you simply over-provision, and then when the CPU is online, use my
ht_enabled statement to figure out whether or not you need to handle the sharing
issue?
