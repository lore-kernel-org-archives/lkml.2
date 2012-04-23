Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094Ab2DWKhD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 06:37:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:50407 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744Ab2DWKhC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 06:37:02 -0400
Message-ID: <1335177409.28150.115.camel@twins>
Subject: Re: [PATCH 06/12] perf/x86-ibs: Precise event sampling with IBS for
 AMD CPUs
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 23 Apr 2012 12:36:49 +0200
In-Reply-To: <20120423084128.GR9747@erda.amd.com>
References: <1333390758-10893-1-git-send-email-robert.richter@amd.com>
	 <1333390758-10893-7-git-send-email-robert.richter@amd.com>
	 <1334398930.2528.50.camel@twins> <20120423084128.GR9747@erda.amd.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-23 at 10:41 +0200, Robert Richter wrote:
> On 14.04.12 12:22:10, Peter Zijlstra wrote:
> > On Mon, 2012-04-02 at 20:19 +0200, Robert Richter wrote:
> > > + * IbsOpCntCtl (bit 19) of IBS Execution Control Register (IbsOpCtl,
> > > + * MSRC001_1033) is used to select either cycle or micro-ops counting
> > > + * mode. 
> > 
> > Ah is that what it does.. the BKDG doesn't appear to say this.
> 
> "19 IbsOpCntCtl: periodic op counter count control. Revision B:
>     Reserved. Revision C: Read-write. Reset 0b. 1=Count dispatched ops
>     0=Count clock cycles."
> 
> It's here:
> 
>  MSRC001_1033 IBS Execution Control Register (IbsOpCtl)
>  http://support.amd.com/us/Processor_TechDocs/31116.pdf
> 
> Ok, it might not be quite clear that "dispatched ops" is related to
> EventSelect 0C1h Retired uops, but there is an exact mapping.

Ah, looks like my docs are stale.. my fam10 doc didn't have it specified
at all and my fam12 doc just listed the bit 19 as "periodic op counter
count control. Read-write." Which isn't very helpful.

Thanks!
