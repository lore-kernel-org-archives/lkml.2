Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab2KFQvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 11:51:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29655 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752375Ab2KFQvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 11:51:42 -0500
Date: Tue, 6 Nov 2012 13:51:19 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH v2 14/16] perf tools: add new mem command for memory
 access profiling
Message-ID: <20121106165119.GC13629@infradead.org>
References: <1352123463-7346-1-git-send-email-eranian@google.com>
 <1352123463-7346-15-git-send-email-eranian@google.com>
 <20121106154446.GA13629@infradead.org>
 <CABPqkBSh_QGrZrQgmLKavuGLz+jC4fyczLGffo6iWnpzW6BzfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBSh_QGrZrQgmLKavuGLz+jC4fyczLGffo6iWnpzW6BzfA@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Nov 06, 2012 at 04:49:26PM +0100, Stephane Eranian escreveu:
> On Tue, Nov 6, 2012 at 4:44 PM, Arnaldo Carvalho de Melo
> <acme@redhat.com> wrote:
> > Em Mon, Nov 05, 2012 at 02:51:01PM +0100, Stephane Eranian escreveu:
> >> +
> >> +     if (strcmp(mem_operation, MEM_OPERATION_LOAD))
> >> +             sprintf(event, "cpu/mem-stores/pp");
> >> +     else
> >> +             sprintf(event, "cpu/mem-loads/pp");

> > Fails for me on a Sandy Bridge notebook:

> That's because you need to update the microcode.

> $ sudo modprobe microcode
> $ cat /proc/cpuinfo
> 
> Line with microcode needs to say:
> microcode : 0x28

Here it says:

microcode	: 0x25
 
> update the microcode package or install directly from
> intel download center.

Thanks for the info, will do. And they will add "microcode hints for
selected processors should give that info to the user" to my TODO list
:-)

- Arnaldo
