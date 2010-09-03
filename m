Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027Ab0ICIfL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 04:35:11 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34849 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548Ab0ICIfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 04:35:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=UlRVYSdPR2hYhluk83ExRgrwCV40LEaxAh5u7zOD0ojAbZUVgZuGP2FM8FGix4EcP8
         CG7MyTuLWxof+55N5WfmLPO4sLrfXzjDM6rg9UE9z9ePD5EoKdqBYE8argPGeFJBgnz3
         /Lha7j0mOPUSkNPhvHqvACGmfr8+CCcJ0966I=
Message-ID: <4C80B338.6020701@gmail.com>
Date: Fri, 03 Sep 2010 10:35:04 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        linux-ide@vger.kernel.org
Subject: Re: hibernation hangs with ATA errors (lockup_detector bug)
References: <4C03C608.1040600@gmail.com> <20100601135004.GP15159@redhat.com> <4C051D44.7040203@gmail.com> <20100602184459.GA15159@redhat.com> <4C0B3E94.6020506@gmail.com>
In-Reply-To: <4C0B3E94.6020506@gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2010 08:22 AM, Jiri Slaby wrote:
> On 06/02/2010 08:44 PM, Don Zickus wrote:
>> --- a/kernel/watchdog.c
>> +++ b/kernel/watchdog.c
>> @@ -550,8 +550,7 @@ cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
>>  		break;
>>  	case CPU_ONLINE:
>>  	case CPU_ONLINE_FROZEN:
>> -		if (watchdog_enable(hotcpu))
>> -			return NOTIFY_BAD;
>> +		watchdog_enable(hotcpu)
> 
> This fixes the problem indeed.

Hi, was this fixed somehow? I still use this hunk and don't know if it
is needed:
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -524,7 +524,7 @@ cpu_callback(struct notifier_block *nfb, unsigned
long action, void *hcpu)
                break;
        case CPU_ONLINE:
        case CPU_ONLINE_FROZEN:
-               err = watchdog_enable(hotcpu);
+               watchdog_enable(hotcpu);
                break;
 #ifdef CONFIG_HOTPLUG_CPU
        case CPU_UP_CANCELED:

thanks,
-- 
js
