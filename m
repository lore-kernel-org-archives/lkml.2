Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123Ab1HVORW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 10:17:22 -0400
Received: from nm15.bullet.mail.bf1.yahoo.com ([98.139.212.174]:46448 "HELO
	nm15.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753009Ab1HVORI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 10:17:08 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 801817.29538.bm@omp1026.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=zhVkiSmcirfaldfJ5mNJkfi8O9M7eWTjIEUmyRi9PzOFVTk/8Fp6c8nr984YiSjohm51pfGJtZSoHJSg59U/Pyj6bWBMx8j/84T6a5wF8GpETbiOdc0EDKD8Sp18xH//5WYuPucf8P22EGqOlW8F9PcDFz+pq++gLs2N+N3CTAo=;
X-YMail-OSG: jB59ubQVM1ngMxMuek7HJZ2Q4_nUtseZMcLOZbNABQ9qlFA
 0ANZ0p7a9oeUUQRfR7hjqhxUH_X11.3k4YDOzIYWe4Q0fqmbfMNNSuVwOW3F
 SeLlXjnVwfATK7N1aCY4RlJ4CgPZ8dvIZRhzhfLfstG0kPYSwoT3ur9AKkVh
 vWrTBOZssGtBagBiIM2grM.4ZgefF5lap.Rnj4ufYMk90Lz4UAHf0xcX_Q3B
 SM4vASaIbWebNIkqJ9bP1Za3rausIL10v4gmO6mS9ohi.9GzumphptW7t87M
 rwnknfuGaOREAU4K3yB.xGHIvytJ9MOopfPVRKQAgBw5Ws2Mz1wtpX8LQYDz
 E8URsbsPAQku2OLWXWQeHp2S5N5S.nKOTkjel7ECBH0OaSmJK.sBTT2ZA2U9
 r5.7qcfaK_16CS1YABYdAI96ehrFxaiNgPEO1Hay0qoxq.c97
X-Mailer: YahooMailWebService/0.8.113.313619
References: <1313898848.75462.YahooMailNeo@web162014.mail.bf1.yahoo.com> <CAM_iQpV7D1s9oisy1Zx6-MeiruEwm3BQ5sg1UqpmraF0BazXuA@mail.gmail.com>
Message-ID: <1314022627.68014.YahooMailNeo@web162017.mail.bf1.yahoo.com>
Date: Mon, 22 Aug 2011 07:17:07 -0700 (PDT)
From: Pintu Agarwal <pintu_agarwal@yahoo.com>
Reply-To: Pintu Agarwal <pintu_agarwal@yahoo.com>
Subject: Re: help for kernel initcall section (init.h)
To: =?iso-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <CAM_iQpV7D1s9oisy1Zx6-MeiruEwm3BQ5sg1UqpmraF0BazXuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

         


----- Original Message -----
> From: Américo Wang <xiyou.wangcong@gmail.com>
> To: Pintu Agarwal <pintu_agarwal@yahoo.com>
> Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
> Sent: Monday, 22 August 2011 2:38 PM
> Subject: Re: help for kernel initcall section (init.h)
> 
> On Sun, Aug 21, 2011 at 11:54 AM, Pintu Agarwal <pintu_agarwal@yahoo.com> 
> wrote:
>> Hi,
>> 
>> I need some help in modifying initcall section in init.h.
>> 
>> That is :
>> 
>> #define __define_initcall(level,fn,id) \
>>  static initcall_t __initcall_##fn##id __used \
>>  __attribute__((__section__(".initcall" level 
> ".init"))) = fn
>> 
>> I have to create two different kinds (and later more) of init section and 
> use one of them based on some condition.
>> For example, I have one init section for normal mode and one init section 
> for charger mode.
>> During charger mode, I do not have to execute all the initcall so a 
> charger.initcall is create with lesser init function.
>> The charger initcall section is as follows:
>> #define __define_charger_initcall(level,fn,id) \
>>  static initcall_t __charger_initcall_##fn##id __used \
>>  __attribute__((__section__(".charger.initcall" level 
> ".init"))) = fn
>> 
>> 
>> Now the problem is that during compile time both of them needs to be 
> polulated based on CHARGER_MODE is enabled or disabled.
>> How can this decision be taken during compile time under the macro 
> "__define_initcall" ??
>> 
>> Something like :
>> 
>> #define __define_initcall(level,fn,id)     \
>>                                                        static initcall_t 
> __initcall_##fn##id __used \
>>                                                        
> __attribute__((__section__(".initcall" level ".init"))) = 
> fn  \
>>                                                        #if 
> defined(CHARGER_MODE)  \
>>                                                        static initcall_t 
> __charger_initcall_##fn##id __used  \
>> 
>                                                        __attribute__((__section__(".charger.initcall" 
> level ".init"))) = fn   \
>>                                                        #endif
> 
> Hi,
> 
> Why not
> 
> X_initcall(foo_initcall);
> #ifdef CHARGER_MODE
> X_initcall(foo_charger_initcall);
> #endif
> 
> ?
>

No the requirement is not to do like this.
This requires defining 2 set of init calls, one for normal and one for charger init call.
We do not want to define separate init calls for charger.
We just want to take a decision during compile time to determine which initcalls should be used during charger mode.

Thus we need compile time comparison in macro which helps us in determining whether _this__ init call should be added in charger.init section or not.
Thus we can do as follows:-
------------------------------------------------------------------------------------------------------------------------------------
#define __define_initcall(level,fn,id)              static initcall_t __initcall_##fn##id __used __attribute__ ((__section__(".initcall" level ".init"))) = fn  \
                                                                #ifdef CHARGER_MODE  \
                                                                static initcall_t __charger_initcall_##fn##id __used __attribute__ ((__section__(".charger.initcall" level ".init"))) = fn  \
                                                                #endif
 
#define device_initcall(fn)      __define_initcall("6", fn, 6, 1)
#define __initcall(fn)          device_initcall(fn)
#define module_init(x)          __initcall(x);
#define early_initcall(fn)      module_init(fn)
------------------------------------------------------------------------------------------------------------------------------------

Basically we need something like:

#define     __define_initcall(....)                \
                                                             /* polupate init section */ \
                                                             #ifdef CHARGER_MODE  \
                                                             /* polupate charger.init section also */  \
                                                             #elif  ANOTHER_MODE  \
                                                             /* polupate another.init section also */  \
                                                             #elif ....
                                                             .............
                                                             .............
                                                             #endif

Is it possible to do "#if or #ifdef" inside "#define" ?????

Basically, we need to populate each.init section based on some compile time condition.
How can we do that????


Thanks,
Pintu
