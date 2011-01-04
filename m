Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751174Ab1ADNoh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 08:44:37 -0500
Received: from canuck.infradead.org ([134.117.69.58]:54750 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab1ADNog convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 08:44:36 -0500
Subject: Re: [PATCH 4/7] perf: Check if HT is supported and enabled
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Lin Ming <ming.m.lin@intel.com>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTinGmgB7YhRjnsGMjj2knDuJ8XFps9oyW4+EGOr5@mail.gmail.com>
References: <1293464211.2695.104.camel@localhost>
	 <AANLkTimp9VgD4qhOVmq-k1Ckzti9eeV8pf6Jvt5YB6nx@mail.gmail.com>
	 <1293526288.2457.4.camel@minggr.sh.intel.com>
	 <1294052312.2016.50.camel@laptop> <4D222926.9010206@zytor.com>
	 <1294139419.2016.115.camel@laptop>
	 <AANLkTinGmgB7YhRjnsGMjj2knDuJ8XFps9oyW4+EGOr5@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 04 Jan 2011 14:44:35 +0100
Message-ID: <1294148675.2016.139.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-04 at 14:38 +0100, Stephane Eranian wrote:
> My solution at the time (2.6.30) was to do:
>         ht_enabled = cpumask_weight(__get_cpu_var(cpu_sibling_map)) > 1;

Won't that report a machine a HT disabled when you offline a sibling?
Which kinda defeats the purpose of our usage here, since we need to know
it before either sibling comes online.
