Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696Ab1LSJ02 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 04:26:28 -0500
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:59300
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751034Ab1LSJ00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 04:26:26 -0500
X-SpamScore: -10
X-BigFish: VPS-10(zz9371I1432N98dKzz1202hzz8275bhz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LWG27X-01-15U-02
X-M-MSG: 
Date: Mon, 19 Dec 2011 10:26:16 +0100
From: Robert Richter <robert.richter@amd.com>
To: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "acme@redhat.com" <acme@ghostprotocols.net>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: Re: [PATCH] perf: make perf.data more self-descriptive (v8)
Message-ID: <20111219092616.GC16765@erda.amd.com>
References: <CABPqkBTR3tEGh7LymuS_JJR5SuCZfjTxZP-6qNxmZtBf0Zt9bg@mail.gmail.com>
 <20111130150829.GA15738@erda.amd.com>
 <20111130164946.GA27163@infradead.org>
 <20111201150151.GA15110@somewhere.redhat.com>
 <20111201151520.GB15738@erda.amd.com>
 <CABPqkBQwQ1gzQEfAehiLRXrO196vovNeRjS9taiM7dfk7U9egQ@mail.gmail.com>
 <20111205132340.GH15738@erda.amd.com>
 <CABPqkBTBpMao99t407Oz1cKMAVDYEsFSLUe85DYeOzxzuhZ9hg@mail.gmail.com>
 <20111206092905.GJ15738@erda.amd.com>
 <CABPqkBRbdJ0tG2+V-CvEdPnwm5YqQuv7FKrUHoTM8=wa8V=kHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CABPqkBRbdJ0tG2+V-CvEdPnwm5YqQuv7FKrUHoTM8=wa8V=kHQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.12.11 20:49:42, Stephane Eranian wrote:
> On Dec 6, 2011 10:29 AM, "Robert Richter" <robert.richter@amd.com> wrote:
> >
> > On 05.12.11 11:24:05, Stephane Eranian wrote:
> > > The one thing I realized last week, is that all that header information,
> incl.
> > > the features bits do not seem to appear in the file perf.data file when you
> > > use the perf record pipe mode. We need to fix that otherwise, if you
> > > depend on information in those bits, it won't always be present. That's
> > > a major issue.
> >
> > Yes, this is because pipes are not seakable, which is necessary to
> > write the features.

> Yes, but we should have those headers regardless. They contain very useful info
> about the measurement. The seeks should not be required. The features can be at
> the end of data. We should not have to care how the perf.data file was created
> by the time we call perf report. Something looks broken to me here.

It must not necessarilly at the end of the file. Using lseek() makes
the implementation much more easy. If you have to write data
sequentially you must store later parts temporarilly in memory until
earlier parts are complete. E.g. you write a size value of null, write
all remaining data and then seek back to size to write the actuall
size.

I aggree, having the header information (or at least parts of it) not
in the pipe stream will cause some implications, such as that the
information get lost if piping through the network to a different
system.

We would have to rewrite large portions of the code to write data
without seeks.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

