Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab1EFWtI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 18:49:08 -0400
Received: from smtp-out.google.com ([216.239.44.51]:34783 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab1EFWtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 18:49:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=N1CCxjzqRQ7ojMOrnE0fPyLK0d+Qa+25SVOE/bghdZ1cm8NgLf1bZwA/nuGkl3Kl2o
         Iw1YPfoWyirDpyGJ4/Hw==
Date: Fri, 6 May 2011 15:48:58 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Hillf Danton <dhillf@gmail.com>
cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Yong Zhang <yong.zhang0@gmail.com>
Subject: Re: [Question] how to detect mm leaker and kill?
In-Reply-To: <BANLkTi=S_gSvnQimgqrMmq9eWJYDCDRVmA@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1105061547150.2451@chino.kir.corp.google.com>
References: <BANLkTi=S_gSvnQimgqrMmq9eWJYDCDRVmA@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 May 2011, Hillf Danton wrote:

> Hi
> 
> In the scenario that 2GB  physical RAM is available, and there is a
> database application that eats 1.4GB RAM without leakage already
> running, another leaker who leaks 4KB an hour is also running, could
> the leaker be detected and killed in mm/oom_kill.c with default
> configure when oom happens?
> 

Yes, if you know the database application is going to use 70% of your 
system RAM and you wish to discount that from its memory use when being 
considered for oom kill, set its /proc/pid/oom_score_adj to -700.

This is only possible on 2.6.36 and later kernels when oom_score_adj was 
introduced.

If you'd like to completely disable oom killing, set 
/proc/pid/oom_score_adj to -1000.
