Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366Ab0EVSTB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 14:19:01 -0400
Received: from smtp-02.mandic.com.br ([200.225.81.133]:47861 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432Ab0EVSTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 14:19:00 -0400
Message-ID: <4BF8200E.6020807@cesarb.net>
Date: Sat, 22 May 2010 15:18:54 -0300
From: Cesar Eduardo Barros <cesarb@cesarb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm/swapfile.c: better messages for swap_info_get
References: <4BF81D87.6010506@cesarb.net> <1274551731-4534-1-git-send-email-cesarb@cesarb.net> <20100522181352.GB26778@liondog.tnic>
In-Reply-To: <20100522181352.GB26778@liondog.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 22-05-2010 15:13, Borislav Petkov escreveu:
>> @@ -522,16 +522,16 @@ static struct swap_info_struct *swap_info_get(swp_entry_t entry)
>>   	return p;
>>
>>   bad_free:
>> -	printk(KERN_ERR "swap_free: %s%08lx\n", Unused_offset, entry.val);
>> +	printk(KERN_ERR "swap_info_get: %s%08lx\n", Unused_offset, entry.val);
>
> Why not let the compiler do it for ya:
>
> 	printk(KERN_ERR "%s: %s%08lx\n", __func__, Unused_offset, entry.val);
>
> ?... etc.

See the third patch. This function becomes swap_info_get_unlocked(), and 
swap_info_get() becomes a small wrapper around it. Yet, I still want to 
keep printing swap_info_get: in the error message (whether it is locked 
or not makes no difference from the point of view of the error messsage).

-- 
Cesar Eduardo Barros
cesarb@cesarb.net
cesar.barros@gmail.com
