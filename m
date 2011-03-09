Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753Ab1CIOTa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 09:19:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932250Ab1CIOT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 09:19:29 -0500
Date: Wed, 9 Mar 2011 15:19:10 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu,
        linux-kernel@vger.kernel.org, phan@redhat.com
Subject: Re: [PATCH 1/2] perf,top: fix events overflow in top command
Message-ID: <20110309141910.GB1929@jolsa.brq.redhat.com>
References: <1299528821-17521-1-git-send-email-jolsa@redhat.com>
 <1299528821-17521-2-git-send-email-jolsa@redhat.com>
 <20110309135925.GA20188@ghostprotocols.net>
 <20110309140610.GB20188@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110309140610.GB20188@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 11:06:10AM -0300, Arnaldo Carvalho de Melo wrote:
> Em Wed, Mar 09, 2011 at 10:59:25AM -0300, Arnaldo Carvalho de Melo escreveu:
> > Em Mon, Mar 07, 2011 at 09:13:40PM +0100, Jiri Olsa escreveu:
> > > The snprintf function returns number of printed characters even
> > > if it cross the size parameter. So passing enough events via '-e'
> > > parameter will cause segmentation fault.
> > > 
> > > It's reproduced by following command:
> > > 
> > > perf top -e `perf list | grep Tracepoint | awk -F'[' '\
> > > {gsub(/[[:space:]]+/,"",$1);array[FNR]=$1}END{outputs=array[1];\
> > > for (i=2;i<=FNR;i++){ outputs=outputs "," array[i];};print outputs}'`
> > > 
> > > Attached patch is adding SNPRINTF macro that provides the
> > > overflow check and returns actuall number of printed characters.
> > 
> > Good catch, applying to perf/urgent.
> 
> Tried but it doesn't apply nor can I reproduce the overflow (albeit
> granted the long line of events is annoying).

patches were based on tip tree

hm, it crashes for me on tip tree,
but I haven't checked the perf/core tree..

not sure if it's any help, but while debugging I could see the sigsegv happened
when the pointer was far beyond the 160 chars buffer size,
maybe the buffer got bigger in the perf tree..

jirka

> 
> So I'm applying both patches to perf/core instead.
> 
> - Arnaldo
