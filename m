Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986Ab0GWH6P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 03:58:15 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:38589 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab0GWH6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 03:58:14 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: Re: [PATCH] USB: core: Choose configuration with lowest bConfigurationValue
Date: Thu, 22 Jul 2010 18:19:47 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
Cc: linux-usb@vger.kernel.org, Adam Kropelin <akropel1@rochester.rr.com>,
        Xiaofan Chen <xiaofanc@gmail.com>, linux-kernel@vger.kernel.org
References: <op.vf8lmjow7p4s8u@pikus> <ed7910dcd6f62c058938f30aceb0fa5cd7c3f385.1279807231.git.m.nazarewicz@samsung.com>
In-Reply-To: <ed7910dcd6f62c058938f30aceb0fa5cd7c3f385.1279807231.git.m.nazarewicz@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201007221819.47141.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 22. Juli 2010, 16:09:10 schrieb Michal Nazarewicz:
> This patch removes code from usb_choose_configuration()
> responsible for ignoring the first USB device configuration if
> its first interface is RNDIS.  Instead,
> usb_choose_configuration() chooses configuration with lowest
> bConfigurationValue.  Linux' Ethernet gadget uses a lower
> bConfigurationValue for the second configuration which is
> a CDC configuration so this code should choose configuration
> that suits Linux better.

But what if the other side is not a Linux gadget? We need this code
to not select RNDIS on those devices. I am afraid we can't do this?

	Regards
		Oliver
