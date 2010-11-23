Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055Ab0KWLLS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 06:11:18 -0500
Received: from canuck.infradead.org ([134.117.69.58]:59782 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab0KWLLR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 06:11:17 -0500
Subject: Re: [PATCH] perf: add support for per-event sampling period or
 frequency in perf record
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, acme@redhat.com,
        paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
        perfmon2-devel@lists.sf.net, eranian@gmail.com, robert.richter@amd.com
In-Reply-To: <4ceb9b74.e6edd80a.3271.fffff742@mx.google.com>
References: <4ceb9b74.e6edd80a.3271.fffff742@mx.google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 23 Nov 2010 12:11:20 +0100
Message-ID: <1290510680.2072.390.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-23 at 11:45 +0200, Stephane Eranian wrote:
> This patch allows specifying a per event sampling period or frequency.
> Up until now, the same sampling period or frequency was applied to all
> the events specified on the command line of perf record. A sampling 
> period depends on the event, thus it is necessary to specify it per event.
> 
> With this patch, both the -F and -c options now take a comma separated
> list of values. If a value is omitted for an event, it defaults to 1000Hz
> frequency mode as before.
> 
> $ perf record -e cycles,instructions -c 100000,200000 -a -- sleep 5


I remember an email not too long ago where people proposed to change the
syntax so that:

 -e evnt1,evnt2     -- create a group containing both events
 -e evnt1 -e evnt2  -- create two separate events

It would be nice to make sure these two proposals will not interfere.

Alternatively we extend the event syntax to include the period,
something like:

  -e evnt1:period=1234


