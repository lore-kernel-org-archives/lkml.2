Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932803Ab0FUPX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 11:23:29 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53658 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932718Ab0FUPX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 11:23:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=CC3dge340iyvcSRHZr9t84Rj26m6OTV/+zGjGto9kam57CIaquaVk063I6HP7Gu/Us
         VPpYRE2PAyp9MznmoAcKjt+MG2QpIk+6SPJk3z+1zGGARIWB9tqSWYw/Eyx/EXywwT1v
         92sehNatL8Jhs2lpP1pSVWTO3Dh9tFrv467hk=
Message-ID: <4C1F83EB.8060703@gmail.com>
Date: Mon, 21 Jun 2010 17:23:23 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100608 SUSE/3.1rc2-2.2 Thunderbird/3.1
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Jiri Slaby <jslaby@suse.cz>, rjw@sisk.pl,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] PM / Hibernate: swap, switch to hibernate_io_handle
References: <1275468768-28229-1-git-send-email-jslaby@suse.cz> <20100610135541.GB4514@ucw.cz>
In-Reply-To: <20100610135541.GB4514@ucw.cz>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2010 03:55 PM, Pavel Machek wrote:
> It would be good if you carried ack-s from previous rounds, so that I
> don't have to review good patches again...

Hi, previously ACKed patches were merged already. These were much
rewritten and their original versions were rather NACKed. Otherwise I
transfer ACKs indeed.

>> +/**
>> + * hib_io_handle_alloc - allocate io handle with priv_size for private data
>> + *
>> + * @priv_size: the sie to allocate behind hibernate_io_handle for private use
>> + */
>> +static inline struct hibernate_io_handle *hib_io_handle_alloc(size_t priv_size)
>> +{
>> +	struct hibernate_io_handle *ret;
>> +	ret = kzalloc(sizeof(*ret) + priv_size, GFP_KERNEL);
>> +	if (ret)
>> +		ret->priv = ret + 1;
> 
> Uhuh, why this? Aha, grabbing the pointer to priv_size-sized area at
> the end of regular struct?

Yes, exactly, any more transparent way to do it?

-- 
js
