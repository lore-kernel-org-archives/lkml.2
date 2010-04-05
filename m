Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536Ab0DEQH7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 12:07:59 -0400
Received: from mga12.intel.com ([143.182.124.36]:2485 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755110Ab0DEQHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 12:07:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,366,1267430400"; 
   d="scan'208";a="262172153"
Message-ID: <4BBA0AC5.1080905@linux.intel.com>
Date: Mon, 05 Apr 2010 09:07:33 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Dominik Brodowski <linux@dominikbrodowski.net>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Dmitry Torokhov <dtor@mail.ru>
Subject: Re: A few questions and issues with dynticks, NOHZ and powertop
References: <20100403223328.GA4507@comet.dominikbrodowski.net> <Pine.LNX.4.44L0.1004041110010.2750-100000@netrider.rowland.org> <20100404163924.GA18428@comet.dominikbrodowski.net> <20100404204725.GC2644@linux.vnet.ibm.com> <20100404233702.GA24102@linux.vnet.ibm.com> <4BB95C85.80205@linux.intel.com> <20100405042222.GD2644@linux.vnet.ibm.com> <4BB9F657.4050901@linux.intel.com> <20100405151401.GA2525@linux.vnet.ibm.com>
In-Reply-To: <20100405151401.GA2525@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/5/2010 8:14, Paul E. McKenney wrote:
> So the main issue is that for many workloads, it is best to run full bore
> and get done quickly, thus allowing the entire machine to be powered down?

yep

>
> If so, it seems likely that there would be some workloads that were sometimes
> unable to use all the CPUs, in which case shutting down (idling, offlining,
> dyntick-idling, whatever) the excess CPUs might nevertheless be the right
> thing to do.

but the point is that the normal scheduler + idle behavior gives you exactly that
in a natural way !
If you don't have enough work (tasks) to keep all cores busy, the others are and stay idle.
