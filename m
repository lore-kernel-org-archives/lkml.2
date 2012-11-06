Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab2KFH2A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 02:28:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47798 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281Ab2KFH15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 02:27:57 -0500
Message-ID: <5098BC7F.7090702@redhat.com>
Date: Tue, 06 Nov 2012 02:30:07 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: walken@google.com, akpm@linux-foundation.org, hughd@google.com,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        ralf@linux-mips.org, lethal@linux-sh.org, cmetcalf@tilera.com,
        x86@kernel.org, wli@holomorphy.com, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linux-sh@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [PATCH 15/16] mm: use vm_unmapped_area() on sparc32 architecture
References: <1352155633-8648-1-git-send-email-walken@google.com> <1352155633-8648-16-git-send-email-walken@google.com> <20121105.202501.1246122770431623794.davem@davemloft.net>
In-Reply-To: <20121105.202501.1246122770431623794.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2012 08:25 PM, David Miller wrote:
> From: Michel Lespinasse <walken@google.com>
> Date: Mon,  5 Nov 2012 14:47:12 -0800
>
>> Update the sparc32 arch_get_unmapped_area function to make use of
>> vm_unmapped_area() instead of implementing a brute force search.
>>
>> Signed-off-by: Michel Lespinasse <walken@google.com>
>
> Hmmm...
>
>> -	if (flags & MAP_SHARED)
>> -		addr = COLOUR_ALIGN(addr);
>> -	else
>> -		addr = PAGE_ALIGN(addr);
>
> What part of vm_unmapped_area() is going to duplicate this special
> aligning logic we need on sparc?
>

That would be this part:

+found:
+	/* We found a suitable gap. Clip it with the original low_limit. */
+	if (gap_start < info->low_limit)
+		gap_start = info->low_limit;
+
+	/* Adjust gap address to the desired alignment */
+	gap_start += (info->align_offset - gap_start) & info->align_mask;
+
+	VM_BUG_ON(gap_start + info->length > info->high_limit);
+	VM_BUG_ON(gap_start + info->length > gap_end);
+	return gap_start;
+}
