Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab0LUSw2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 13:52:28 -0500
Received: from canuck.infradead.org ([134.117.69.58]:37993 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab0LUSwY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 13:52:24 -0500
Subject: Re: [PATCH -tip v2 2/6] perf bts: Introduce new sub command 'perf
 bts trace'
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        2nddept-manager@sdl.hitachi.co.jp, Paul Mackerras <paulus@samba.org>
In-Reply-To: <20101221184516.GP1750@nowhere>
References: <20101221090527.8552.41486.stgit@localhost6.localdomain6>
	 <20101221090549.8552.26257.stgit@localhost6.localdomain6>
	 <20101221183131.GO1750@nowhere> <1292956832.2170.17.camel@laptop>
	 <20101221184516.GP1750@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 21 Dec 2010 19:52:26 +0100
Message-ID: <1292957546.2170.21.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-21 at 19:45 +0100, Frederic Weisbecker wrote:
> On Tue, Dec 21, 2010 at 07:40:32PM +0100, Peter Zijlstra wrote:
> > On Tue, 2010-12-21 at 19:31 +0100, Frederic Weisbecker wrote:
> > > Actually the best would be to select PERF_SAMPLE_ID in the sample_type
> > > on record and also PERF_FORMAT_ID in the read_format.
> > 
> > That would grow the data size for little gain, as long as you only
> > record BTS data into the buffer the current bits should work fine.
> 
> Indeed.
> 
> In the longer term though, I think we need a specific branch set record.
> 
> Currently for every branch pair we create a new event with all the headers,
> so the pid, time, etc... are all repeated for every entries.
> 
> We rather need a single record everytime we flush the bts buffer to the perf
> buffer.

We also don't want arch specific data interfaces, so we need to iterate
the bts buffer and copy the stuff anyway, and if you don't want the time
and pid bits don't set those PERF_SAMPLE bits.


