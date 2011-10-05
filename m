Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934796Ab1JETTb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 15:19:31 -0400
Received: from smtp-out.google.com ([74.125.121.67]:20429 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934402Ab1JETTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 15:19:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=alUqVqBFTPJSkqE2ozl9dj4PWb06/EyNeL3M85xPIE3r2HfDSSdu+sD2Hprxq52u3
	5K7oRKH+3jggK5hldM08A==
Date: Wed, 5 Oct 2011 12:19:25 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, James.Bottomley@hansenpartnership.com,
        hpa@zytor.com
Subject: Re: [RFCv3][PATCH 4/4] show page size in /proc/$pid/numa_maps
In-Reply-To: <1317804891.2473.26.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Message-ID: <alpine.DEB.2.00.1110051213280.23587@chino.kir.corp.google.com>
References: <20111001000856.DD623081@kernel> <20111001000900.BD9248B8@kernel> <alpine.DEB.2.00.1110042344250.16359@chino.kir.corp.google.com> <1317798564.3099.12.camel@edumazet-laptop> <alpine.DEB.2.00.1110050012490.18906@chino.kir.corp.google.com>
 <1317804891.2473.26.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Oct 2011, Eric Dumazet wrote:

> > Why on earth do we want to convert a byte value into a string so a script 
> > can convert it the other way around?  Do you have a hard time parsing 
> > 4096, 2097152, and 1073741824 to be 4K, 2M, and 1G respectively?  
> 
> Yes I do. I dont have in my head all possible 2^X values, but K, M, G,
> T : thats ok (less neurons needed)
> 
> You focus on current x86_64 hardware.
> 
> Some arches have lot of different choices. (powerpc has 64K, 16M, 16GB
> pages)
> 
> In 10 years, you'll have pagesize=549755813888, or maybe
> pagesize=8589934592
> 
> I pretty much prefer pagesize=512GB and pagesize=8TB
> 
> This is consistent with usual conventions and practice.
> 

I'm indifferent whether it's displayed in bytes (so a script could do 
pagesize * anon, for example, and find the exact amount of anonymous 
memory for that vma without needing smaps) or in KB like /proc/pid/smaps, 
grep Hugepagesize /proc/meminfo, and ls /sys/kernel/mm/hugepages.

In other words, pagesize= in /proc/pid/numa_maps is the least of your 
worries if you're serious about this: you would have already struggled 
with smaps, meminfo, and the sysfs interface for reserving the hugepages 
in the first place.
