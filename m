Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449Ab1KYRZY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 12:25:24 -0500
Received: from bipbip.grupopie.com ([195.23.16.24]:33441 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab1KYRZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 12:25:24 -0500
X-Greylist: delayed 1196 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Nov 2011 12:25:23 EST
Message-ID: <4ECFCAD5.5040606@grupopie.com>
Date: Fri, 25 Nov 2011 17:05:25 +0000
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Nuno Santos <nsantos@edigma.com>
CC: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Floating point usage inside kernel
References: <S1754322Ab1KYK6W/20111125105822Z+929@vger.kernel.org> <4ECF789F.3040001@edigma.com> <4ECF8528.9080800@gmail.com> <4ECFBF56.4000002@edigma.com>
In-Reply-To: <4ECFBF56.4000002@edigma.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nuno Santos wrote:
> Hi Jiri,

Hi, Nuno

> [...]
> But now that I have opened this question here I should ask... is it safe?

No!

> [...]
> And the input data is the following:
> 
> src[0] = [0,6300]; src[1] = [0,6300]; src[2] = 1.0;
> zone->Matrix (double[3][3])
> 
> u: 492.188 v: 615.234 sx: 683.158 sy: 5790.13
> 
> u: 5807.81 v: 615.234 sx: 5944.9 sy: 5900.58
> 
> u: 5807.81 v: 5684.77 sx: 6027.46 sy: 560.337
> 
> u: 492.188 v: 5684.77 sx: 751.198 sy: 476.455
> 
> 
> and tex is output (double[3])
[...]

Given the range of numbers you're working with, you can probably get
away with just a 16.16 fixed point representation. The operations go
like this:

convert a double to a fixed point number just do (but not on the kernel):

  fixed = (s32)(double * 65536.0);

convert an integer to fixed:

  fixed = integer << 16;

multiplication:

  result = (s32)(((s64) fixed_a * fixed_b) >> 16);

addition:

  result = fixed_a + fixed_b;

etc...

Unless you have overflow or need more than 16 bits of fractional
precision, you'll have no problem with this approach.

I hope this helps,

-- 
Paulo Marques - www.grupopie.com

"All generalizations are false."
