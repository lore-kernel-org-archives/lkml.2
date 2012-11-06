Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab2KFRFV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 12:05:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55220 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394Ab2KFRFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 12:05:20 -0500
Date: Tue, 6 Nov 2012 14:05:02 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH v2 14/16] perf tools: add new mem command for memory
 access profiling
Message-ID: <20121106170502.GD13629@infradead.org>
References: <1352123463-7346-1-git-send-email-eranian@google.com>
 <1352123463-7346-15-git-send-email-eranian@google.com>
 <20121106154446.GA13629@infradead.org>
 <CABPqkBSh_QGrZrQgmLKavuGLz+jC4fyczLGffo6iWnpzW6BzfA@mail.gmail.com>
 <20121106165119.GC13629@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121106165119.GC13629@infradead.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Nov 06, 2012 at 01:51:19PM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Tue, Nov 06, 2012 at 04:49:26PM +0100, Stephane Eranian escreveu:
> > On Tue, Nov 6, 2012 at 4:44 PM, Arnaldo Carvalho de Melo
> > <acme@redhat.com> wrote:
> > > Em Mon, Nov 05, 2012 at 02:51:01PM +0100, Stephane Eranian escreveu:
> > >> +             sprintf(event, "cpu/mem-loads/pp");

> > > Fails for me on a Sandy Bridge notebook:

> > That's because you need to update the microcode.
> 
> > $ sudo modprobe microcode
> > $ cat /proc/cpuinfo

> > Line with microcode needs to say:
> > microcode : 0x28

> Here it says:

> microcode	: 0x25

Updated it and now I have 0x28, better:

Samples: 8K of event 'cpu/mem-loads/pp', Event count (approx.): 89255
  0.75%  1  665  L3 hit         [.] arena_run_tree_remove
  0.67%  1  602  LFB hit        [.] nsSMILAnimationController::DoSample(bool)
  0.63%  1  563  Local RAM hit  [.] 0x00000000004620c4
  0.58%  1  515  Local RAM hit  [.] 0x00007f6b278aa7bc
  0.54%  1  479  L2 hit         [.] XPending
  0.33%  1  292  Local RAM hit  [.] nsSVGFEMorphologyElement::Filter(nsSVGFilterInstance*, nsTArray<

Will do more tests after lunch,

- Arnaldo
