Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161Ab0FUUOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 16:14:20 -0400
Received: from smtp-out.google.com ([216.239.44.51]:25540 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab0FUUOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 16:14:18 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=C/u1Y0hCM5rW4OHVCuT8v8tK9x/USURPQrYWErks3PCWlspLgVKxYmS761OCOIieE
	0wr0de70pwCg+5G1yhQLg==
Date: Mon, 21 Jun 2010 13:14:13 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 2/9] oom: oom_kill_process() doesn't select kthread
 child
In-Reply-To: <20100617104517.FB7D.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1006211313080.8367@chino.kir.corp.google.com>
References: <20100617104311.FB7A.A69D9226@jp.fujitsu.com> <20100617104517.FB7D.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jun 2010, KOSAKI Motohiro wrote:

> 
> Now, select_bad_process() have PF_KTHREAD check, but oom_kill_process
> doesn't. It mean oom_kill_process() may choose wrong task, especially,
> when the child are using use_mm().
> 

This type of check should be moved to badness(), it will prevent these 
types of tasks from being selected both in select_bad_process() and 
oom_kill_process() if the score it returns is 0.
