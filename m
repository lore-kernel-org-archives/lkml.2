Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758516Ab1DNTgD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 15:36:03 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38510 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757039Ab1DNTgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 15:36:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=TEO4dh5OsgiUbEg1DYZrsOYYu4+xoZs0mvWxJ31BvcYgYT90o9WjnRfDIN6Ga186yT
         JTPpb4qxFo5LBRD7rdV8+KeoztMm1ZG2CsXQPu2EzDdInnBep/rhNNeebJxLtmMQpCG2
         c26bc0qMRQoMrazGn2l4rPg8mmJZJ7E3E8gsM=
Message-ID: <4DA74C9C.9070609@gmail.com>
Date: Thu, 14 Apr 2011 13:35:56 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Shaun Ruffell <sruffell@digium.com>, Ingo Molnar <mingo@elte.hu>,
        Lin Ming <ming.m.lin@intel.com>, Don Zickus <dzickus@redhat.com>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Robert Richter <robert.richter@amd.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf, x86: fix unknown NMIs on a Pentium4 box
References: <4DA70950.3060102@openvz.org> <20110414174327.GA8863@elte.hu> <20110414174420.GA8950@elte.hu> <4DA733B1.1010702@gmail.com> <20110414181226.GA14390@digium.com> <4DA73AC9.6080901@gmail.com>
In-Reply-To: <4DA73AC9.6080901@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/11 12:19, Cyrill Gorcunov wrote:
> On 04/14/2011 10:12 PM, Shaun Ruffell wrote:

> Btw, Shaun, perf top wont work on P4 for a while (since it needs nmi-watchdog
> to be disabled).
> 

perf-top defaults to H/W cycles event. Just need to force it to S/W
events (the fallback for systems that do not support cycles event):
   perf top -e cpu-clock

David
