Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759236Ab1D0N0C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 09:26:02 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59605 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756378Ab1D0N0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 09:26:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 1/1] can: add pruss CAN driver.
Date: Wed, 27 Apr 2011 15:25:28 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "Subhasish Ghosh" <subhasish@mistralsolutions.com>,
        "Wolfgang Grandegger" <wg@grandegger.com>,
        "Marc Kleine-Budde" <mkl@pengutronix.de>, sachi@mistralsolutions.com,
        davinci-linux-open-source@linux.davincidsp.com, Netdev@vger.kernel.org,
        nsekhar@ti.com, open list <linux-kernel@vger.kernel.org>,
        CAN NETWORK DRIVERS <socketcan-core@lists.berlios.de>,
        m-watkins@ti.com
References: <1303474267-6344-1-git-send-email-subhasish@mistralsolutions.com> <4DB5D452.9050500@grandegger.com> <46D523E49EFF489F9B088AE7B9CD7286@subhasishg>
In-Reply-To: <46D523E49EFF489F9B088AE7B9CD7286@subhasishg>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104271525.28512.arnd@arndb.de>
X-Provags-ID: V02:K0:075UTwaevL/qpqRTqrKG8/t1IQZJ2gY0kjacjYCl4b3
 t69PrksuhiX4s4rKo6DM8cJKo+/6sBVt8e3CtQqRrQ9BDLsogX
 lWc1I3dvi71w2rgwSWhDoc6FANLLm6jQQLNUpf5nAAv2swaOIL
 W3CFpmd54A2nVVJvETcFLfI9gJC4hArONzwQ22u5KZZuUcVORd
 3mFQNkQ5Cwueu7yhhyNnw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 April 2011, Subhasish Ghosh wrote:
> >
> > - Use just one value per sysfs file
> 
> SG - I felt adding entry for each mbx_id will clutter the sysfs.
>         Is it ok to do that.

That is probably not much better either.

Note also that every sysfs file needs to come with associated
documentation in Documentation/ABI/*/ to make sure that users
will know exactly how the file is meant to work. 

Why do you need to export these values in the first place? Is
it just for debugging or do you expect all CAN user space
to look at this?

If it's for debugging, please don't export the files through sysfs.
Depending on how useful the data is to regular users, you can
still export it through a debugfs file in that case, which has
much less strict rules.

If the file is instead meant as part of the regular operation of
the device, it should not be in debugfs but probably be integrated
into the CAN socket interface, so that users don't need to work
with two different ways of getting to the device (socket and sysfs).

	Arnd
