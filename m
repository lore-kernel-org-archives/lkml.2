Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab2LDPDi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 10:03:38 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48326 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917Ab2LDPDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 10:03:36 -0500
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 3/3] perf diff: Use internal rb tree for compute resort
References: <1354596265-9901-1-git-send-email-namhyung@kernel.org>
	<1354596265-9901-4-git-send-email-namhyung@kernel.org>
	<20121204134544.GB3159@ghostprotocols.net>
Date: Wed, 05 Dec 2012 00:03:28 +0900
In-Reply-To: <20121204134544.GB3159@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Tue, 4 Dec 2012 10:45:44 -0300")
Message-ID: <87boe9c11b.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Dec 2012 10:45:44 -0300, Arnaldo Carvalho de Melo wrote:
> Em Tue, Dec 04, 2012 at 01:44:25PM +0900, Namhyung Kim escreveu:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> There's no reason to run hists_compute_resort() using output tree.
>> Convert it to use internal tree so that it can remove unnecessary
>> _output_resort.  Also move position computation below the resort since
>> it changes the output ordering.
>
> Have you tested this with 'perf top'? With the highest frequency?

After testing 'perf top -F 100000' couple of minutes, I couldn't find
any visible problem.  Basically this patchset changes hists__link/match
path which only called from 'perf diff' - I'm working on making use of
that for event group report though.  So I didn't check perf top side
seriously.  Any reason do you mention it that I'm missing?

Thanks,
Namhyung
