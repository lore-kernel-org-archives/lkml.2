Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab0HZIXz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 04:23:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753104Ab0HZIXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 04:23:53 -0400
Message-ID: <4C762495.7050203@redhat.com>
Date: Thu, 26 Aug 2010 11:23:49 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] KVM: x86 emulator: trap and propagate #DE from DIV
 and IDIV
References: <1282648229-19575-1-git-send-email-avi@redhat.com> <1282648229-19575-4-git-send-email-avi@redhat.com> <20100825210501.GD32737@amt.cnet>
In-Reply-To: <20100825210501.GD32737@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 08/26/2010 12:05 AM, Marcelo Tosatti wrote:
>
>> @@ -3363,7 +3374,7 @@ special_insn:
>>   		break;
>>   	case 0xf6 ... 0xf7:	/* Grp3 */
>>   		if (emulate_grp3(ctxt, ops) != X86EMUL_CONTINUE)
>> -			goto cannot_emulate;
>> +			goto done;
>>   		break;
> Must assign rc to emulate_grp3() retval.

While there's not much difference between X86EMUL_PROPAGATE_FAULT and 
X86EMUL_CONTINUE, it's bad form to break things internally.  I'll fix 
and repost.

-- 
error compiling committee.c: too many arguments to function

