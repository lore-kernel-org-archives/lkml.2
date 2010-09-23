Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab0IWIxP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 04:53:15 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:45845 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab0IWIxN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 04:53:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DAGatPJe2cLaQepDs7hW9NZ5V2SW4JN1g+HSWldHRutQVBVtl8nzMpIky6JB0tb3rH
         EUXxVr39zAD6/aPx1UquWBLoNHg8QDJvSxboNK414bC4faRlHYjMYxD6BwqyPITH6IZ4
         Mrk/dBLGaJ3DxosAv8/5fqVufTP3H0GoiZ0l8=
MIME-Version: 1.0
In-Reply-To: <20100921124552.GD18991@one.firstfloor.org>
References: <1284865235-29920-1-git-send-email-ying.huang@intel.com>
	<1284865235-29920-5-git-send-email-ying.huang@intel.com>
	<20100921124552.GD18991@one.firstfloor.org>
Date: Thu, 23 Sep 2010 16:53:11 +0800
Message-ID: <AANLkTinkmCJpyj2j2yi3Lj9h2q0mFcWbS4y=AKxerYkz@mail.gmail.com>
Subject: Re: [PATCH 4/5] ACPI, APEI, Fix error path for memory allocation
From: huang ying <huang.ying.caritas@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Huang Ying <ying.huang@intel.com>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andi,

On Tue, Sep 21, 2010 at 8:45 PM, Andi Kleen <andi@firstfloor.org> wrote:
> On Sun, Sep 19, 2010 at 11:00:34AM +0800, Huang Ying wrote:
>> @@ -475,7 +479,13 @@ int apei_resources_request(struct apei_resources *resources,
>>               }
>>       }
>>
>> -     apei_resources_merge(&apei_resources_all, resources);
>> +     rc = apei_resources_merge(&apei_resources_all, resources);
>> +     if (rc) {
>> +             pr_err(APEI_PFX
>> +"Error in APEI internal resource management, there may be inconsistent "
>> +"between APEI internal and system resource management.");
>
> Please fix the English. This will wrap in the syslog without \ns no?
> Kernel messges should be not wider than 80 characters.
>
>> +     rc = apei_resources_sub(&apei_resources_all, resources);
>> +     if (rc)
>> +             pr_err(APEI_PFX
>> +"Error in APEI internal resource management, there may be inconsistent "
>> +"between APEI internal and system resource management.");
>
> Same.
>
> Also instead of Error it would be better just say what is wrong and don't
> try to analyze the problem.

OK, I will do it.

Best Regards,
Huang Ying
