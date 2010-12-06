Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab0LFPTx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 10:19:53 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:34730 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab0LFPTw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 10:19:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rKKU2LwfhfCzU/oAcr0Fr7dHrRB6/zye9ITRjqT4kEcSY7oetyUb7DiSDMbDdO8z4B
         xe8RXLRRgSgDglK3sfH4F3Gw5G/jxB7Zt3FN9SVEa7MNlLQDaG08nSbJqXQsNlcf9YIK
         Mh9adcGU8iaI+3Fwz3yAhSny0e7VXSQjkCOAA=
MIME-Version: 1.0
In-Reply-To: <AANLkTimDVdQ6-GxMdYHznp1SZp_=_486_Vrun0JEMDw4@mail.gmail.com>
References: <20100609214616.GA31340@x200>
	<AANLkTimDVdQ6-GxMdYHznp1SZp_=_486_Vrun0JEMDw4@mail.gmail.com>
Date: Mon, 6 Dec 2010 17:19:50 +0200
Message-ID: <AANLkTi=pLjqbK8cnn0PQvFjwcUeujJS7zbHpTfO1mOiE@mail.gmail.com>
Subject: Re: [PATCH 1/2] kstrto*: converting strings to integers done
 (hopefully) right
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Thiago Farina <tfransosi@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        yi.y.yang@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 6, 2010 at 3:26 AM, Thiago Farina <tfransosi@gmail.com> wrote:
> On Wed, Jun 9, 2010 at 6:46 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
>> diff --git a/lib/test-kstrtox.c b/lib/test-kstrtox.c
>> new file mode 100644
>> index 0000000..56fda26
>> --- /dev/null
>> +++ b/lib/test-kstrtox.c
>> @@ -0,0 +1,356 @@
>> +#include <linux/init.h>
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +
>> +#define for_each_test(i, test) \
>> +       for (i = 0; i < sizeof(test) / sizeof(test[0]); i++)
>> +
> micronit: Can you use ARRAY_SIZE macro here? Ignore this if it's irrelevant.

Dunno,
sizeof(x)/sizeof(x[0]) is really C idiom.
And ARRAY_SIZE is misnamed, it doesn't reflect size.
