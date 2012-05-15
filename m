Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758664Ab2EOPaI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:30:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57091 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965126Ab2EOPaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:30:05 -0400
Date: Tue, 15 May 2012 11:29:52 -0400
From: Dave Jones <davej@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Hugh Dickins <hughd@google.com>,
        Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lockdep: fix oops in processing workqueue
Message-ID: <20120515152952.GA27838@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Tejun Heo <tj@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Stephen Boyd <sboyd@codeaurora.org>,
	Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org
References: <20120508165819.GB10687@google.com>
 <alpine.LSU.2.00.1205081106160.4071@eggly.anvils>
 <1336516260.8226.61.camel@twins>
 <alpine.LSU.2.00.1205081553250.4497@eggly.anvils>
 <20120509092536.GC8585@gmail.com>
 <alpine.LSU.2.00.1205091219590.20881@eggly.anvils>
 <alpine.LSU.2.00.1205101049460.17714@eggly.anvils>
 <20120514212753.GM2366@google.com>
 <1337080288.27694.38.camel@twins>
 <20120515151048.GA6119@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120515151048.GA6119@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 08:10:48AM -0700, Tejun Heo wrote:
 > >From 4d82a1debbffec129cc387aafa8f40b7bbab3297 Mon Sep 17 00:00:00 2001
 > From: Peter Zijlstra <peterz@infradead.org>
 > Date: Tue, 15 May 2012 08:06:19 -0700
 > 
 > Under memory load, on x86_64, with lockdep enabled, the workqueue's
 > process_one_work() has been seen to oops in __lock_acquire(), barfing
 > on a 0xffffffff00000000 pointer in the lockdep_map's class_cache[].

can you elaborate what 'memory load' means here ?
I'm curious if I can add something to my fuzzing tool to shake out bugs like this.

	Dave

