Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab2FMOyX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 10:54:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42213 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338Ab2FMOyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 10:54:22 -0400
MIME-Version: 1.0
In-Reply-To: <1339592856.8980.33.camel@twins>
References: <1339502524-10265-1-git-send-email-vincent.guittot@linaro.org>
	<1339502524-10265-4-git-send-email-vincent.guittot@linaro.org>
	<1339592856.8980.33.camel@twins>
Date: Wed, 13 Jun 2012 16:54:20 +0200
Message-ID: <CAKfTPtDkRZJmfwmOeR6TPc5etbWRRneWAmN13X2_ace4wFwf7A@mail.gmail.com>
Subject: Re: [RFC 3/4] ARM: topology: Update cpu_power according to DT information
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, devicetree-discuss@lists.ozlabs.org,
        linux@arm.linux.org.uk, grant.likely@secretlab.ca,
        rob.herring@calxeda.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 June 2012 15:07, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2012-06-12 at 14:02 +0200, Vincent Guittot wrote:
>> +struct cpu_capacity cpu_capacity[NR_CPUS];
>
> I know ARM isn't likely to suffer from the 4k cpu issue, but is there a
> reason to use a NR_CPUS array over a per-cpu variable?

At this stage, we don't know which logical CPU will match which hwid.
During the boot of each CPU, we parse the table to found an efficiency
value for the booting CPU. The whole table is used by one CPU at a
time.
