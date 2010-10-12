Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813Ab0JLWMd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 18:12:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:32396 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641Ab0JLWMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 18:12:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,322,1283756400"; 
   d="scan'208";a="563320420"
Date: Tue, 12 Oct 2010 15:12:30 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:irq/core] x86: Sanitize apb timer interrupt handling
Message-ID: <20101012151230.00000402@unknown>
In-Reply-To: <alpine.LFD.2.00.1010122327260.2909@localhost6.localdomain6>
References: <tip-a5ef2e70405c8a9ee380b5ff33a008c75454791f@git.kernel.org>
	<20101012142000.00001358@unknown>
	<alpine.LFD.2.00.1010122327260.2909@localhost6.localdomain6>
Organization: Intel OTC
X-Mailer: Claws Mail 3.7.4cvs1 (GTK+ 2.16.0; i586-pc-mingw32msvc)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner Tue, 12 Oct 2010 23:28:19 +0200 (CEST)
>On Tue, 12 Oct 2010, Jacob Pan wrote:
>
>> 
>> >x86: Sanitize apb timer interrupt handling
>> >
>> >Disable the interrupt in CPU_DEAD where it belongs.
>> My main concern is the performance cost. The power management code for
>> Moorestown system make use of the cpu hotplug code (disable_nonboot_cpus)
>> but much more frequently. The system low power states are call S0 idle
>> state (s0ix).
>> 
>> Leaving the irq enabled at the chip and desc level between S0ix states
>> might give some performance benefit. That was my original thought.
>> Will it cause problems?
>
>Errm. I merily moved it to the place where it should be. You do the
>disable/enable dance already today.
>
I think I only do disable/enable at the timer HW level today during cpu hp
notification, not calling disable_irq(). Am i missing something?

Thanks,

Jacob
