Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598Ab0IGMOe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 08:14:34 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58073 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756557Ab0IGMO1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 08:14:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=cNF3hPpLXz97tB5Z0LEH4G/wlc//Ru11KL/pRqtherEWF9k080DPMmgFDgXtD/d26T
         Z5mg/iApEpRIOvodPFKTdjZpKYclJpK1pGJOrfKWmFygDnaWTb3Cyl6bB4HmqK+Lv9CU
         DMmIKVfp/m8ynFmOyAKTQOgXSQw/TLKftqk8Q=
MIME-Version: 1.0
In-Reply-To: <20100907141319.C90D.A69D9226@jp.fujitsu.com>
References: <20100906154737.GA4332@elte.hu>
	<AANLkTikQk0S-mR2Ow2NgdzqAMB0DD05Vd1Th99gNRy8h@mail.gmail.com>
	<20100907141319.C90D.A69D9226@jp.fujitsu.com>
Date: Tue, 7 Sep 2010 15:14:26 +0300
X-Google-Sender-Auth: Vaoe_WZTR0vyKXUJ18bPhBvZDnw
Message-ID: <AANLkTinB56HqMrydqH+w_+wUx8+tHjXTq5Y6NjpAU4u8@mail.gmail.com>
Subject: Re: disabling group leader perf_event
From: Pekka Enberg <penberg@kernel.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
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

On Tue, Sep 7, 2010 at 1:57 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> As for the intermediate form, you might want to take a look at Dalvik:
>>
>> http://www.netmite.com/android/mydroid/dalvik/docs/dalvik-bytecode.html
>>
>> and probably ParrotVM bytecode too. The thing to avoid is stack-based
>> instructions like in Java bytecode because although it's easy to write
>> interpreters for them, it makes JIT'ing harder (which needs to convert
>> stack-based representation to register-based) and probably doesn't
>> lend itself well to stack-constrained kernel code.
>
> (offtopic)
>
> Afaik, NetBSD plan to include lua interpreter in kernel. it is optimized embedded environment.
>
> (more offtopic)
>
> in kernel interpreter is needed some concern. 1) restricted stack size (typical userland VM
> often use >100K stack size)  2) restrected memory allocation, especially high order allocation
> often fail. 3) GC often makes unacceptable large lag especially on UP kernel. etc etc
> So, We can't apply rich interpreter (e.g. Dalvik, Parrrot) so easily. I think. personally I prefer
> minimum component.

Yes, we definitely don't want to support memory allocation in the
first stages (if ever). I didn't mean that we should integrate Dalvik
or Parriot but that we should look at their _intermediate code_
("bytecode") as an example what we could design for the kernel.
