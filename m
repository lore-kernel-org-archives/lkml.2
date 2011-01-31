Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277Ab1AaU0R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 15:26:17 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51256 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270Ab1AaU0Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 15:26:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KTGUd7Pks8ZGwtX+1NOI5KLXyjYTPLUWtn+dRXPGtXpgfIpJrG/zJ5vSDZH/otWBV9
         D5onwGQ53airdiN0rb5ang4R7opR6YFo88nJMtuLAj5sMQvEtIWpEMbdo+Kb206vHv0A
         8olzlje7L/OzUk3cM1kTg2Xrgwm1SBAROuk0A=
MIME-Version: 1.0
In-Reply-To: <AANLkTimjz6t9ziPajW1wJdUE8ytWy=FbCr-Zg71PiBgf@mail.gmail.com>
References: <AANLkTimjz6t9ziPajW1wJdUE8ytWy=FbCr-Zg71PiBgf@mail.gmail.com>
Date: Mon, 31 Jan 2011 12:26:15 -0800
Message-ID: <AANLkTimgTCdJfyKcyrpM-VgWtNCFonu2rvca+pkc+ebh@mail.gmail.com>
Subject: Re: typecheck code
From: Dave Hylands <dhylands@gmail.com>
To: Sri Ram Vemulpali <sri.ram.gmu06@gmail.com>
Cc: Kernel-newbies <kernelnewbies@nl.linux.org>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sri,

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
>
> I appreciate any explain.

If dummy and dummy2 are of different types, then when you try and do a
pointer comparison (&dummy == &dummy2) it will produce a compiler
warning/error.

The actual comparison will always fail, but it doesn't matter since
the results aren't used.

typecheck always returns 1.

Dave Hylands
