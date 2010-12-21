Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746Ab0LUSpZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 13:45:25 -0500
Received: from mail-fx0-f66.google.com ([209.85.161.66]:47061 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab0LUSpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 13:45:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vyb+mE98vJdv/zof6jCCigJN/qPwa6i1L9UVuBIwrkMJgEUwZuGcA/wJKLZ2nkcrsB
         zyW82zAtXItpMA0tQr1lrae/6DK2QykvBa6I/0ugVVhRlvZfu4i92jCoEtoFw4DNMFjQ
         RCGndkfWvHCcH/hATEQW2aBg+rL391VDjzhuc=
Date: Tue, 21 Dec 2010 19:45:18 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        2nddept-manager@sdl.hitachi.co.jp, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH -tip v2 2/6] perf bts: Introduce new sub command 'perf
 bts trace'
Message-ID: <20101221184516.GP1750@nowhere>
References: <20101221090527.8552.41486.stgit@localhost6.localdomain6>
 <20101221090549.8552.26257.stgit@localhost6.localdomain6>
 <20101221183131.GO1750@nowhere>
 <1292956832.2170.17.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292956832.2170.17.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 07:40:32PM +0100, Peter Zijlstra wrote:
> On Tue, 2010-12-21 at 19:31 +0100, Frederic Weisbecker wrote:
> > Actually the best would be to select PERF_SAMPLE_ID in the sample_type
> > on record and also PERF_FORMAT_ID in the read_format.
> 
> That would grow the data size for little gain, as long as you only
> record BTS data into the buffer the current bits should work fine.

Indeed.

In the longer term though, I think we need a specific branch set record.

Currently for every branch pair we create a new event with all the headers,
so the pid, time, etc... are all repeated for every entries.

We rather need a single record everytime we flush the bts buffer to the perf
buffer.
