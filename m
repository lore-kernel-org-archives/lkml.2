Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933105Ab2DKTpQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 15:45:16 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:45178 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932922Ab2DKTpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 15:45:14 -0400
Date: Wed, 11 Apr 2012 21:45:02 +0200
From: Borislav Petkov <bp@amd64.org>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@kernel.org>,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 5/5] tools: Connect to the kernel build system
Message-ID: <20120411194502.GA18114@aftab>
References: <1334162178-17152-1-git-send-email-bp@amd64.org>
 <1334162178-17152-6-git-send-email-bp@amd64.org>
 <20120411180434.GH16257@infradead.org>
 <20120411180837.GJ16257@infradead.org>
 <4F85CB23.8030305@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F85CB23.8030305@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 12:19:15PM -0600, David Ahern wrote:
> Does this sequence still work?
> 
> cd tools/perf
> make O=/tmp/pbuild
> 
> and the O= is honored?

That still works:

$ cd tools/perf/
$ mkdir /tmp/pbuild
$ make O=/tmp/pbuild
    MKDIR /tmp/pbuild/arch/x86/util
    MKDIR /tmp/pbuild/bench
    MKDIR /tmp/pbuild/util
    MKDIR /tmp/pbuild/util/ui
    MKDIR /tmp/pbuild/util/ui/browsers
PERF_VERSION = 3.4.rc2.28.g7f953

...

    CC /tmp/pbuild/util/ui/browsers/map.o
    CC /tmp/pbuild/util/ui/helpline.o
    CC /tmp/pbuild/util/ui/progress.o
    CC /tmp/pbuild/util/ui/util.o
    AR /tmp/pbuild/libperf.a
    LINK /tmp/pbuild/perf
    GEN perf-archive

$ ls -al /tmp/pbuild/*.o | wc -l
22

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
