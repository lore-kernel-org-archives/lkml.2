Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587Ab0HJMVK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 08:21:10 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44765 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620Ab0HJMVC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 08:21:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OkkebC8kcoMqaXYEHjCLP5HhsnDdOrJZZFSOVoY1S2C+zOPM1uCytZSV3CWGBsB5Yj
         FuB1wZIkcgGTWBqhG0hVAbRkm4MEmIVpzy4DPYDCOTCC9Arlf7t7WORLdByWW0m4pCLl
         bDkKcrKMNHOkjMg5aHVnF7ar9em3GmF+vv2Ok=
MIME-Version: 1.0
In-Reply-To: <1281441808.2063.498.camel@alex-desktop>
References: <1281010151.2063.8.camel@alex-desktop>
	<AANLkTi=YessPd6cHhLdveyrSq_TcY1Vx1LxpCNLthEJG@mail.gmail.com>
	<1281437552.2063.431.camel@alex-desktop>
	<AANLkTi=UfzGay5XQKMpPCZTSO5SJ1jDknqwayhrEZJO0@mail.gmail.com>
	<1281441808.2063.498.camel@alex-desktop>
Date: Tue, 10 Aug 2010 15:21:01 +0300
Message-ID: <AANLkTinCzXCAfrQ46N-AQAUVS_N4kT=p58b6GZR1AL47@mail.gmail.com>
Subject: Re: [PATCHv4] fixed resource leak in scripts/mod/modpost.c
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Alexey Fomenko <ext-alexey.fomenko@nokia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Trevor Keith <tsrk@tsrk.net>, Rusty Russell <rusty@rustcorp.com.au>,
        ext Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 10, 2010 at 3:03 PM, Alexey Fomenko
<ext-alexey.fomenko@nokia.com> wrote:
> From: Alexey Fomenko <ext-alexey.fomenko@nokia.com>
>
> sec2annotation() returns malloc'ed buffer directly to printf as an
> argument. Patch lets free this buffer after printing. Preventing ops
> while freeing the buffer by changing return const str to return
> strdup empty line.
>
> Signed-off-by: Alexey Fomenko <ext-alexey.fomenko@nokia.com>

> @@ -1283,11 +1301,15 @@
>                "uses functionality in the exit path.\n"
>                "The fix is often to remove the %sannotation of\n"
>                "%s%s so it may be used outside an exit section.\n",
> -               from, sec2annotation(fromsec), fromsym, from_p,
> -               to, sec2annotation(tosec), tosym, to_p,
> -               sec2annotation(tosec), tosym, to_p);
> +               from, prl_from, fromsym, from_p,
> +               to, prl_to, tosym, to_p,
> +               ptl_to, tosym, to_p);
Did you ever compile this code?
It looks typo here.

> +               free(prl_from);
> +               free(prl_to);
>                break;
>        case ANY_EXIT_TO_ANY_INIT:
> +               prl_from = sec2annotation(fromsec);
> +               prl_to = sec2annotation(tosec);
>                fprintf(stderr,
>                "The %s %s%s%s references\n"
>                "a %s %s%s%s.\n"

-- 
With Best Regards,
Andy Shevchenko
