Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505Ab0CWPIO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 11:08:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:56339 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445Ab0CWPIM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 11:08:12 -0400
Subject: Re: [PATCH] perf_events: fix bug in AMD per-cpu initialization
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo <mingo@elte.hu>, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com,
       "hpa@zytor.com" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Manfred Spraul <manfred@colorfullife.com>
In-Reply-To: <bd4cb8901003230755k41414173n302d7d626a6126b1@mail.gmail.com>
References: <4ba0a646.25e2660a.1b25.531c@mx.google.com>
	 <1268869631.9440.282.camel@laptop>
	 <bd4cb8901003171733k95fcf50mf6de78bf503d9a7b@mail.gmail.com>
	 <1269353485.5109.48.camel@twins>
	 <bd4cb8901003230755k41414173n302d7d626a6126b1@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 23 Mar 2010 16:07:48 +0100
Message-ID: <1269356868.5109.66.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-23 at 15:55 +0100, Stephane Eranian wrote:
> What's the point of CPU_ONLINE vs. CPU_STARTING if you're saying the
> former is never right? Why not move CPU_ONLINE to the right place and
> drop CPU_STARTING?

Its right for a lot of things, just not for perf, we need to be ready
and done by the time the cpu starts scheduling.

