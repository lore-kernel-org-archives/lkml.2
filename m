Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759388Ab2BJR2i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 12:28:38 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60941 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab2BJR2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 12:28:36 -0500
Subject: Re: bisected: 'perf top' causing soft lockups under Xen
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Noonan <steven@uplinklabs.net>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
In-Reply-To: <CAKbGBLgVyWC3iuu8n+aQ8UhziSPnbpHVNGtQ=9m-PzvVA1kzdg@mail.gmail.com>
References: <CAKbGBLgVyWC3iuu8n+aQ8UhziSPnbpHVNGtQ=9m-PzvVA1kzdg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Feb 2012 18:28:21 +0100
Message-ID: <1328894901.25989.20.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-09 at 18:32 -0800, Steven Noonan wrote:
> [   88.517599]  [<ffffffff81085a86>] smp_call_function_single+0xec/0xfd

This looks like its waiting for an IPI to complete.. 

There's no actual BUGS or WARNs in the output, just the soft lockup
thing saying things are taking a bit of time (clearly 15s waiting for an
IPI isn't quite normal).

I've no idea why this wouldn't work on Xen, nor do the trace have any
Xen specific muck in them.

