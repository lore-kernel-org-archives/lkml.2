Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865Ab0DFVRu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 17:17:50 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60880
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756702Ab0DFVRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 17:17:43 -0400
Date: Tue, 06 Apr 2010 14:17:44 -0700 (PDT)
Message-Id: <20100406.141744.17264255.davem@davemloft.net>
To: rostedt@goodmis.org
Cc: srostedt@redhat.com, fweisbec@gmail.com, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, acme@redhat.com,
       a.p.zijlstra@chello.nl, paulus@samba.org
Subject: Re: Random scheduler/unaligned accesses crashes with perf lock
 events on sparc 64
From: David Miller <davem@davemloft.net>
In-Reply-To: <1270577758.19685.15557.camel@gandalf.stny.rr.com>
References: <1270561264.2738.8.camel@localhost.localdomain>
	<20100406.104635.210218044.davem@davemloft.net>
	<1270577758.19685.15557.camel@gandalf.stny.rr.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>
Date: Tue, 06 Apr 2010 14:15:58 -0400

> On Tue, 2010-04-06 at 10:46 -0700, David Miller wrote:
>> Just fix the CPP test to handle 32-bit platforms with slow
>> mis-alignment handling, everything else seems to be working properly
>> after I fixed the NMI issues on sparc64.
> 
> A little more work will need to be done since on 32bit, the page headers
> are 12 bytes, not 16, so we start off without being aligned 8bytes. But
> that too is fixable.

Oh yeah the buffer_data_page, good point.
