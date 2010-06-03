Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959Ab0FCMkY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 08:40:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:35140 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab0FCMkX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 08:40:23 -0400
Subject: Re: [GIT PULL] perf crash fix
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@google.com>
In-Reply-To: <20100603123543.GA5234@nowhere>
References: <1275534810-1837-1-git-send-regression-fweisbec@gmail.com>
	 <1275552159.27810.34944.camel@twins>  <20100603123543.GA5234@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 03 Jun 2010 14:40:31 +0200
Message-ID: <1275568831.27810.35654.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-03 at 14:35 +0200, Frederic Weisbecker wrote:

> I wanted to, but I thought we could avoid two indirect calls on each
> ticks and I was also afraid of breaking start/stop original semantics,
> more especially the role of perf_event_stop/start

Right, so you lost the fallback to ->enable/->disable, which would break
hardware PMU implementations that didn't actually implement
->start/->stop (pretty much all of them except x86).
