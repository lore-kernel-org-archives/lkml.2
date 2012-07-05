Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369Ab2GETlX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 15:41:23 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:54955 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755772Ab2GETlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 15:41:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 0/2] PM / Domains: Allow drivers to attach PM domain callbacks to devices at any time
Date: Thu, 5 Jul 2012 21:46:55 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
References: <201207031227.45383.rjw@sisk.pl>
In-Reply-To: <201207031227.45383.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207052146.55355.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 03, 2012, Rafael J. Wysocki wrote:
> Hi,
> 
> This is a follow-up of the discussion I had with Arnd and Magnus during
> the LCJ last month.
> 
> Namely, one of the limitations of the current generic PM domains code is that
> pm_genpd_add_callbacks() has to be executed after the device in question has
> been added to a PM domain.  This means that, if a driver wants to run this
> routine from its .probe() callback, it cannot be registered before adding
> the device to the PM domain, which potentially may be a problem when device
> trees get involved into the system initialization.
> 
> For this reason, it is desirable to allow pm_genpd_add_callbacks() to be called
> for devices that haven't been added to any generic PM domains yet and the
> following patches attempt to make that happen.
> 
> [1/2] Add reference counter for objects used to store PM domains data related
>       to devices.
> [2/2] Make it possible to call pm_genpd_add_callbacks() before the device is
>       added to a PM domain.

Well, I'm taking the lack of comments as the lack of objections. :-)

Thanks,
Rafael
