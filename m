Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802Ab1AaSNU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 13:13:20 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35104 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755701Ab1AaSNR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 13:13:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=pspW+VWxdq3yWq+LTo6NeuOGElVi/Ub/bpyIYj5LgS1MISwhbx53r20oYTcBQlLOK5
         nZSg7Q1rK0TdlcoTdTvvR1D1BxaHgI/8YvK/Tm2arQYCvr0j3DNW0YU9bf8MZFqtGOBq
         GazP4si52h8w+/rtFx32Uq5GXnAWILpWkoJN8=
MIME-Version: 1.0
In-Reply-To: <AANLkTimjz6t9ziPajW1wJdUE8ytWy=FbCr-Zg71PiBgf@mail.gmail.com>
References: <AANLkTimjz6t9ziPajW1wJdUE8ytWy=FbCr-Zg71PiBgf@mail.gmail.com>
From: Manish Katiyar <mkatiyar@gmail.com>
Date: Mon, 31 Jan 2011 10:03:36 -0800
Message-ID: <AANLkTimTQxDCJ004VOFCdo3rz01tHsj9R4Ce1OGb75sH@mail.gmail.com>
Subject: Re: typecheck code
To: Sri Ram Vemulpali <sri.ram.gmu06@gmail.com>
Cc: Kernel-newbies <kernelnewbies@nl.linux.org>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 9:03 AM, Sri Ram Vemulpali
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

Infact I think it will never return 1, since the addresses of __dummy1
and __dummy2 have to be different (off by 4 or 8). As pointed out it
is the next line that always returns 1. The purpose of this line is to
throw away warnings like "Incompatible pointer comparison" or
something like that (haven't tried :-)) incase there is a mismatch.

-- 
Thanks -
Manish
