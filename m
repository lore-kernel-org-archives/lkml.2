Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608Ab0FUVPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 17:15:54 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33743 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758549Ab0FUVPw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 17:15:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=n1mgaaCQcGm3A6/AuK0wvkYQhguYGyK/2xrq76Knx6NJlYO+G3SiTPIbCa/zCusY3C
         4RcfxCPcPSsfjf1Lfe+52nPiUahiok46CRAg3QQ38Z2O8zkhvFrcR4Vn4uRRynzhxGWx
         Wxibq6jLPhwbDoLjfafVQCczW02HcTObNTt7c=
MIME-Version: 1.0
In-Reply-To: <4C1FD1D0.4060803@kernel.org>
References: <4C08FF36.80806@kernel.org>
	<4C0E9E03.1010508@kernel.org>
	<AANLkTimL2dEhIaxztoiDRBY3CsalcVNU54Mko6yg8ZqG@mail.gmail.com>
	<4C1FD1D0.4060803@kernel.org>
Date: Mon, 21 Jun 2010 14:15:51 -0700
X-Google-Sender-Auth: tvAYVJuTDV_oyt2clg9R8J-B2bM
Message-ID: <AANLkTil7QBQOsWIWQOGOaAz76eDqx9clZ1CfL2MR5484@mail.gmail.com>
Subject: Re: [PATCH UPDATED] sched: adjust when cpu_active and cpuset 
	configurations are updated during cpu on/offlining
From: Tony Luck <tony.luck@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 1:55 PM, Tejun Heo <tj@kernel.org> wrote:
> I see.  I think the right solution is removing __cpuexit but it's kind
> of silly to have different rules on different architectures.  On x86,
> __cpuexit currently means "you can drop it if you're not gonna be
> removing cpus after system boot"; IOW, __cpuexit is strict subset of
> __cpuinit.  If you define it as "don't include it in the text at all
> if cpus are not gonna be removed", it actually forces you to carry
> more text in the running system.  Is there any reason ia64 drops them
> during linking?

The history is that __exit functions are those that are called on module
unload.  When a driver is built-in to the kernel, it can obviously never
be unloaded. Therefore the __exit code must just be bloat for the built-in
case.

A system built with CONFIG_HOTPLUG_CPU=n meets the requirement
that cpus will not be removed after system boot. So why do I need to
include the __cpuexit code that should only be used to remove cpus?

-Tony
