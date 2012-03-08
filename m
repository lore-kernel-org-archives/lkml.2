Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759319Ab2CHASQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 19:18:16 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41778 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642Ab2CHASP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 19:18:15 -0500
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Dave Jones" <davej@redhat.com>, "Joe Perches" <joe@perches.com>
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: decode GFP flags in oom killer output.
References: <20120307233939.GB5574@redhat.com>
 <1331165061.20565.19.camel@joe2Laptop>
Date: Thu, 08 Mar 2012 01:18:12 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.watsgmo13l0zgt@mpn-glaptop>
In-Reply-To: <1331165061.20565.19.camel@joe2Laptop>
User-Agent: Opera Mail/11.61 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Mar 2012 01:04:21 +0100, Joe Perches <joe@perches.com> wrote:

> On Wed, 2012-03-07 at 18:39 -0500, Dave Jones wrote:
>> +static void decode_gfp_mask(gfp_t gfp_mask, char *out_string)
>> +{
>> +	unsigned int i;
>> +
>> +	for (i = 0; i < 32; i++) {
>
> < sizeof(gfp_t * 8)
>
>> +		if (gfp_mask & (1 << i)) {
>
> (gfp_t)1 << i
>
>> +			if (gfp_flag_texts[i])
>> +				out_string += sprintf(out_string, "%s ", gfp_flag_texts[i]);
>> +			else
>> +				out_string += sprintf(out_string, "reserved! ");
>
> 	not much use to exclamation points.
>
>> +		}
>> +	}
>> +	out_string = "\0";
>
> 	out_string[-1] = 0;

Will break if gfp_mask == 0.

>> +}
>> +

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
