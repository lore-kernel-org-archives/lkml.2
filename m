Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab1KCWqR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 18:46:17 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33589 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471Ab1KCWqQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 18:46:16 -0400
MIME-Version: 1.0
In-Reply-To: <1319144425-15547-7-git-send-email-Kyle.D.Moffett@boeing.com>
References: <1319144425-15547-1-git-send-email-Kyle.D.Moffett@boeing.com>
	<1319144425-15547-7-git-send-email-Kyle.D.Moffett@boeing.com>
Date: Thu, 3 Nov 2011 17:46:15 -0500
Message-ID: <CAKWjMd5pDvHKVJeEBhT12bH8C7Q=7TuaFtBNuij-4YRGMrjtdA@mail.gmail.com>
Subject: Re: [RFC PATCH 06/17] phy_driver: Add and use phy_driver_[un]register_multiple()
From: Andy Fleming <afleming@gmail.com>
To: Kyle Moffett <Kyle.D.Moffett@boeing.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@conan.davemloft.net>,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        David Daney <ddaney@caviumnetworks.com>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Baruch Siach <baruch@tkos.co.il>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 4:00 PM, Kyle Moffett <Kyle.D.Moffett@boeing.com> wrote:
> Several of the PHY drivers are registering dozens of "phy_driver"
> structures at load-time, with different IDs and variations on methods.
> As a result, the error handling is exceptionally ugly.
>
> The "marvell" driver already uses an array of "struct phy_driver" and
> iterates over that to add the drivers, but even then its error handling
> contains a bug (it will not unregister array item 0 on failure).
>
> To resolve these problems, new functions phy_driver_register_multiple()
> and phy_driver_unregister_multiple() are added which take an array and a
> number of drivers and iterate over them internally.
>
> All of the PHY driver files which register more than one "phy_driver"
> are modified to use the new helpers.  This is a sizable net removal of
> about 260 lines of code.
>
> Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>

Let's try that again, sending to the list.

This is excellent!

Very much
Acked-by: Andy Fleming <afleming@freescale.com>
