Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539Ab2EaObZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 10:31:25 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:58157 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505Ab2EaObY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 10:31:24 -0400
Date: Thu, 31 May 2012 11:31:16 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Sunjin Yang <fan4326@gmail.com>,
        Arun Sharma <asharma@fb.com>
Subject: Re: [PATCH/RFC 2/2] perf tools: Check callchain is corrupted
Message-ID: <20120531143116.GC13591@infradead.org>
References: <1338443007-24857-1-git-send-email-namhyung.kim@lge.com>
 <1338443007-24857-2-git-send-email-namhyung.kim@lge.com>
 <20120531134557.GB13591@infradead.org>
 <1338473077.1484.8.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1338473077.1484.8.camel@leonhard>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, May 31, 2012 at 11:04:37PM +0900, Namhyung Kim escreveu:
> 2012-05-31 (목), 10:45 -0300, Arnaldo Carvalho de Melo:
> > Em Thu, May 31, 2012 at 02:43:27PM +0900, Namhyung Kim escreveu:
> > > We faced segmentation fault on perf top -G at very high sampling
> > > rate due to a corrupted callchain. While the root cause was not
> > > revealed (I failed to figure it out), this patch tries to protect
> > > us from the segfault on such cases.

> > Capping the callchain lenght may even be a feature, not a consistency
> > check, but I don't know how long, for consistency checking, we should
> > consider too much, as there are cases of loooong callchains.

> Maybe we should consider applying (a part of, at least) Arun's multiple
> stack patchset. Also note that Linus complained about the current stack
> depth (255) is too long.

>   https://lkml.org/lkml/2012/4/20/497

Ok, I applied it, 'perf top -G -F 100000' now is holding up, no
segfaults, yay!

Thanks,

- Arnaldo
