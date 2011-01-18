Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab1ARSF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 13:05:28 -0500
Received: from smtp-out.google.com ([74.125.121.67]:52745 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab1ARSF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 13:05:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=Is1iVrKPcDGvlAsu1oCPO25jGF+wkjeztuG6pwAC8jA9MU/QPY6VZHVW+svK+cvQmC
         macgxcJusXh8r6pmV8Qw==
MIME-Version: 1.0
Date: Tue, 18 Jan 2011 19:05:12 +0100
Message-ID: <AANLkTinVc=VRo+2=M3x5HEoF__SOJn7kBk7Ek0R94TG9@mail.gmail.com>
Subject: [BUG] perf_event: inst_retired:any_p:c=16:i=1 is not equivalent to cpu_clk_unhalted:thread_p
From: Stephane Eranian <eranian@google.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
        Lin Ming <ming.m.lin@intel.com>, Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

commit 7639dae0ca11038286bbbcda05f2bef601c1eb8d
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Tue Dec 14 21:26:40 2010 +0100

    perf, x86: Provide a PEBS capable cycle event



Even with the transformation cmask=16:invert=1, you are not quite
counting the same thing.

inst_retired:any_p:c=16:i=1  is different from cpu_clk_unhalted:thread_p

Simply because, I think, this form of inst_retired counts in HALTED state.

This automatic transformation would be "okay" in per-thread mode, but
not in system-wide mode. It should not be done under the cover. I would
rather have this option at the user level.
