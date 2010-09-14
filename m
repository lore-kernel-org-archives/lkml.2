Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab0INOhv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 10:37:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:58865 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149Ab0INOht convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 10:37:49 -0400
Subject: Re: [PATCH v2] sched: fix user time incorrectly accounted as
 system time on 32 bit
From: Peter Zijlstra <peterz@infradead.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>, stable@kernel.org,
        Michael Chapman <redhat-bugzilla@very.puzzling.org>,
        Ciriaco Garcia de Celis <sysman@etherpilot.com>
In-Reply-To: <20100914143513.GB8415@redhat.com>
References: <20100914143513.GB8415@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 14 Sep 2010 16:37:28 +0200
Message-ID: <1284475048.2275.517.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-14 at 16:35 +0200, Stanislaw Gruszka wrote:
> We have 32 bit variable overflow possibility when multiply in
> task_times() and thread_group_times() functions. If overflow happens
> calculated scaled utime value become wrongly small and scaled stime
> wrongly big.

Ah, right, (u64)foo * bar would have worked too I guess, but yeah, the
used (u64)(foo * bar) is wrong.

> Reported here:
> https://bugzilla.redhat.com/show_bug.cgi?id=633037
> https://bugzilla.kernel.org/show_bug.cgi?id=16559
> 
> Reported-by: Michael Chapman <redhat-bugzilla@very.puzzling.org>
> Reported-by: Ciriaco Garcia de Celis <sysman@etherpilot.com>
> Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: <stable@kernel.org>  # 2.6.32.19+ (partially) and 2.6.33+
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Thanks, got it.
