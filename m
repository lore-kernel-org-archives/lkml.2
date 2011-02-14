Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696Ab1BNSAR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 13:00:17 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54190 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab1BNSAQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 13:00:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=gdgb8EE8AqImQjSS+q96iIUiaGvTVK6F3n806VY9trMg8kA4c26eu7pX3gVLO2SD2I
         lhLLlEN38zUtobzs3t5f0nA0LqKR7wd8uxz/LpRmcijSx966+AfDNDRzU0NigOBvcSdW
         t8kght2vA2vTmX8x7b/pjn0NSWdHsEPtx7tig=
MIME-Version: 1.0
In-Reply-To: <20110214161857.GW18742@htj.dyndns.org>
References: <1297530663-26234-1-git-send-email-tj@kernel.org>
	<1297530663-26234-5-git-send-email-tj@kernel.org>
	<4D56D3C7.8050803@kernel.org>
	<20110214112931.GF18742@htj.dyndns.org>
	<AANLkTi==t7SfjuLUoXmLawNL-jVqb8r3R7rOzjkjQh_Z@mail.gmail.com>
	<20110214161857.GW18742@htj.dyndns.org>
Date: Mon, 14 Feb 2011 10:00:15 -0800
X-Google-Sender-Auth: SSnytNxbRaX17St19Z82oe_TZ7o
Message-ID: <AANLkTin6b=7u3FHawefm8dCLzm4OmY83t=m58L4krUzF@mail.gmail.com>
Subject: Re: [PATCH 04/26] x86-64, NUMA: Unify {acpi|amd}_{numa_init|scan_nodes}()
 arguments and return values
From: Yinghai Lu <yinghai@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, brgerst@gmail.com,
        gorcunov@gmail.com, shaohui.zheng@intel.com, rientjes@google.com,
        mingo@elte.hu, hpa@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 8:18 AM, Tejun Heo <tj@kernel.org> wrote:
> On Mon, Feb 14, 2011 at 08:14:36AM -0800, Yinghai Lu wrote:
>> when system have acpi support  but SRAT is NOT there,  new
>> acpi_numa_init() will return 0 just like SRAT is there and correct.
>> So it will skip AMD node scanning.
>
> How does it return 0?
>
> ...
>                cnt = acpi_table_parse_srat(ACPI_SRAT_TYPE_MEMORY_AFFINITY,
>                                            acpi_parse_memory_affinity,
>                                            NR_NODE_MEMBLKS);
> If there's no srat, cnt is zero.
>        }
>
>        /* SLIT: System Locality Information Table */
>        acpi_table_parse(ACPI_SIG_SLIT, acpi_parse_slit);
>
>        acpi_numa_arch_fixup();
>
>        if (cnt <= 0)
> if cnt is zero, the if is taken
>                return cnt ?: -ENOENT;
> and as cnt is zero, -ENOENT is returned.
>        return 0;
> The function returns 0 iff cnt > 0.

oh, I missed it again.

Yinghai
