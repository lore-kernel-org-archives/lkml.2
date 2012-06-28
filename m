Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315Ab2F1F16 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 01:27:58 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40049 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab2F1F14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 01:27:56 -0400
MIME-Version: 1.0
In-Reply-To: <4FEBE646.5090801@jp.fujitsu.com>
References: <4FEA9C88.1070800@jp.fujitsu.com> <4FEA9DB1.7010303@jp.fujitsu.com>
 <4FEAC916.7030506@cn.fujitsu.com> <4FEBE646.5090801@jp.fujitsu.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Thu, 28 Jun 2012 01:27:35 -0400
X-Google-Sender-Auth: RdKtH9WQiQdqrLqDp8BEyuEnExw
Message-ID: <CAHGf_=rzRthh+hpKWAVF9OyL+P_NhFw4y+W-tF3j0zB8pr0QjA@mail.gmail.com>
Subject: Re: [RFC PATCH 2/12] memory-hogplug : check memory offline in offline_pages
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-acpi@vger.kernel.org, len.brown@intel.com,
        benh@kernel.crashing.org, paulus@samba.org, cl@linux.com,
        minchan.kim@gmail.com, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2012 at 1:06 AM, Yasuaki Ishimatsu
<isimatu.yasuaki@jp.fujitsu.com> wrote:
> Hi Wen,
>
> 2012/06/27 17:49, Wen Congyang wrote:
>> At 06/27/2012 01:44 PM, Yasuaki Ishimatsu Wrote:
>>> When offline_pages() is called to offlined memory, the function fails since
>>> all memory has been offlined. In this case, the function should succeed.
>>> The patch adds the check function into offline_pages().
>>
>> You miss such case: some pages are online, while some pages are offline.
>> offline_pages() will fail too in such case.
>
> You are right. But current code fails, when the function is called to offline
> memory. In this case, the function should succeed. So the patch confirms
> whether the memory was offlined or not. And if memory has already been
> offlined, offline_pages return 0.

Can you please explain why the caller can't check it? I hope to avoid
an ignorance
as far as we can.
