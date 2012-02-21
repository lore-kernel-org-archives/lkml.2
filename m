Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab2BUBja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 20:39:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39409 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624Ab2BUBj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 20:39:29 -0500
References: <1328888091-9692-1-git-send-email-konrad.wilk@oracle.com> <1329786103.25686.48.camel@gandalf.stny.rr.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <1329786103.25686.48.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] x86 fixes for 3.3 impacting distros (v1).
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 20 Feb 2012 17:38:52 -0800
To: Steven Rostedt <rostedt@goodmis.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Message-ID: <edb0ef44-341f-4329-a1e7-1c95e164c193@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Odd... given that that is the NOP recommended by AMD.

Steven Rostedt <rostedt@goodmis.org> wrote:

>On Fri, 2012-02-10 at 10:34 -0500, Konrad Rzeszutek Wilk wrote:
>>    66 66 66 90          	data32 data32 xchg %ax,%ax
>> 
>> [the 66 66 .. is 'nop']. Looks good right? Well, it does work very
>well on Intel
>> (used an i3 2100), but on AMD A8-3850 it hits a performance wall -
>that I found out
>> is a result of CONFIG_FUNCTION_TRACER (too many nops??) being
>compiled in (but the tracer
>> is set to the default 'nop'). If I disable that specific config
>option the numbers
>> are the same as the baseline (with CONFIG_FUNCTION_TRACER disabled)
>on the AMD box.
>> Interestingly enough I only see these on AMD machines - not on the
>Intel ones.
>
>All paravirt ops should be labeled with "notrace" so that function
>tracer does not trace those functions. Have you annotated your new
>paravirt ops with notrace?
>
>-- Steve

-- 
Sent from my mobile phone. Please excuse my brevity and lack of formatting.
