Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab0CQN0w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 09:26:52 -0400
Received: from mga12.intel.com ([143.182.124.36]:4279 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751011Ab0CQN0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 09:26:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,657,1262592000"; 
   d="scan'208";a="255664108"
Date: Wed, 17 Mar 2010 13:01:59 +0000
From: Alan Cox <alan@linux.intel.com>
To: Simon Kagstrom <simon.kagstrom@netinsight.net>
Cc: x86@kernel.org, linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org,
       hpa@zytor.com
Subject: Re: [PATCH 1/2]: serial8250: Use native_io_delay on the x86
Message-ID: <20100317130159.23d1103f@linux.intel.com>
In-Reply-To: <20100317133050.54851ff8@marrow.netinsight.se>
References: <20100317132849.7d49939b@marrow.netinsight.se>
	<20100317133050.54851ff8@marrow.netinsight.se>
Organization: Intel
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Mar 2010 13:30:50 +0100
Simon Kagstrom <simon.kagstrom@netinsight.net> wrote:

> Port 0x80 is not safe to use on all x86 boards (see
> arch/x86/kernel/io_delay.c), so use native_io_delay instead.
> 
> Signed-off-by: Simon Kagstrom <simon.kagstrom@netinsight.net>

native_io_delay() won't work if the system is being run with no delays.
The I/O cycle isn't for the delay but to force the bus signals. So in
various modes (paravirt, udelay, no delay) the native_io_delay won't
actually do what is required.

I'm actually surprised you hit this path and if anything the right fix
is to avoid hitting this kind of probing in the first place.


