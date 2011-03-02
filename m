Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412Ab1CBJix (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 04:38:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:60373 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756370Ab1CBJiw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 04:38:52 -0500
Subject: Re: [BUG] perf failed on multi-cpus system with multi-events
 specified
From: Peter Zijlstra <peterz@infradead.org>
To: Han Pingtian <phan@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <20110302035821.GA5186@hpt.nay.redhat.com>
References: <20110302035821.GA5186@hpt.nay.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 02 Mar 2011 10:38:36 +0100
Message-ID: <1299058716.2428.13473.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-02 at 11:58 +0800, Han Pingtian wrote:
>   Error: sys_perf_event_open() syscall returned with -1 (Too many open
> files).  /bin/dmesg may provide additional information.

Well, you tried to use 42 events (quick count), we need to open a fd for
each cpu for each event, which results in 1008 fds, which together with
some actual file handles might have tickled your fd limit.

