Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab1HKHNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 03:13:18 -0400
Received: from smtp-out.google.com ([216.239.44.51]:4168 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395Ab1HKHNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 03:13:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=Gi2UG6k5HbghqSYQcDSRrlQxfgw9RVdpxBUdGzq8ZDfiVVXi4KZsG3uVtm0FYtq9y
	FdwqoTwWC53DqChqIAXFg==
Date: Thu, 11 Aug 2011 00:13:10 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mahmood Naderan <nt_mahmood@yahoo.com>
cc: Randy Dunlap <rdunlap@xenotime.net>,
        "\"\"linux-kernel@vger.kernel.org\"\"" <linux-kernel@vger.kernel.org>,
        "\"linux-mm@kvack.org\"" <linux-mm@kvack.org>
Subject: Re: running of out memory => kernel crash
In-Reply-To: <1313046422.18195.YahooMailNeo@web111711.mail.gq1.yahoo.com>
Message-ID: <alpine.DEB.2.00.1108110010220.23622@chino.kir.corp.google.com>
References: <1312872786.70934.YahooMailNeo@web111712.mail.gq1.yahoo.com> <1db776d865939be598cdb80054cf5d93.squirrel@xenotime.net> <1312874259.89770.YahooMailNeo@web111704.mail.gq1.yahoo.com> <alpine.DEB.2.00.1108090900170.30199@chino.kir.corp.google.com>
 <1312964098.7449.YahooMailNeo@web111712.mail.gq1.yahoo.com> <alpine.DEB.2.00.1108102106410.14230@chino.kir.corp.google.com> <1313046422.18195.YahooMailNeo@web111711.mail.gq1.yahoo.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="397155492-1080208226-1313046791=:23622"
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--397155492-1080208226-1313046791=:23622
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Thu, 11 Aug 2011, Mahmood Naderan wrote:

> >The default behavior is to kill all eligible and unkillable threads until 
> >there are none left to sacrifice (i.e. all kthreads and OOM_DISABLE).
>  
> In a simple test with virtualbox, I reduced the amount of ram to 300MB. 
> Then I ran "swapoff -a" and opened some applications. I noticed that the free
> spaces is kept around 2-3MB and "kswapd" is running. Also I saw that disk
> activity was very high. 
> That mean although "swap" partition is turned off, "kswapd" was trying to do
> something. I wonder how that behavior can be explained?
> 

Despite it's name, kswapd is still active, it's trying to reclaim memory 
to prevent having to kill a process as the last resort.

If /proc/sys/vm/panic_on_oom is not set, as previously mentioned, then 
we'll need the kernel log to diagnose this further.
--397155492-1080208226-1313046791=:23622--
