Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab1HAMcu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 08:32:50 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38996 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab1HAMco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 08:32:44 -0400
Subject: Re: [PATCH v2] oprofile, x86: Move memory allocation for ppro out
 of per cpu
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20110801070742.GA11795@erda.amd.com>
References: <4E35A14E.90702@gmail.com> <20110801070742.GA11795@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Aug 2011 14:37:11 +0200
Message-ID: <1312202231.2617.458.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-01 at 09:07 +0200, Robert Richter wrote:
> Can you please describe the root problem more precisely. Why can't you
> run it on -rt? What is broken? 

Because the allocators don't work from atomic context anymore. Now -rt
doesn't have a lot of real atomic contexts left so its usually not much
of a problem, but CPU_STARTING and actual IPIs are of course still
atomic.



