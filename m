Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202Ab2DXR6V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 13:58:21 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:38944
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756742Ab2DXR6T convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 13:58:19 -0400
X-SpamScore: -9
X-BigFish: VPS-9(zzc89bh1432N98dKzz1202hzz8275bhz2dh668h839h93fhd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M2ZWKS-02-IP6-02
X-M-MSG: 
Date: Tue, 24 Apr 2012 19:58:04 +0200
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] perf tools: Fix include header files in
 util/parse-events.h
Message-ID: <20120424175804.GJ9747@erda.amd.com>
References: <1333643188-26895-1-git-send-email-robert.richter@amd.com>
 <1333643188-26895-2-git-send-email-robert.richter@amd.com>
 <20120424165344.GH9747@erda.amd.com>
 <20120424173555.GD28056@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20120424173555.GD28056@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.04.12 14:35:55, Arnaldo Carvalho de Melo wrote:
> Em Tue, Apr 24, 2012 at 06:53:44PM +0200, Robert Richter escreveu:
> > On 05.04.12 18:26:25, Robert Richter wrote:
> > > Include header fixes for
> > > 
> > > ... bool:
> > > 
> > >  util/parse-events.h:31: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘have_tracepoints’
> > > 
> > > ... and types.h:
> > > 
> > >  util/parse-events.h:28: error: expected ‘)’ before ‘config’
> > >  util/parse-events.h:34: error: expected declaration specifiers or ‘...’ before ‘u64’
> > >  util/parse-events.h:45: error: expected ‘)’ before ‘type’
> > > 
> > > This happens if now other include files are included before
> > > util/parse-events.h.
> > > 
> > > Signed-off-by: Robert Richter <robert.richter@amd.com>
> > 
> > Arnaldo,
> > 
> > is it your intention that you didn't apply this patch?
> 
> Is this on perf/urgent or perf/core? In what system does this happen?

Neither, I stumbled over this while working on a modified version of
perf tools. The interface definition of util/parse-events.h contains
type bool and u64, but both are not defined. Thus, including
parse-events.h independently of other header files will raise this
compile errors. It took me some time to figure out what happened so I
think it is worth fixing it.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

