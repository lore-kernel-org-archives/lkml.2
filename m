Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536Ab1KWP5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 10:57:39 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56933 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248Ab1KWP5i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 10:57:38 -0500
Message-ID: <1322063851.14799.77.camel@twins>
Subject: Re: HW perf initialisation as early_initcall
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Wed, 23 Nov 2011 16:57:31 +0100
In-Reply-To: <20111123153016.GQ25848@mudshark.cambridge.arm.com>
References: <20111123145658.GM25848@mudshark.cambridge.arm.com>
	 <1322060889.14799.73.camel@twins>
	 <20111123153016.GQ25848@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-23 at 15:30 +0000, Will Deacon wrote:
> We don't use this on ARM so I'm not familiar with it.
> 
NMI watchdog is basically a perf counter that fires every few seconds
and checks if the system is still making progress (much like the regular
soft watchdog stuff we have). If it thinks we're stuck it prints stack
traces to the console etc..

Handy for if you do dumb stuff like:

  local_irq_disable();
  while (1)
    ;

Which oddly enough seems to happen way too often ;-)

Anyway, it all depends on having NMIs in the first place.
