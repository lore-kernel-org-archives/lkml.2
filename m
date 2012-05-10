Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444Ab2EJBSf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 21:18:35 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:56174 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756994Ab2EJBSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 21:18:32 -0400
MIME-Version: 1.0
In-Reply-To: <1336611278.728.9.camel@mop>
References: <1336004953.4240.9.camel@mop> <CA+1xoqdCk9FcqdLEvwgHtfrauNh=s0dDwcpaJimMC_H83N=_5w@mail.gmail.com>
 <1336475689.1179.12.camel@mop> <CA+55aFwbQTq_f7p2j-eu8-hVpiZ1Uf2MCU7R+DDWHimiVbcScg@mail.gmail.com>
 <CA+1xoqcAjEh5LT42NpjoE0998KUecY6EWQp4FM0_CY8MPyLmbQ@mail.gmail.com>
 <CA+55aFzVs0GLpNVUBHtLRuc8uQc=WKd8ajeVWsffbNvxSQvB4Q@mail.gmail.com>
 <CA+55aFzgXzFs9z-5ViQ4=4hhtOtK=CBHGxNX_dsXQV9mn1qANg@mail.gmail.com>
 <20120509070710.GA29981@gmail.com> <CAPXgP11evyQQKNDaa00R7qsOFy5Xk-utN1w9OgB4y6NxLZG=UA@mail.gmail.com>
 <1336611278.728.9.camel@mop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 9 May 2012 18:18:11 -0700
X-Google-Sender-Auth: FdbUS00T8mHpcS4SwuiHkIrrYX8
Message-ID: <CA+55aFyrrH0jJV--L=ugt0YK7pT+jmhjvt_WRWyenyiroN97zg@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to variable-length
 record buffer
To: Kay Sievers <kay@vrfy.org>
Cc: Ingo Molnar <mingo@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Sasha Levin <levinsasha928@gmail.com>,
        Greg Kroah-Hartmann <greg@kroah.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 9, 2012 at 5:54 PM, Kay Sievers <kay@vrfy.org> wrote:
>
> How about this? It relaxes the need for KERN_CONT, but it limits
> continuation lines to repeated calls of the same thread.

Fair enough, looks reasonable.

Except your case-statement sucks. Having a "case 'c':" that basically
then immediately has an "if (it was not 'c')" is just disturbing. Just
move the code that is common to all the cases outside the case
statement entirely, and make the 'c' case not do anything at all, and
remove that crazy extraneous if-statement.

                  Linus
