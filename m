Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407Ab0KHKm7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 05:42:59 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43530 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368Ab0KHKm6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 05:42:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=JYlHS6LvFmTlshZ4vR9UXrXtmvHaCOi4p+0o+ZfOz+sTThcuLs9slHIBIuKQ6w3ZiH
         m5n630tH4PUKFvzZR/BO+WPvSaOSV11O9l5T34OcPrWkzG6GKzvhPK2+tkuRzLPgPuYN
         UduWzorOiufT0OK3FI0GwN2Q9VBp4mlonuX3I=
MIME-Version: 1.0
In-Reply-To: <20101108091858.GP16938@pengutronix.de>
References: <1289067954-5080-1-git-send-email-rabin@rab.in>
	<1289067954-5080-6-git-send-email-rabin@rab.in>
	<AANLkTin8UO9ixVep0jKK8H5roWEVRDJW4khUpT2TpPs+@mail.gmail.com>
	<20101108091858.GP16938@pengutronix.de>
Date: Mon, 8 Nov 2010 10:42:57 +0000
X-Google-Sender-Auth: sPcTvKh2VrG-lmmNllSH_TPomSY
Message-ID: <AANLkTinmSn1fqKv8sCCP8d0-_0HsLrhtorXvHCovOYve@mail.gmail.com>
Subject: Re: [PATCH 6/6] ARM: ftrace: enable function graph tracer
From: Catalin Marinas <catalin.marinas@arm.com>
To: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Rabin Vincent <rabin@rab.in>, Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Tim Bird <tim.bird@am.sony.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/8 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> On Sat, Nov 06, 2010 at 07:06:28PM +0000, Catalin Marinas wrote:
>> On Saturday, November 6, 2010, Rabin Vincent <rabin@rab.in> wrote:
>> > Add the options to enable the function graph tracer on ARM.  Function
>> > graph tracer support requires frame pointers, so exclude Thumb-2 and
>> > also explicitly select FRAME_POINTER in FUNCTION_GRAPH_TRACER since
>> > FUNCTION_TRACER doesn't select FRAME_POINTER when ARM_UNWIND is used
>> > Therefore, with GCC 4.4.0+, you get plain function tracing without frame
>> > pointers, but you'll need them if you want function graph tracing.
>> .....
>> > --- a/kernel/trace/Kconfig
>> > +++ b/kernel/trace/Kconfig
>> > @@ -141,6 +141,7 @@ config FUNCTION_TRACER
>> >
>> >  config FUNCTION_GRAPH_TRACER
>> >         bool "Kernel Function Graph Tracer"
>> > +       select FRAME_POINTER if ARM_UNWIND
>>
>> Would it be better to modify FRAME_POINTER definition in the ARM
>> Kconfig so that it is enabled automatically when FUNCTION_GRAPH_TRACER
>> is enabled?
> I don't like that suggestion much because it hides the dependency.
> Moreover a "default y if FUNCTION_GRAPH_TRACER" doesn't work if a
> precondition for FRAME_POINTER isn't true.  Rabin's approach at least
> generates a warning.

If a precondition for FRAME_POINTER isn't true, we should not force it
via 'select'. We try to get rid of such warnings in the kernel.

However, on ARM the FRAME_POINTER depends on !THUMB2_KERNEL but for
Thumb-2 kernels HAVE_FUNCTION_GRAPH_TRACER is also disabled, so there
isn't a dependency issue here. It's more like a personal preference to
keep the changes within the arch/arm tree.

-- 
Catalin
