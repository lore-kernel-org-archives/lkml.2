Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758615Ab0LMRvn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 12:51:43 -0500
Received: from casper.infradead.org ([85.118.1.10]:46764 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758558Ab0LMRvm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 12:51:42 -0500
Subject: Re: [PATCH 1/2] perf tools: Add reference timestamp to perf header
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        "David S. Ahern" <daahern@cisco.com>, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101213174330.GC7417@ghostprotocols.net>
References: <20101212201613.GA1784@nowhere> <4D06301C.2090309@cisco.com>
	 <20101213155451.GA1691@nowhere> <20101213164854.GL5407@ghostprotocols.net>
	 <20101213170923.GB1691@nowhere> <1292260289.6803.297.camel@twins>
	 <20101213171537.GC1691@nowhere> <1292260699.6803.305.camel@twins>
	 <20101213172216.GB7417@ghostprotocols.net>
	 <1292261716.6803.332.camel@twins>
	 <20101213174330.GC7417@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 13 Dec 2010 18:51:13 +0100
Message-ID: <1292262673.6803.359.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-13 at 15:43 -0200, Arnaldo Carvalho de Melo wrote:
> Whatever, never introduced one, they are inserted, IIRC, in the
> beggining of the stream, so I guess we can just do that sed and call
> them headers and be done with it. 

There's the flush thing from Frederic, that's all over the place.

The easiest way to kill that is to go to separate data files now.
writing to different files is better for contention anyway, we can grow
a flusher-thread per buffer and let them write to their own file.


