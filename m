Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab2I0OmO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 10:42:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60226 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab2I0OmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 10:42:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Vinod Koul <vinod.koul@linux.intel.com>
Subject: Re: [PATCHv2 2/4] dmaengine: dw_dmac: Add PCI part of the driver
Date: Thu, 27 Sep 2012 14:42:07 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: viresh kumar <viresh.kumar@linaro.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "spear-devel" <spear-devel@list.st.com>
References: <1348575190-11761-1-git-send-email-andriy.shevchenko@linux.intel.com> <201209270741.54443.arnd@arndb.de> <1348755756.1648.33.camel@vkoul-udesk3>
In-Reply-To: <1348755756.1648.33.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201209271442.07938.arnd@arndb.de>
X-Provags-ID: V02:K0:lKspXZd7CSxV3Sf6aTlXGQB2zDUlWHog2eQXWi47Czr
 6wzUdTahcfOvhvM41IlBgrFn3oEZ8QBg+cWzcePh6Xze+m3Mq8
 8tBiTW5yF++cCGlWSJ6YRl2XPu9CgEnjjvq/osOJWySg6OuNcP
 pbZL65s2wZ+HIuWYGw6H4FZ1wHd/U5aneeug+bACED0oiXEzpq
 8/QXihT5kFPTHeKicvWG7qIWToAKTPwTT+lmVQhUpmLv+m1PqC
 Tp5r/UjUS0jJSSMA+1YL5gwd7aDqSJH3zKZdXIthGhkhBq4O/6
 okxoYxjUcHkEYGVyYBhFHDPy25A9PuGb1HuV0b89d4pXXkrh06
 fI/d6qjeeynfy/xMokpE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 September 2012, Vinod Koul wrote:
> > where the first one is called by the other two, depending on the bus type.
> > This could be done either splitting the driver into multiple files so you can
> > have the platform and pci parts in separate driver modules depending on the
> > common module that does all the actual work, or everything can be put in
> > a single file with an #ifdef CONFIG_PCI to disable the pci driver parts
> > when they don't apply.
>
> probe wont be called if PCI device is not loaded, so see no reason why
> CONFIG_xxx would be needed

I assumed that you could not have a call to pci_register_driver with
CONFIG_PCI disabled. It seems that the function is stubbed out, so
you're probably right that we can do it even without the #ifdef.

	Arnd
