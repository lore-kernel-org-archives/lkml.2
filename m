Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473Ab0KIVGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 16:06:53 -0500
Received: from smtp-out.google.com ([216.239.44.51]:49090 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab0KIVGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 16:06:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=miViUVcyeDI2MgzHXyU6ITUaD8PsFWt8HCljJGnICcLCi0h51fUVP8dRRmSCKiyFes
         Xw2xDn9+cw1FFObipTbg==
Date: Tue, 9 Nov 2010 13:06:42 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "Figo.zhang" <zhangtianfei@leadcoretech.com>,
        figo zhang <figo1802@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH v2]oom-kill: CAP_SYS_RESOURCE should get bonus
In-Reply-To: <20101109122437.2e0d71fd@lxorguk.ukuu.org.uk>
Message-ID: <alpine.DEB.2.00.1011091300510.7730@chino.kir.corp.google.com>
References: <1288834737.2124.11.camel@myhost> <alpine.DEB.2.00.1011031847450.21550@chino.kir.corp.google.com> <20101109195726.BC9E.A69D9226@jp.fujitsu.com> <20101109122437.2e0d71fd@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Nov 2010, Alan Cox wrote:

> The reverse can be argued equally - that they can unprotect themselves if
> necessary. In fact it seems to be a "point of view" sort of question
> which way you deal with CAP_SYS_RESOURCE, and that to me argues that
> changing from old expected behaviour to a new behaviour is a regression.
> 

I didn't check earlier, but CAP_SYS_RESOURCE hasn't had a place in the oom 
killer's heuristic in over five years, so what regression are we referring 
to in this thread?  These tasks already have full control over 
oom_score_adj to modify its oom killing priority in either direction.

And, as I said, giving these threads a bonus to be less preferred doesn't 
seem appropriate since (1) it's not a defined or expected behavior of 
CAP_SYS_RESOURCE like it is for sysadmin tasks, and (2) these threads are 
not bound by resource limits and thus have a higher liklihood of consuming 
larger amounts of memory.

That's why I nack'd the patch in the first place and still do, there's no 
regression here and it's not in the best interest of freeing a large 
amount of memory which is the sole purpose of the oom killer.

Futhermore, the heuristic was entirely rewritten, but I wouldn't consider 
all the old factors such as cputime and nice level being removed as 
"regressions" since the aim was to make it more predictable and more 
likely to kill a large consumer of memory such that we don't have to kill 
more tasks in the near future.
