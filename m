Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978Ab1LKM42 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 07:56:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:35677 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab1LKM41 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 07:56:27 -0500
Message-ID: <1323608131.16764.19.camel@twins>
Subject: Re: [PATCH 2/4] perf_event: add PERF_COUNT_HW_REF_CPU_CYCLES
 generic PMU event
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        acme@infradead.org, robert.richter@amd.com, ming.m.lin@intel.com,
        andi@firstfloor.org, asharma@fb.com
Date: Sun, 11 Dec 2011 13:55:31 +0100
In-Reply-To: <20111211080138.GB20790@elte.hu>
References: <1323559734-3488-1-git-send-email-eranian@google.com>
	 <1323559734-3488-3-git-send-email-eranian@google.com>
	 <20111211080138.GB20790@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-12-11 at 09:01 +0100, Ingo Molnar wrote:
> > +     PERF_COUNT_HW_REF_CPU_CYCLES            = 9,
> 
> Btw., that was what 'bus cycles' tried to do a long time ago: 
> the constant, non-variable baseline heartbeat of the system. 

This isn't about that. Its about exposing the third fixed purpose
counter. Intel, in their infinite wisdom, created a fixed purpose
counter for which there is no equivalent in the general purpose events.

Our fixed purpose counter support is predicated on the assumption that
there is, and simply maps any event code to also include the fixed
purpose counter if appropriate.

There not being an event to map from has thus far avoided exposing this
third fixed purpose event.

The problem with remapping BUS_CYCLES is that BUS_CYCLES (now) is
something you can program on the {2,4,8} general purpose counters,
whereas this new thing can only ever be ran from the 1 fixed purpose
counter.


