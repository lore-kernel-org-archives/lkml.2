Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab2FRWEZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 18:04:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036Ab2FRWEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 18:04:24 -0400
Message-ID: <4FDFA59D.5020200@redhat.com>
Date: Mon, 18 Jun 2012 18:03:09 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Andi Kleen <andi@firstfloor.org>,
        linux-mm@kvack.org, akpm@linux-foundation.org, aarcange@redhat.com,
        peterz@infradead.org, minchan@gmail.com, kosaki.motohiro@gmail.com,
        hnaz@cmpxchg.org, mel@csn.ul.ie, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@surriel.com>
Subject: Re: [PATCH -mm 3/6] Fix the x86-64 page colouring code to take pgoff
 into account and use that code as the basis for a generic page colouring
 code.
References: <1340029878-7966-1-git-send-email-riel@redhat.com> <1340029878-7966-4-git-send-email-riel@redhat.com> <m2k3z48twb.fsf@firstfloor.org> <4FDF5B3C.1000007@redhat.com> <20120618181658.GA7190@x1.osrc.amd.com> <4FDF7B5E.301@redhat.com> <20120618203720.GA4148@liondog.tnic>
In-Reply-To: <20120618203720.GA4148@liondog.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2012 04:37 PM, Borislav Petkov wrote:

> and your patch has some new ifs in it:
>
> @@ -386,12 +398,16 @@ void validate_mm(struct mm_struct *mm)
>   	int bug = 0;
>   	int i = 0;
>   	struct vm_area_struct *tmp = mm->mmap;
> +	unsigned long highest_address = 0;
>   	while (tmp) {
>   		if (tmp->free_gap != max_free_space(&tmp->vm_rb))
>   			printk("free space %lx, correct %lx\n", tmp->free_gap, max_free_space(&tmp->vm_rb)), bug = 1;
>
> 			^^^^^^^^^^^^^^
>
> I think this if-statement is the problem. It is not present in mainline
> but this patch doesn't add it so some patch earlier than that adds it
> which is probably in your queue?

Argh! I see the problem now.

guilt-patchbomb sent everything from my second patch onwards,
not my first patch :(

Let me resend the series properly, I have 7 patches not 6.

I am having a bad email day...

-- 
All rights reversed
