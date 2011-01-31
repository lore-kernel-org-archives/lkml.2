Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab1AaRo5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 12:44:57 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:52315 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab1AaRoz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 12:44:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=yApKyWiWnhQErBwJaeHMv6Jdm2VFRxn66IYYg89LfWApoqQRbSY8w5O5X1wWHojFEH
         txLO525ZKya+f9J5hjndpY6Oc2MyowA2k+K7z70ULAnkzpuolPrRj8xzw0WN+3bmNO+U
         lQBLFUuSNrtMOTqhUvyYdp7PidzrT/cFE0vgU=
MIME-Version: 1.0
In-Reply-To: <AANLkTimjz6t9ziPajW1wJdUE8ytWy=FbCr-Zg71PiBgf@mail.gmail.com>
References: <AANLkTimjz6t9ziPajW1wJdUE8ytWy=FbCr-Zg71PiBgf@mail.gmail.com>
Date: Mon, 31 Jan 2011 23:14:20 +0530
Message-ID: <AANLkTinVSyRhBtgT--PGHX7TV2gkD13_KLCJu1XB_g46@mail.gmail.com>
Subject: Re: typecheck code
From: Rajat Sharma <fs.rajat@gmail.com>
To: Sri Ram Vemulpali <sri.ram.gmu06@gmail.com>
Cc: Kernel-newbies <kernelnewbies@nl.linux.org>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Can anyone help me, explain the above code typecheck. How does
> (void)(&__dummy == &__dummy2) evaluates to 1

Its not this comparison getting evaluated to 1, but last expression
"1; \" which is forcibly returning 1 in every case. Since it is just
compile time warning and should not effect the program execution, this
macro is always returning 1 at run time. To me it just valuable for
coding style where you do some action only if type matches, but in
real sense you take action anyways.

Rajat

On Mon, Jan 31, 2011 at 10:33 PM, Sri Ram Vemulpali
<sri.ram.gmu06@gmail.com> wrote:
> Hi all,
>
> /*
>  * Check at compile time that something is of a particular type.
>  * Always evaluates to 1 so you may use it easily in comparisons.
>  */
>  #define typecheck(type,x) \
>  ({      type __dummy; \
>        typeof(x) __dummy2; \
>        (void)(&__dummy == &__dummy2); \
>        1; \
>  })
>
> #define typecheck_fn(type,function) \
> ({      typeof(type) __tmp = function; \
>       (void)__tmp; \
> })
>
> Can anyone help me, explain the above code typecheck. How does
> (void)(&__dummy == &__dummy2) evaluates to 1
>
> I appreciate any explain.
>
> --
> Regards,
> Sri.
>
> _______________________________________________
> Kernelnewbies mailing list
> Kernelnewbies@kernelnewbies.org
> http://lists.kernelnewbies.org/mailman/listinfo/kernelnewbies
>
