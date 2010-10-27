Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab0J0Rm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 13:42:57 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54652 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895Ab0J0Rmy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 13:42:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OlVK7XuCZ9wWIk+P1b6ByHNolQlgKhEU0ttGkQ1GFoMIGGjxHkDmP4W6WanTY25E8m
         djl4g9pCZKbR7h8zcHZdWjkXhSEOSAQfC54qv9Gs4ejnIWM3vPEH/8HYUFfoj6tziy2c
         qmLkqKanp5hNprE5JB6ktO3U1W9K+dB0MScCo=
MIME-Version: 1.0
In-Reply-To: <20101027173340.GA25134@opensource.wolfsonmicro.com>
References: <1279030173-3086-1-git-send-email-sundar.iyer@stericsson.com>
	<AANLkTinc50bzQawaoA_XfkLhJXjVjPWzxgbCJ40UnYwi@mail.gmail.com>
	<20101027173340.GA25134@opensource.wolfsonmicro.com>
Date: Wed, 27 Oct 2010 15:42:53 -0200
Message-ID: <AANLkTi=DRHVbz3ov_gL6qyYH673WDk+1Vyw2AvjhSRxv@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] regulator: add support for regulators on the
 ab8500 MFD
From: Thiago Farina <tfransosi@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Sundar Iyer <sundar.iyer@stericsson.com>, lrg@slimlogic.co.uk,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        STEricsson_nomadik_linux@list.st.com,
        Linus Walleij <linus.walleij@stericsson.com>,
        Bengt JONSSON <bengt.g.jonsson@stericsson.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 3:33 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Wed, Oct 27, 2010 at 02:25:44PM -0200, Thiago Farina wrote:
>
>> Shouldn't be this returning 1 instead of true and 0 instead false
>> (since the return type is int not bool)?
>
> There is no reason to do this, logical values are treated as 0 and 1 in
> C.  Using false and true is clear and won't cause any difference in
> code.
>
In C99 I suppose that is true and legal?

>> Maybe like this?
>> return (ret & info->mask) ? 1: 0;
>
> No, that's needlessly obfuscated.
>
Obfuscated? What you mean? It is a driver, and people reading and
writing a driver would know what it means, no?

Would be much simpler if it was just (like done in ab3100.c):

return (ret & info->mask);
