Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab2GaVBW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 17:01:22 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53458 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468Ab2GaVBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 17:01:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: Re: [PATCH] misc/pch_phub: Enable UART clock setting by module parameter
Date: Tue, 31 Jul 2012 21:01:16 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
References: <1342000670-1005-1-git-send-email-tomoya.rohm@gmail.com> <201207251331.52883.arnd@arndb.de> <CANKRQnimtFQapk-u_ipYYOqrVVavGBCqcAG6x82WNWCH_Jcdkw@mail.gmail.com>
In-Reply-To: <CANKRQnimtFQapk-u_ipYYOqrVVavGBCqcAG6x82WNWCH_Jcdkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207312101.17095.arnd@arndb.de>
X-Provags-ID: V02:K0:Pt5cNx0l38RxgADuw8+30quxDKCj71zQiOi6iVT6iJU
 yI9SD8UwTImpZSkcogNCC0aU4qiu7ppojeYtb/eWH6XUE7Q73D
 fw1JG+BEFpe5lWrddb+YuHjLB2bp4osPsZwWr0hqSYXYKbRf4y
 5kt31AppatLU5coEQiRZnwqB5FCZqFPJsgdKMyrpFgjKR1Z4wm
 uZ2vqaBgvtWVDB4Ou3zoSkUrnDZnksvH4P3MoKp0F/g4cXlTMs
 prbYuxTlus5xDn3gwix7RiLqXYLJgR0Pw92Mhk4iJv1Ks+lNDv
 afIWTGyaudSuQNcKbBZYcKRKf+G/t8TgtmK1AwUbPCV6h7UBCH
 l2KQ4w1mSXL8C5q5ya0c=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 31 July 2012, Tomoya MORINAGA wrote:
> 
> On Wed, Jul 25, 2012 at 10:31 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > What I think should work better here would be to use the clk API,
> > so that the phub driver registers a 'struct clk' using
> > (I assume) clk_register_divider_table().
> > The UART driver would then call clk_get() to find that clk for
> > the uart device and call clk_set_rate when it needs to change
> > that clock in order to set a different baud rate.
> >
> > Does this make sense?
> >
> 
> Thank you for your comments. This sounds good idea.
> However, it seems the latest kernel doesn't have clk_register_divider_table().
> Will the clk_register_divider_table function be applied soon ?

The code was just merged for v3.6, so it will be in all future kernels that
would also see your changes, but not in older kernels in case you want to
backport your patch.

	Arnd
