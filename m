Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab1BRPAV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 10:00:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:56138 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528Ab1BRPAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 10:00:15 -0500
Subject: Re: [PATCH 1/3] perf events: fix WARN_ON_ONCE for 64-bit raw data,
 SW events
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <daahern@cisco.com>, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org
In-Reply-To: <20110218145348.GA302@ghostprotocols.net>
References: <1298008433-22911-1-git-send-email-daahern@cisco.com>
	 <1298008433-22911-2-git-send-email-daahern@cisco.com>
	 <1298026821.5226.642.camel@laptop> <4D5E8338.8010602@cisco.com>
	 <20110218145348.GA302@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Feb 2011 16:01:31 +0100
Message-ID: <1298041291.5226.776.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-18 at 12:53 -0200, Arnaldo Carvalho de Melo wrote:
> 
> > So size should be changed to u64 rather than modifying the
> WARN_ON_ONCE?
> 
> Yeah, I guess so, 32-bit has to die it seems, gets in the way of
> testing
> :-) 

No!

1) don't use RAW unless you have to
2) you don't have to, goto 1
3) if you do anyway, ensure its properly padded

