Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852Ab0KZVyh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 16:54:37 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49064 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab0KZVyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 16:54:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=J1TqikQQfmbTELQIuPLeZ81Z6e8rlN13BtTC+PFVsNJykQjnnHgJ7ivuDW36so/XSM
         uZxk9fBKLfLFG4WkCmaAfoDH+t+13rq0ENXN3Lk/R7rvaMYvvscFgYdvYGAqkp8AKi1x
         5B5jdBgvh2U+HBOenRPufZADi5mcKulA9mFXc=
Date: Fri, 26 Nov 2010 19:54:30 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ian Munsie <imunsie@au1.ibm.com>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/6] perf: Add timestamp to COMM and MMAP events
Message-ID: <20101126215430.GA23996@ghostprotocols.net>
References: <1290490544-14349-1-git-send-email-imunsie@au1.ibm.com>
 <1290490544-14349-4-git-send-email-imunsie@au1.ibm.com>
 <1290510512.2072.387.camel@laptop>
 <20101123124121.GA11101@ghostprotocols.net>
 <20101125154718.GE15875@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101125154718.GE15875@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Nov 25, 2010 at 01:47:18PM -0200, Arnaldo Carvalho de Melo escreveu:
> Em Tue, Nov 23, 2010 at 10:41:21AM -0200, Arnaldo Carvalho de Melo escreveu:
> > Em Tue, Nov 23, 2010 at 12:08:32PM +0100, Peter Zijlstra escreveu:
> > > Right, so acme had a patch adding:
> > > PERF_SAMPLE_{TID,TIME,ID,CPU,STREAM_ID}

> I know of a problem with unconditionally stting attr->sample_type_all
> and then trying the new perf tool on an older kernel, that will fail
> with:
> [root@felicio ~]# perf record -a -g
>   Error: sys_perf_event_open() syscall returned with -1 (Invalid
> argument).  /bin/dmesg may provide additional information.
>   Fatal: No CONFIG_PERF_EVENTS=y kernel support configured?
> 
> Because it doesn't expects that extra bit to be set. I'll use that to
> make sure the binary works on older kernels without this feature.

This got fixed.

http://git.kernel.org/?p=linux/kernel/git/acme/linux-2.6.git;a=shortlog;h=refs/heads/perf/sample_id_all.v1

Has the latest, that I was about to submit but I'll change it so that
older perf tools can cope with newer perf.data files, by stashing the
new fields after the existing layout, not between perf_event_header and
the mmap/fork/comm/etc specific stuff.

I'll rework that, test newer perf.data files with older perf tools and
then submit.

Thanks,

- Arnaldo
