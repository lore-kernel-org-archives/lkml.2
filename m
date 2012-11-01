Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336Ab2KAXV7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 19:21:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565Ab2KAXV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 19:21:57 -0400
Date: Fri, 2 Nov 2012 00:20:56 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 00/25] perf test: Add perf_event_attr tests
Message-ID: <20121101232055.GA1690@krava.redhat.com>
References: <1351634526-1516-1-git-send-email-jolsa@redhat.com>
 <20121101203800.GA3911@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121101203800.GA3911@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2012 at 05:38:01PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Tue, Oct 30, 2012 at 11:01:41PM +0100, Jiri Olsa escreveu:
> > hi,
> > this code tests the link between perf stat/record command line
> > options and final perf_event_attr struct values. Also it tests
> > the group fd linkage.
> > 
> > Plus moving test related objects under 'test' directory.
> 
> Ok, so I applied this to my local perf/core branch with a few changes,
> namely to move 24/25 to after 5/25 so that I could do, for each
> subsequent tests:
> 
> $ make -j8 -C tools/perf/ O=/home/acme/git/build/perf install
> $ perf test -v perf_event_attr
> 
> And see if each one passed.
> 
> So at the end I changed
> /home/acme/libexec/perf-core/tests/attr/base-record flipping
> "watermark=0" to "watermark=1" and got:
> 
> [root@sandy ~]# perf test perf_event_attr
> 13: struct perf_event_attr setup                           :FAILED '/home/acme/libexec/perf-core/tests/attr/test-record-count' - match failure
>  FAILED!
> [root@sandy ~]#
> 
> But I wanted it to show _what_ didn't match, so I tried:
> 
> [root@sandy ~]# perf test -v perf_event_attr
> 13: struct perf_event_attr setup                           :
> --- start ---
> running '/home/acme/libexec/perf-core/tests/attr/test-record-count'
> FAILED '/home/acme/libexec/perf-core/tests/attr/test-record-count' - match failure
> ---- end ----
> struct perf_event_attr setup: FAILED!
> [root@sandy ~]#

yep, you'd need to run:
  python ./tests/attr.py -d ./tests/attr/ -p ./perf -t test-record-count -vvv

to see what really did not match

'perf test attr' takes just single -v option into account

could be changed ;)

> 
> Also is there a strict need for setting PERF_TEST_ATTR? I thought that if it
> found the /home/acme/libexec/perf-core/tests/attr/ dirs it would test it, but
> haven't dug deep, care to ellaborate here?

PERF_TEST_ATTR instructs perf to store each event details into PERF_TEST_ATTR directory

and python script is running 'PERF_TEST_ATTR=/tmp/temp perf ...' to get events


> 
> Ah, I just pushed perf/core with this patchset, thanks!

thanks,
jirka
