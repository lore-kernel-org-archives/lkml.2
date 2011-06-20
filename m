Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874Ab1FTVJ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 17:09:28 -0400
Received: from smtp-out.google.com ([74.125.121.67]:41843 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284Ab1FTVJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 17:09:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=HojMnPtulWXxp1HYurA1VAF3H05p2U2pHeXu7CzHEqwyYxdE9AUS0oU4wZzkUoKXyE
         eAfZE7GspcJltU4c+A7Q==
Date: Mon, 20 Jun 2011 14:09:19 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Frantisek Hrbata <fhrbata@redhat.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        CAI Qian <caiqian@redhat.com>, lwoodman@redhat.com
Subject: Re: [PATCH] oom: add uid to "Killed process" message
In-Reply-To: <1308567876-23581-1-git-send-email-fhrbata@redhat.com>
Message-ID: <alpine.DEB.2.00.1106201409090.2639@chino.kir.corp.google.com>
References: <1308567876-23581-1-git-send-email-fhrbata@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jun 2011, Frantisek Hrbata wrote:

> Add user id to the oom killer's "Killed process" message, so the user of the
> killed process can be identified.
> 

Notified in what way?  Unless you are using the memory controller, there's 
no userspace notification that an oom event has happened so nothing would 
know to scrape the kernel log for this information.

We've had a long-time desire for an oom notifier, not only at the time of 
oom but when approaching it with configurable thresholds, that would 
wakeup a userspace daemon that might be polling on notifier.  That seems 
more useful for realtime notification of an oom event rather than relying 
on the kernel log?
