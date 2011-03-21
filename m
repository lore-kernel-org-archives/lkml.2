Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab1CUQ40 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 12:56:26 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52708 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab1CUQ4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 12:56:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=pwnKGNrg7HpbbTX00igDqysdeXp/dCj3qJCSO+aUl1+cIbG0vFHv19GdLTK3f0detc
         T4MEqWH5lDQ1lCOoZ7xFIBIFnq29Vqa8h5UV/0dm3hCTUK3aFhtKvnZxs/aiZCZXZ6Ua
         4EJoGn/SA9Y2w6HYrm3solIiclsU23G4rgRes=
Message-ID: <4D878042.9080708@gmail.com>
Date: Mon, 21 Mar 2011 19:43:46 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Don Zickus <dzickus@redhat.com>
CC: Jack Steiner <steiner@sgi.com>, tglx@linutronix.de, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86, UV: Fix NMI handler for UV platforms
References: <20110321160135.GA31562@sgi.com> <20110321161425.GC23614@elte.hu> <4D877C4B.9090602@gmail.com>
In-Reply-To: <4D877C4B.9090602@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2011 07:26 PM, Cyrill Gorcunov wrote:
...
>>
>> Such code is extremely ugly. Please *reduce* the number of is_uv_system() type 
>> of hacks in core x86 code, not increase it!
>>
>> Any reason why a higher priority for the UV NMI handler cannot solve the 'perf 
>> eats the NMI' problem?
>>
>> Thanks,
>>
>> 	Ingo
> 
> Yeah, Don has made priority system for NMI notifiers. Need to look in.
> 

I think Jack might need to setup priority for his notifier, like

static struct notifier_block uv_dump_stack_nmi_nb = {
	.notifier_call	= uv_handle_nmi,
	.priority	= NMI_LOCAL_HIGH_PRIOR+1,
};

so it would be called before perf nmi. Don, am I right?

Since for perf nmis we do have

static __read_mostly struct notifier_block perf_event_nmi_notifier = {
	.notifier_call		= perf_event_nmi_handler,
	.next			= NULL,
	.priority		= NMI_LOCAL_LOW_PRIOR,
};

-- 
    Cyrill
