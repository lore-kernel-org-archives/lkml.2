Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab2L2WY3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 17:24:29 -0500
Received: from na3sys010aog104.obsmtp.com ([74.125.245.76]:49561 "HELO
	na3sys010aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753300Ab2L2WY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 17:24:26 -0500
MIME-Version: 1.0
In-Reply-To: <20121229175625.GA1963@kroah.com>
References: <1356754984-13917-1-git-send-email-roland@kernel.org> <20121229175625.GA1963@kroah.com>
From: Roland Dreier <roland@kernel.org>
Date: Sat, 29 Dec 2012 14:24:05 -0800
X-Google-Sender-Auth: -HgD4gl6sbOZqxwCBcj8Vn0uzCs
Message-ID: <CAL1RGDV1Xbu29zRY94C4Tpr8Px3PxKP=Gsy4xP65LPvijGQG0Q@mail.gmail.com>
Subject: Re: [PATCH] printk: Fix incorrect length from print_time() when
 seconds > 99999
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kay Sievers <kay@vrfy.org>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 29, 2012 at 9:56 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> Nice work.  When did you start seeing this problem, 3.6 or so?  I ask as
> it's probably something that should go to stable as well if so.

We happened to see it when we rebased to the 3.6 kernel, but as far as I
can see, the bug has been there as long as print_time(), which comes from
084681d14e42 ("printk: flush continuation lines immediately to console")
in 3.5-rc5.  When I was doing a web search for info on the problem, I found
at least the following reports:

https://bbs.archlinux.org/viewtopic.php?id=148100
https://lkml.org/lkml/2012/10/17/81

so yeah this seems to be stable material.

> Andrew seems to be keeping the printk patches these days, so I'll let
> him pick this up with:
>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
