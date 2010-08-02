Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303Ab0HBTJe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 15:09:34 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:41731 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab0HBTJd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 15:09:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GBqW+AjKxvQqTbq2ZbMfW9+uxFrhyMXgP0U4FOyuW1QrxQQL595RQFYj7wwMe+9KJd
         dQIJYL3AbJtf/OrTUXJsuoztvWQowE9SPZGLLECDcPthY7bHH0lzZ/HzmuFR/OLx9eUn
         20odk479C2wweUBMsXb+UtEeBqsEs5FsOc0uY=
MIME-Version: 1.0
In-Reply-To: <4C570DFE.503@zytor.com>
References: <4C56701B.1030000@kernel.org>
	<AANLkTi=r-vt=Pr+xchiR+s12RDU9xQbXnmCB4pTJcc2_@mail.gmail.com>
	<4C570DFE.503@zytor.com>
Date: Mon, 2 Aug 2010 16:09:32 -0300
Message-ID: <AANLkTinWQ8Td6LcUGn3RmAyDuL0o35-YtjFtpNwJOb3M@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86, setup: reorgize the early_console_setup
From: Thiago Farina <tfransosi@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 2, 2010 at 3:27 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 08/02/2010 10:56 AM, Thiago Farina wrote:
>>
>> These to functions above can be fairly simplified by writting as:
>>
>> static bool inline is_hex_digit(int c) {
>>   return (c >= '0' && c <= '9') ||
>>             (c >= 'A' && c <= 'F') ||
>>             (c >= 'a' && c <= 'f');
>> }
>>
>
> a) You lose the isdigit() functionality, which is useful on its own.
> b) Does this enahance readability in any way?
> c) Your proposed renaming is nonstandard.
>

What about this instead?

static inline bool isxdigit(int ch) {
  return (isdigit(ch) || (ch >= 'A' && ch <= 'F') || (ch >= 'a' && ch <= 'f');
}

> As such, I don't think this is a good idea.
>
>        -hpa
>
