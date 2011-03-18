Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961Ab1CRP3o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 11:29:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:53161 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756838Ab1CRP3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 11:29:38 -0400
Date: Fri, 18 Mar 2011 16:29:36 +0100
From: Michal Hocko <mhocko@suse.cz>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: cgroup: real meaning of memory.usage_in_bytes
Message-ID: <20110318152936.GC18450@tiehlicka.suse.cz>
References: <20110318152532.GB18450@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
In-Reply-To: <20110318152532.GB18450@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri 18-03-11 16:25:32, Michal Hocko wrote:
> because since then we are charging in bulks so we can end up with
> rss+cache <= usage_in_bytes. Simple (attached) program will

And I forgot to attach the test case

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic

--n8g4imXOkfNTN/H1
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="charge_test.c"

#include <stdio.h>
#include <sys/mman.h>

#define PAGE_SIZE 4096U
int main()
{
	int ch;
	void *addr, *start;
	size_t size = 1*PAGE_SIZE;

	printf("I am %d\n", getpid());
	printf("Add me to the cgroup tasks if you want me to be per cgroup\n");
	read(0, &ch, 1);

	if ((addr = mmap(NULL, size, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANON, -1, 0)) == MAP_FAILED) {
		perror("mmap");
		return 1;
	}

	printf("Paging in %u pages\n", size/PAGE_SIZE);
	for (start = addr ; addr < start + size; addr += PAGE_SIZE) {
		*(unsigned char*)addr = 1;
	}

	printf("Press enter to finish\n");
	read(0, &ch, 1);
	return 0;
}

--n8g4imXOkfNTN/H1--
