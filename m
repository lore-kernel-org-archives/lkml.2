Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab2HPIJo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 04:09:44 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:63071 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352Ab2HPIJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 04:09:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chao Xie <xiechao.mail@gmail.com>
Subject: Re: [PATCH V3 3/5] clk: mmp: add clock definition for pxa910
Date: Thu, 16 Aug 2012 08:09:21 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: haojian.zhuang@gmail.com, mturquette@linaro.org, viresh.linux@gmail.com,
        s.hauer@pengutronix.de, chao.xie@marvell.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1345086525-12328-1-git-send-email-xiechao.mail@gmail.com> <201208160717.03707.arnd@arndb.de> <CADApbej91_Y84sC9R1b0+LgDTzFUH8CveYsDi4wDWOQxkGnnFg@mail.gmail.com>
In-Reply-To: <CADApbej91_Y84sC9R1b0+LgDTzFUH8CveYsDi4wDWOQxkGnnFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208160809.21662.arnd@arndb.de>
X-Provags-ID: V02:K0:VI8Oy1g8t6kO4hSc9aSPlpfWf7CV58AjfO28Oz5zCfX
 YMNQ7GLqG1PvdN9FPcXvAEaUYvXjkmkDAljPQh22TCmspD7B7d
 vS2XEZcKBc4/D+Eo6CTJ7ysBWp1YNFVG8zXkojorB9xDH+2PDM
 O1mGTfwnK/etbK1u3B5jwuFUsLwDG4aeHaYwM3htQ1c4oejh/+
 CqEwk67sL3SKlbGaxSW/+8xPZAlSY1ak3LnaDg3lwHmRFvF/dy
 0U15f/HocPjV+yGVmYFKw+nE9h/clriZPd+esXDuU7k+SNZbP6
 iU/QPPi0iNQJ9USwOYJcQlZeGDKWoNP8rIhAqNn1Om4VxTx1su
 da51bEZgpTtiUJ5VO56A=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 August 2012, Chao Xie wrote:
> >> +     clocks[uart0_mux] =
> >> +         clk_register_mux(NULL, "uart0_mux", uart_parent,
> >> +                          ARRAY_SIZE(uart_parent), CLK_SET_RATE_PARENT,
> >> +                          apbc_base + APBC_UART0, 4, 3, 0, &clk_lock);


> i can change remove the clocks array, but even make the sentence
> shorter, most of them still can not fit in one line.

Don't worry too much about the line length or a particular style. This is
all about readability, and the style you use above may conform to some
written style guide, but it's not the most readable one. If you reformat
it to 

	clk = clk_register_mux(NULL, "uart0_mux", uart_parent, ARRAY_SIZE(uart_parent), CLK_SET_RATE_PARENT, apbc_base + APBC_UART0, 4, 3, 0, &clk_lock);

or

	clk = clk_register_mux(NULL, "uart0_mux", uart_parent, ARRAY_SIZE(uart_parent),
		CLK_SET_RATE_PARENT, apbc_base + APBC_UART0, 4, 3, 0, &clk_lock);

or

	clk = clk_register_mux(NULL, "uart0_mux", uart_parent,
		 ARRAY_SIZE(uart_parent), CLK_SET_RATE_PARENT,
		 apbc_base + APBC_UART0, 4, 3, 0, &clk_lock);

I still find that more readable.

	Arnd
