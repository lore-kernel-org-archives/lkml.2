Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab2FSLdQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 07:33:16 -0400
Received: from [213.199.154.143] ([213.199.154.143]:58998 "EHLO
	db3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751511Ab2FSLdP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 07:33:15 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI9371I1432Izz1202hzz8275bh8275dhz2dh668h839hd25hf0ah)
X-WSS-ID: 0M5V41D-01-6Q7-02
X-M-MSG: 
Date: Tue, 19 Jun 2012 13:31:58 +0200
From: Robert Richter <robert.richter@amd.com>
To: Stephane Eranian <eranian@google.com>
CC: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jim Cromie <jim.cromie@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH] perf stat: Fix default logfd to use stderr
Message-ID: <20120619113158.GB1478@erda.amd.com>
References: <1317336490-19437-1-git-send-email-acme@infradead.org>
 <1317336490-19437-8-git-send-email-acme@infradead.org>
 <20120618145108.GG5046@erda.amd.com>
 <87zk80giag.fsf@sejong.aot.lge.com>
 <CABPqkBQA+CDxzp_g2Lu=Uoet5oqOq5E_1eiATGfoX=d7xEO49g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <CABPqkBQA+CDxzp_g2Lu=Uoet5oqOq5E_1eiATGfoX=d7xEO49g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.06.12 08:09:31, Stephane Eranian wrote:
> On Tue, Jun 19, 2012 at 4:13 AM, Namhyung Kim <namhyung@kernel.org> wrote:
> > Hi, Robert
> >
> > On Mon, 18 Jun 2012 16:51:08 +0200, Robert Richter wrote:
> >> On 29.09.11 18:48:01, Arnaldo Carvalho de Melo wrote:
> >>> From: Jim Cromie <jim.cromie@gmail.com>
> >>>
> >>> This perf stat option emulates valgrind's --log-fd option, allowing the
> >>> user to send perf results elsewhere, and leaving stderr for use by the
> >>> program under test.  This complements --output file option, and is
> >>> mutually exclusive with it.
> >>>
> >>>    3>results  perf stat --log-fd 3          -- $cmd
> >>>    3>>results perf stat --log-fd 3 --append -- $cmd
> >>>
> >>> The perl distro's make test.valgrind target uses valgrind's --log-fd
> >>> option, I've adapted it to invoke perf also, and tested this patch
> >>> there.
> >>>
> >>> Link: http://lkml.kernel.org/r/1315437244-3788-2-git-send-email-jim.cromie@gmail.com
> >>> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> >>> Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
> >>> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> >>
> >> With certain shell redirections this (56f3bae) fails with a log fd
> >> setup failure. Fix below.
> >>
> >
> > It looks somewhat related to Stephane's patch. Can you we check it too?
> >
> > http://lkml.indiana.edu/hypermail/linux/kernel/1205.1/04232.html

I applied the patch to my tree and this works too. Both patches
basically avoid fdopen() if a log-fd option is not given.

After reviewing the code again I noticed my code breaks the -o option.
So Stephane's patch is fine for me too, except for the fact that
--log-fd 0 is ignored. Maybe we change this by initializing output_fd
with -1 and modify the checks of output_fd?

> Yes, my patch is needed and it was posted over a month ago now.....
> Arnaldo, please apply my patch.

It is in the pull request for Ingo.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

