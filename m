Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab0HYK1y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 06:27:54 -0400
Received: from smtp-out.google.com ([74.125.121.35]:20529 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149Ab0HYK1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 06:27:52 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=T8Z11wJ3yO0nYzhuAOploUltPZtI3Uj94ySz6bt4on4VQMzhI84tzim9tdIDDzanX
	v4HW697nxARbuR+gDN/bQ==
Date: Wed, 25 Aug 2010 03:27:45 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 2/2][BUGFIX] Revert "oom: deprecate oom_adj tunable"
In-Reply-To: <20100825184219.F3F2.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1008250326150.16411@chino.kir.corp.google.com>
References: <20100825184001.F3EF.A69D9226@jp.fujitsu.com> <20100825184219.F3F2.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Aug 2010, KOSAKI Motohiro wrote:

> oom_adj is not only used for kernel knob, but also used for
> application interface.
> Then, adding new knob is no good reason to deprecate it.
> 
> Also, after former patch, oom_score_adj can't be used for setting
> OOM_DISABLE. We need "echo -17 > /proc/<pid>/oom_adj" thing.
> 
> This reverts commit 51b1bd2ace1595b72956224deda349efa880b693.

Since I nacked the parent patch of this, I implicitly nack this one as 
well since oom_score_adj shouldn't be going anywhere.  The way to disable 
oom killing for a task via the new interface, /proc/pid/oom_score_adj, is 
by OOM_SCORE_ADJ_MIN as specified in the documentation.
