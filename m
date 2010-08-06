Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933838Ab0HFHIS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 03:08:18 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53053 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933221Ab0HFHIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 03:08:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:in-reply-to:references:user-agent:x-face
         :face:x-url:x-pgp-fp:x-pgp:date:message-id:mime-version:content-type;
        b=mLFlrYR7pF/RgzM4u6G6yVfF3Jg58/wTHSLy5FVQvzd5DCLeBpvaYAGxzryEclzdr1
         kDDqTJCl9+x6r1qo6B30g3RV3I6Pk1IClZnZj4PNgpkGg+4+7p05/COpxj3te8SdjjCF
         Hgz/JZQerF7U7a7PXQJabacenMDDjheYyDR1o=
From: Michal Nazarewicz <mina86@mina86.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-kernel@vger.kernel.org, m.nazarewicz@samsung.com,
        "Douglas W. Jones" <jones@cs.uiowa.edu>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] lib: vsprintf: optimised put_dec() for 32-bit machines
In-Reply-To: <201008060718.38345.vda.linux@googlemail.com> (Denys Vlasenko's
	message of "Fri, 6 Aug 2010 07:18:38 +0200")
References: <f894e94adccb940ef904983fa039a28e12217f48.1280872240.git.mina86@mina86.com>
	<0543dae0f66ba8e0ce42ce3adf1fe31704eb240d.1280872240.git.mina86@mina86.com>
	<201008060718.38345.vda.linux@googlemail.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/24.0 (Slckware Linux)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-Url: http://mina86.com/
X-PGP-FP: 9134 06FA 7AD8 D134 9D0C  C33F 532C CB00 B7C6 DF1E
X-PGP: B7C6DF1E
Date: Fri, 06 Aug 2010 09:08:11 +0200
Message-ID: <87eiec9q1w.fsf@erwin.mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denys Vlasenko <vda.linux@googlemail.com> writes:

> On Friday 06 August 2010 00:38, Michal Nazarewicz wrote:
>> The disadvantage is that the proposed function is 2.5-3.5 bigger.
>> Those are not big functions though -- we are talking here about
>> proposed function being below 512.

> It's a slippery slope. Here's where it ends: glibc
> has memcpy() function which is "only" 8k of code or so.
> I'm not joking.

I'm aware of that.  I assume that someone more clever then me will
decide whether to accept this patch or not.  (Also we win a few bytes on
put_dec_full() and put_dec_8bit()). :P

>> +#if BITS_PER_LONG == 64
>> +
> ...  
>> +#else
> ...
>> +/*
>> + * Based on code by Douglas W. Jones found at
>> + * <http://www.cs.uiowa.edu/~jones/bcd/decimal.html#sixtyfour>.  This
>> + * performs no 64-bit division and hence should be faster on 32-bit
>> + * machines then the version of the function above.
>> + */
>> +static noinline_for_stack
>> +char *put_dec(char *buf, unsigned long long n)
>> +{
>> +	uint32_t d3, d2, d1, q;
>> +
>> +	if (!n) {
>> +		*buf++ = '0';
>> +		return buf;
>> +	}
>> +
>> +	d1  = (n >> 16) & 0xFFFF;
>> +	d2  = (n >> 32) & 0xFFFF;
>> +	d3  = (n >> 48) & 0xFFFF;
>
> Are you assuming that sizeof(long long) == 8, always?

Well...  yes.  C requires long long to be at least 64-bit and I don't
see it being larger in any foreseeable feature.  Wouldn't it be enough
to put a static assert here?

-- 
Best regards,                                         _     _
 .o. | Liege of Serenly Enlightened Majesty of      o' \,=./ `o
 ..o | Computer Science,  Michal "mina86" Nazarewicz   (o o)
 ooo +--<mina86-tlen.pl>--<jid:mina86-jabber.org>--ooO--(_)--Ooo--
