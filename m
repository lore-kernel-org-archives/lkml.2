Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237Ab1ADPfN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 10:35:13 -0500
Received: from smtp-out.google.com ([74.125.121.67]:14839 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649Ab1ADPfL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 10:35:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AICAfm0bl9G4RbVFxSQPh0wCl9+wUQeKjKHYSPDAFBbg3++Is1OLYtwndMQvBmLqpc
         7X/czFXju8Jh0Q1hItEg==
MIME-Version: 1.0
In-Reply-To: <1294149501.2016.141.camel@laptop>
References: <1293464211.2695.104.camel@localhost>
	<AANLkTimp9VgD4qhOVmq-k1Ckzti9eeV8pf6Jvt5YB6nx@mail.gmail.com>
	<1293526288.2457.4.camel@minggr.sh.intel.com>
	<1294052312.2016.50.camel@laptop>
	<4D222926.9010206@zytor.com>
	<1294139419.2016.115.camel@laptop>
	<AANLkTinGmgB7YhRjnsGMjj2knDuJ8XFps9oyW4+EGOr5@mail.gmail.com>
	<1294148675.2016.139.camel@laptop>
	<AANLkTima_wh1Nd2E-zQAcymmux1O0e1GzVEdnhLEMOo5@mail.gmail.com>
	<1294149501.2016.141.camel@laptop>
Date: Tue, 4 Jan 2011 16:35:00 +0100
Message-ID: <AANLkTinZbfb0-fwr0QghDfqz13aJVBL=8dUggYeYm48q@mail.gmail.com>
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

On Tue, Jan 4, 2011 at 2:58 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Tue, 2011-01-04 at 14:52 +0100, Stephane Eranian wrote:
>>
>> Couldn't you simply over-provision, and then when the CPU is online, use my
>> ht_enabled statement to figure out whether or not you need to handle the sharing
>> issue?
>
> That's pretty much what Lin's latest does:
>
>  X86_FEATURE_HT && smp_num_siblings > 1
>
> shows the CPU is capable of HT and will allocate the needed resources.
>
Ok, but once the CPU is online, you can still check whether or not HT is
enabled. If not, then you don't need to bother with the MSR sharing code.
So you may allocate a data structure which you won't use and I think that's
fine given we don't have a good way of figuring out whether HT is enabled
or not.
