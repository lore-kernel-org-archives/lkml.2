Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432Ab0HDJ1X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 05:27:23 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54546 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932242Ab0HDJ1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 05:27:20 -0400
Date: Wed, 4 Aug 2010 10:37:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Patrick Pannuto <ppannuto@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-omap.vger.kernel.org@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, damm@opensource.se,
        lethal@linux-sh.org, rjw@sisk.pl, dtor@mail.ru, eric.y.miao@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH] platform: Faciliatate the creation of
 pseduo-platform busses
Message-ID: <20100804103714.48ddbe0e@lxorguk.ukuu.org.uk>
In-Reply-To: <4C58A7AA.8020007@codeaurora.org>
References: <4C58A7AA.8020007@codeaurora.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 	(possibly in a header)
> 	#ifdef CONFIG_MY_BUS
> 	#define MY_BUS_TYPE	&my_bus_type
> 	#else
> 	#define MY_BUS_TYPE	NULL
> 	#endif
> 
> /drivers/my_driver.c
> 	static struct platform_driver my_driver = {
> 		.driver	= {
> 			.name	= "my-driver",
> 			.owner	= THIS_MODULE,
> 			.bus	= MY_BUS_TYPE,
> 		},
> 	};
> 
> Which will allow the same driver to easily to used on either
> the platform bus or the newly defined bus type.

At compile time. I suspect there is an argument for having an
"ANY_BUS_TYPE" value for the devices so that you can runtime wildcard
stuff which works whatever sub-bus it is hung off.

> I believe this to be a fairly elegant and simple solution to the
> problem, but humbly RFC

It's exactly what I need to tidy up the SCU IPC devices on the new Intel
MID platforms certainly. It's also a very small patch to achieve it

Alan
