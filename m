Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599Ab0K3UFp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 15:05:45 -0500
Received: from smtp-out.google.com ([216.239.44.51]:47806 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117Ab0K3UFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 15:05:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=fGRMs5n9EVrpF8k7G2oq2x7mEJAW/dSkQlLbdpyQdxLE0VuZe6oGdupWpEDF2TH8/d
         wCXjp/Hc19bFrtysScfw==
Date: Tue, 30 Nov 2010 12:05:17 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: "Figo.zhang" <figo1802@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@osdl.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2]mm/oom-kill: direct hardware access processes should
 get bonus
In-Reply-To: <20101130220107.8328.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1011301204010.12979@chino.kir.corp.google.com>
References: <20101123154843.7B8D.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1011271733460.3764@chino.kir.corp.google.com> <20101130220107.8328.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Nov 2010, KOSAKI Motohiro wrote:

> > I needed a small bias for CAP_SYS_ADMIN tasks so I chose 3% since it's the 
> > same proportion used elsewhere in the kernel and works nicely since the 
> > badness score is now a proportion.  
> 
> Why? Is this important than X?
> 

We have always preferred to break ties between applications by not 
preferring the root task over the user task in the oom killer.  If you'd 
like to remove this bonus for CAP_SYS_ADMIN, please propose a patch.  
Thanks!
