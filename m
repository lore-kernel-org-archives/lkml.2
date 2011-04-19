Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab1DSVWG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 17:22:06 -0400
Received: from smtp-out.google.com ([216.239.44.51]:32338 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878Ab1DSVWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 17:22:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=UXdglX8uI57g0kdfHfgStCAmnUhkr5FhjypDZo8OMINCwj+uStQNm1VloLWL5lgYaw
         Cj++cy39j/j1uO2bN8FQ==
Date: Tue, 19 Apr 2011 14:21:59 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] break out page allocation warning code
In-Reply-To: <20110419094422.9375.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1104191419470.510@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1104181321480.31186@chino.kir.corp.google.com> <1303161774.9887.346.camel@nimitz> <20110419094422.9375.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Apr 2011, KOSAKI Motohiro wrote:

> The rule is,
> 
> 1) writing comm
> 	need task_lock
> 2) read _another_ thread's comm
> 	need task_lock
> 3) read own comm
> 	no need task_lock
> 

That was true a while ago, but you now need to protect every thread's 
->comm with get_task_comm() or ensuring task_lock() is held to protect 
against /proc/pid/comm which can change other thread's ->comm.  That was 
different before when prctl(PR_SET_NAME) would only operate on current, so 
no lock was needed when reading current->comm.
