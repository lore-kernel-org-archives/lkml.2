Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758174Ab2EDNif (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 09:38:35 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:41199 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756056Ab2EDNie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 09:38:34 -0400
MIME-Version: 1.0
In-Reply-To: <4FA3D2DF.9070000@intel.com>
References: <1336114210-25687-1-git-send-email-alex.shi@intel.com>
	<1336114210-25687-4-git-send-email-alex.shi@intel.com>
	<CAJd=RBDi1cJ=HmjoLdMG1hMU5GZNDV5ysXqvCT9PP09rEi342w@mail.gmail.com>
	<4FA3D2DF.9070000@intel.com>
Date: Fri, 4 May 2012 21:38:33 +0800
Message-ID: <CAJd=RBA8JSAckF0=jAdqtVCym3O1CAr97OObiqqvERQuYCgVNA@mail.gmail.com>
Subject: Re: [PATH v2 3/5] x86/tlb: fall back to flush all when meet a THP
 large page
From: Hillf Danton <dhillf@gmail.com>
To: Alex Shi <alex.shi@intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, rostedt@goodmis.org,
        fweisbec@gmail.com, bp@amd64.org, npiggin@gmail.com, jeremy@goop.org,
        riel@redhat.com, luto@mit.edu, avi@redhat.com, len.brown@intel.com,
        dhowells@redhat.com, fenghua.yu@intel.com, yinghai@kernel.org,
        borislav.petkov@amd.com, ak@linux.intel.com, cpw@sgi.com,
        steiner@sgi.com, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q44Dcex0002928

On Fri, May 4, 2012 at 9:00 PM, Alex Shi <alex.shi@intel.com> wrote:
> On 05/04/2012 08:11 PM, Hillf Danton wrote:
>
>> Hi Alex,
>>
>> Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  if (vmflag & VM_EXEC)
>> Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  tlb_entries = tlb_lli_4k[ENTRIES];
>> @@ -22,11 +23,15 @@ void flush_tlb_range(struct vm_area_stru
>> Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  act_entries = tlb_entries > mm->total_vm ?
>> Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  mm->total_vm : tlb_entries;
>>
>> - Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  if ((end - start)/PAGE_SIZE > act_entries/FLUSHALL_BAR)
>> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  pg_sz = (transparent_hugepage_enabled(vma) ||
>> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  is_vm_hugetlb_page(vma)) ?
>> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  HPAGE_SIZE : PAGE_SIZE;
>> +
>> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  if ((end - start)/pg_sz > act_entries/FLUSHALL_BAR)
>
>
> Your patch should base on the second patch that expel the HUGETLB page.
>
The diff is only for showing idea.

> But the key fact is I did not find invlpg is help on HUGETLB.

Yep, I only assume flushing huge TLB is not far from regular TLB.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
