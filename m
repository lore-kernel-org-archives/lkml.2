Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab1HIQDs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 12:03:48 -0400
Received: from smtp-out.google.com ([74.125.121.67]:58331 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439Ab1HIQDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 12:03:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:
	content-id:x-system-of-record;
	b=qWZeLFtV/lPcF5/ElhR8bQdWqhhg+Wz9zEspN9xNKnJPCot/YNVMjYsnvVdKs9cfA
	HMIPHuBRJ0ZTVQY7X3+wA==
Date: Tue, 9 Aug 2011 09:03:39 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mahmood Naderan <nt_mahmood@yahoo.com>
cc: Randy Dunlap <rdunlap@xenotime.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: running of out memory => kernel crash
In-Reply-To: <1312874259.89770.YahooMailNeo@web111704.mail.gq1.yahoo.com>
Message-ID: <alpine.DEB.2.00.1108090900170.30199@chino.kir.corp.google.com>
References: <1312872786.70934.YahooMailNeo@web111712.mail.gq1.yahoo.com> <1db776d865939be598cdb80054cf5d93.squirrel@xenotime.net> <1312874259.89770.YahooMailNeo@web111704.mail.gq1.yahoo.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="397155492-1484682820-1312905696=:30199"
Content-ID: <alpine.DEB.2.00.1108090901410.30199@chino.kir.corp.google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--397155492-1484682820-1312905696=:30199
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.2.00.1108090901411.30199@chino.kir.corp.google.com>

On Tue, 9 Aug 2011, Mahmood Naderan wrote:

> >Do you have any kernel log panic/oops/Bug messages?
>  
> Actually, that happened for one my diskless nodes 10 days ago.
> What I saw on the screen (not the logs), was 
> "running out of memory.... kernel panic....."
> 

The only similar message in the kernel is "Out of memory and no killable 
processes..." and that panics the machine when there are no eligible 
tasks to kill.

If you're using cpusets or mempolicies, you must ensure that all tasks 
attached to either of them are not set to OOM_DISABLE.  It seems unlikely 
that you're using those, so it seems like a system-wide oom condition.  Do 
cat /proc/*/oom_score and make sure at least some threads have a non-zero 
badness score.  Otherwise, you'll need to adjust their 
/proc/pid/oom_score_adj settings to not be -1000.

Randy also added linux-mm@kvack.org to the cc, but you removed it; please 
don't do that.
--397155492-1484682820-1312905696=:30199--
