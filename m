Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312Ab3ABFbx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 00:31:53 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:59210 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab3ABFbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 00:31:52 -0500
Message-ID: <1357104713.30504.8.camel@gitbox>
Subject: Re: [PATCH RESEND 6/6] clk: s5p-g2d: Fix incorrect usage of
 IS_ERR_OR_NULL
From: Tony Prisk <linux@prisktech.co.nz>
To: Dan Carpenter <error27@gmail.com>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        kernel-janitors@vger.kernel.org,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Date: Wed, 02 Jan 2013 18:31:53 +1300
In-Reply-To: <CA+_b7DK2zbBzbCh15ikEAeGP5h-V9gQ_YcX15O-RNvWxCk8Zfg@mail.gmail.com>
References: <1355852048-23188-1-git-send-email-linux@prisktech.co.nz>
	 <1355852048-23188-7-git-send-email-linux@prisktech.co.nz>
	 <50D62BC9.9010706@mvista.com> <50E32C06.5020104@gmail.com>
	 <CA+_b7DK2zbBzbCh15ikEAeGP5h-V9gQ_YcX15O-RNvWxCk8Zfg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-02 at 08:10 +0300, Dan Carpenter wrote:
> clk_get() returns NULL if CONFIG_HAVE_CLK is disabled.
> 
> I told Tony about this but everyone has been gone with end of year
> holidays so it hasn't been addressed.
> 
> Tony, please fix it so people don't apply these patches until
> clk_get() is updated to not return NULL.  It sucks to have to revert
> patches.
> 
> regards,
> dan carpenter

I posted the query to Mike Turquette, linux-kernel and linux-arm-kernel
mailing lists, regarding the return of NULL when HAVE_CLK is undefined.

Short Answer: A return value of NULL is valid and not an error therefore
we should be using IS_ERR, not IS_ERR_OR_NULL on clk_get results.

I see the obvious problem this creates, and asked this question:

If the driver can't operate with a NULL clk, it should use a
IS_ERR_OR_NULL test to test for failure, rather than IS_ERR.


And Russell's answer:

Why should a _consumer_ of a clock care?  It is _very_ important that
people get this idea - to a consumer, the struct clk is just an opaque
cookie.  The fact that it appears to be a pointer does _not_ mean that
the driver can do any kind of dereferencing on that pointer - it should
never do so.

Thread can be viewed here:
https://lkml.org/lkml/2012/12/20/105


Regards
Tony Prisk

