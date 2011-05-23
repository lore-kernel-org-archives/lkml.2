Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab1EWC1h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 22:27:37 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:56493 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab1EWC1f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 22:27:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TVYYOE3dsQ6LIAgLbohuGbBNsbgUIpWsFEmmmDhj0ynEuaUqwEAFQSrMhSPO8gbRQ4
         cnoqZzEEXwwdvAXKak8SJoAcDI5vR9NH80d2CbXMlMr064rj4fJwm7DevpDC9sz1lpKS
         +H6gfE+g8GFwheyBTaGR/2Frd/5qfKIiohrhY=
MIME-Version: 1.0
In-Reply-To: <4DD9BA2F.9000303@zytor.com>
References: <1306113548.29789.2.camel@monotop>
	<4DD9BA2F.9000303@zytor.com>
Date: Sun, 22 May 2011 22:27:35 -0400
Message-ID: <BANLkTi=fuEzCUnK0Vuc-2WAnKUxEyG_VWw@mail.gmail.com>
Subject: Re: [PATCH] kernel: Fix ftrace.c compiler warning when calling ftrace_nop_replace()
From: Eduardo Silva <edsiper@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 22, 2011 at 9:36 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 05/22/2011 06:19 PM, Eduardo Silva wrote:
>> the function ftrace_nop_replace() returns a 'static const unsigned char *'
>> value, so when the caller perform a direct assignment to a
>> 'static unsigned char *', the compiler raise the following warning message:
>>
>>  ftrace.c:308:6: warning: assignment discards qualifiers from pointer target type
>>  ftrace.c:318:6: warning: assignment discards qualifiers from pointer target type
>>
>> Adding the proper casts the message goes away.
>>
>> Signed-off-by: Eduardo Silva <edsiper@gmail.com>
>
> This quiets a warning of something that potentially looks like a real
> bug.  Perhaps "new" should be const?

The value is returned in the following function:

static const unsigned char *ftrace_nop_replace(void)
{
	return ideal_nops[NOP_ATOMIC5];
}

ideal_nops seems to be constant and architecture dependent, so make
sense to return it as a constant pointer... i think that we need more
comments about it.

regards,



>
>        -hpa
>
>
> --
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
>
>



-- 
Eduardo Silva
http://edsiper.linuxchile.cl
http://www.monkey-project.com
