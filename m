Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab1BNQOj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 11:14:39 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56940 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723Ab1BNQOg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 11:14:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Ifd4gG/90joYCPdLq3HlK16Y/m7/PasRjEEjav//vV11g7qY3byTzXiVxrtg1W9LNM
         zgswbWmDt6zl043j6Gpt25IxToN5EjynhEgsCbLX+6VCGEqLtKq1RlQZLZsp8tWgbZHV
         lOaESWvMhvYbRfyDS0WBYZ4pTdClbN0su+9JQ=
MIME-Version: 1.0
In-Reply-To: <20110214112931.GF18742@htj.dyndns.org>
References: <1297530663-26234-1-git-send-email-tj@kernel.org>
	<1297530663-26234-5-git-send-email-tj@kernel.org>
	<4D56D3C7.8050803@kernel.org>
	<20110214112931.GF18742@htj.dyndns.org>
Date: Mon, 14 Feb 2011 08:14:36 -0800
X-Google-Sender-Auth: qtaaxah0ghFDgpNjKt5lqphF0SU
Message-ID: <AANLkTi==t7SfjuLUoXmLawNL-jVqb8r3R7rOzjkjQh_Z@mail.gmail.com>
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

On Mon, Feb 14, 2011 at 3:29 AM, Tejun Heo <tj@kernel.org> wrote:
> On Sat, Feb 12, 2011 at 10:39:03AM -0800, Yinghai Lu wrote:
>> > @@ -297,7 +297,10 @@ int __init acpi_numa_init(void)
>> >     acpi_table_parse(ACPI_SIG_SLIT, acpi_parse_slit);
>> >
>> >     acpi_numa_arch_fixup();
>> > -   return ret;
>> > +
>> > +   if (cnt <= 0)
>> > +           return cnt ?: -ENOENT;
>> > +   return 0;
>> >  }
>> >
>> >  int acpi_get_pxm(acpi_handle h)
>>
>>
>> it will break AMD system that does not have SRAT.
>>
>> your change will treat NO_SRAT as SRAT is there.
>
> Can you please elaborate a bit?  Yinghai, there's brevity and there's
> being cryptic.  I appreciate your reviews but don't want to spend time
> trying to decipher what you mean.  If it doesn't hurt your fingers too
> much, please put a bit more effort into explaining.

when system have acpi support  but SRAT is NOT there,  new
acpi_numa_init() will return 0 just like SRAT is there and correct.
So it will skip AMD node scanning.

Yinghai
