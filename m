Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757726Ab1CCGYf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 01:24:35 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62042 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756010Ab1CCGYe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 01:24:34 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTikcC1o0zM5ChPhhvhbLPtCNzrtUJ7HCNHHGTcaU@mail.gmail.com>
References: <AANLkTikcC1o0zM5ChPhhvhbLPtCNzrtUJ7HCNHHGTcaU@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 2 Mar 2011 23:24:14 -0700
X-Google-Sender-Auth: 1kpr73q04sV1FEq9asA75EbBqj4
Message-ID: <AANLkTin121DDb7DNntYvBDNPjHoESpV9X9V5yYjRjtQt@mail.gmail.com>
Subject: Re: problems with GPIO
To: "Murali K. Vemuri" <vemuri.muralikrishna@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 9:21 PM, Murali K. Vemuri
<vemuri.muralikrishna@gmail.com> wrote:
> Hi There,
>
> I am rather a novice with linux kernel and I have this problem.
> My board is  OMAP 3530 based and I use GPIO 21 to detect an external
> device plug-in.
> Now, when the board is just booted (after a complete power disconnect
> ), the GPIO is high, and when I plug in my external device, the GPIO
> goes low, and I am able to detect it.
> However, I see the voltage level still low after I remove the external
> plug-in, and any further plug-ins, remain un-detected.
> My H/W engineers say it is some config I am missing in Kernel.
> can someone point me?
>
> my code snippet is like:
>
>    omap_mux_init_gpio(MY_GPIO,  OMAP_PIN_INPUT_PULLDOWN  );
>    gpio_request(MY_GPIO,"CABLE IN");
>    gpio_direction_input(MY_GPIO);
>    gpio_set_value(MY_GPIO,1);

It depends on the gpio controller driver, but gpio_set_value() is very
likely switching the GPIO pin from input to output.  Why are you
calling gpio_set_value()?

g.
