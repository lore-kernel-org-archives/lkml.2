Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035Ab2ANR41 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 12:56:27 -0500
Received: from imr3.ericy.com ([198.24.6.13]:45445 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755971Ab2ANR40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 12:56:26 -0500
Date: Sat, 14 Jan 2012 09:54:47 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Alex Rio <scasbyte@gmail.com>
CC: "khali@linux-fr.org" <khali@linux-fr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 2/2] hwmon: (w83627ehf) Add GPIO port 3 functionality
Message-ID: <20120114175447.GF29012@ericsson.com>
References: <CAPbJ=B=_Xubsni7R00kSotDQ9AE9jmhmyRV0gPkXGqAPGrNaXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAPbJ=B=_Xubsni7R00kSotDQ9AE9jmhmyRV0gPkXGqAPGrNaXg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex,

On Fri, Jan 13, 2012 at 08:39:56PM -0500, Alex Rio wrote:
> The w83627ehf chip has 5 GPIO ports, currently none of them is supported.
> This patch adds the GPIO port 3 driver with the following functions:
> set/get pin values, direction_in/out, set_debounce.
> The values are also available to the userspace (if requiered)
> in the path /sys/class/gpio by using the export/unexport functions.
> Please look at the REVISIT comment, this is the main reason of the RFC,
> suggestions will be highly appreciated.
> 
> Signed-off-by: Alex Rio <scasbyte@gmail.com>
> ---

[ ... ]

> +/* REVISIT!: This is a global variable for sioreg.
> + * How could a function like gpio_get be able to access
> + * sioreg from w83627ehf_sio_data?
> + * Maybe we can make the sioreg global?
> + */
> +int global_sioaddr;
> +

This is a complete no-go, even more so since the variable name is very generic
and visible in the entire kernel. Define the variables you need as part of
a structure for which you get a pointer to, then use container_of()
to get the pointer to the outer data structure. Other gpio drivers
do this already; just look there for examples.

Guenter
