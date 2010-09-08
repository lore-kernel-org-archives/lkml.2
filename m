Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428Ab0IHGQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 02:16:51 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56739 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab0IHGQu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 02:16:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ptBUcIgrev/erYBxVkbnUoSlLuHghPR27m1iBw9fwIC1aDZ89KXPW8lsMECtK0jb2U
         Si5fzAkQXBnel8HZcAgjaOItwNXRlNmWgyprlRPckprM2dVeeDj5JYsJQdOSHZsiCqUc
         n9CAQj5JmXPO9G/KxhH9+LJOgzeN5fxlljF3E=
MIME-Version: 1.0
In-Reply-To: <20100908014409.GA17010@brick.ozlabs.ibm.com>
References: <4C84D1CE.3070205@redhat.com>
	<1283774045.1930.341.camel@laptop>
	<4C84D77B.6040600@redhat.com>
	<20100906124330.GA22314@elte.hu>
	<4C84E265.1020402@redhat.com>
	<20100906125905.GA25414@elte.hu>
	<4C850147.8010908@redhat.com>
	<20100906154737.GA4332@elte.hu>
	<4C852B2A.2030103@redhat.com>
	<20100907034417.GA14046@elte.hu>
	<20100908014409.GA17010@brick.ozlabs.ibm.com>
Date: Wed, 8 Sep 2010 09:16:49 +0300
X-Google-Sender-Auth: Jc_t10oZmop5ishHRg2G_dup_II
Message-ID: <AANLkTi=YdAxdGv1nEEZ4w0jM0K3ss0g5x7_5cU8xNEhj@mail.gmail.com>
Subject: Re: disabling group leader perf_event
From: Pekka Enberg <penberg@kernel.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Tom Zanussi <tzanussi@gmail.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-perf-users@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/8 Paul Mackerras <paulus@samba.org>:
>> We start with trivial (and useless) special case of something like:
>>
>> #define MAX_BYTECODE_SIZE 256
>>
>> int x86_bytecode_verify(char *opcodes, unsigned int len)
>> {
>>
>>       if (len-1 > MAX_BYTECODE_SIZE-1)
>>               return -EINVAL;
>>
>>       if (opcodes[0] != 0xc3) /* RET instruction */
>>               return -EINVAL;
>>
>>       return 0;
>> }
>>
>> ... and then we add checks for accepted/safe x86 patterns of
>> instructions step by step - always keeping it 100% correct.
>
> So... I would be interested to see you add the case for the MOV
> instruction. :)

Heh, which one of them - there are tons of variants under 'mov' on
x86? On a more serious note: the biggest problem is that you need to
do verification during execution because you don't know the exact
address until then for most addressing modes that use registers.

                        Pekka
