Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924Ab0KEWLx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 18:11:53 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48092 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641Ab0KEWLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 18:11:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=syecPINGN/q+ljXE8tryVzsD2EzazDqUwFnPi8j5AkAyWzvyDZLV7J6VStz+ZftcBt
         NzK1VM/ql0eB1IPuxc+d7xWloTIOts7wEAAEhvL3dKQD4+FHOvr9Lsj96qRlxVGK5F8E
         KcZwQAWzNrkopJkcQ8EWMe/EjIZl97GiqDeHk=
Subject: Re: OOM when adding ipv6 route:  How to make available more
 per-cpu memory?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: NetDev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
In-Reply-To: <1288988403.2665.268.camel@edumazet-laptop>
References: <4CD43C87.5040403@candelatech.com>
	 <1288980361.2882.1070.camel@edumazet-laptop>
	 <4CD449A5.5070305@candelatech.com>
	 <1288988403.2665.268.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Nov 2010 23:11:43 +0100
Message-ID: <1288995103.2665.653.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 05 novembre 2010 à 21:20 +0100, Eric Dumazet a écrit :
> Your vmalloc space is very fragmented. pcpu_get_vm_areas() want
> hugepages (4MB on your machine, 2MB on mine because I have
> CONFIG_HIGHMEM64G=y)

Well, this is wrong. We use normal (4KB) pages, unfortunately.

I have a NUMA machine, with two nodes, so pcpu_get_vm_areas() allocates
two zones, one for each node, with a 'known' offset between them.
Then, 4KB pages are allocated to populate the zone when needed.

# grep pcpu_get_vm_areas /proc/vmallocinfo 
0xffffe8ffa0400000-0xffffe8ffa0600000 2097152 pcpu_get_vm_areas+0x0/0x740 vmalloc
0xffffe8ffffc00000-0xffffe8ffffe00000 2097152 pcpu_get_vm_areas+0x0/0x740 vmalloc

BTW, we dont have the number of pages currently allocated in each
'vmalloc' zone, and/or node information.

Tejun, do you have plans to use hugepages eventually ?
(and fallback to 4KB pages, but most percpu data are allocated right
after boot)

Thanks


