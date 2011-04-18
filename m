Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862Ab1DRCes (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 22:34:48 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:56011 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab1DRCen convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 22:34:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=oJiPzYNIgqX5B9Vz64J/ENvlMfgXD5XNh9nJSr9dehHQ4V0uBcFaZVKH7UkdlLt9ck
         vJUhGd2386rMzj0REQPZhsEOc0z2plKnj8mdAaucz7Vkm7l1SufMuscFus8MNgrLThnP
         PtQe2uGtM6L9dVu2dpqtXlGWOtiCqTv7g8NC0=
MIME-Version: 1.0
In-Reply-To: <201104172311.59289.rjw@sisk.pl>
References: <201103280125.11750.rjw@sisk.pl> <201104172301.54115.rjw@sisk.pl> <201104172311.59289.rjw@sisk.pl>
From: Mike Frysinger <vapier@gentoo.org>
Date: Sun, 17 Apr 2011 22:34:22 -0400
X-Google-Sender-Auth: _AzKcBj4vVVO0xSeUKYJZUtBD8w
Message-ID: <BANLkTi=BRXtsG0wK6SbK-6L-xzwMccR3eQ@mail.gmail.com>
Subject: Re: [PATCH 9/14] PM / Blackfin: Use struct syscore_ops instead of
 sysdevs for PM
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
        Kay Sievers <kay.sievers@suse.de>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        Kevin Hilman <khilman@ti.com>, linux-arm-kernel@lists.infradead.org,
        Ben Dooks <ben-linux@fluff.org>, Ralf Baechle <ralf@linux-mips.org>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, Jiri Kosina <jkosina@suse.cz>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 17, 2011 at 17:11, Rafael J. Wysocki wrote:
> Convert some Blackfin architecture's code to using struct syscore_ops
> objects for power management instead of sysdev classes and sysdevs.
>
> This simplifies the code and reduces the kernel's memory footprint.
> It also is necessary for removing sysdevs from the kernel entirely in
> the future.

looks straight forward enough ...
Acked-by: Mike Frysinger <vapier@gentoo.org>

> +static struct syscore_ops nmi_syscore_ops = {
>        .resume         = nmi_wdt_resume,
>        .suspend        = nmi_wdt_suspend,
>  };

a bit sad this couldnt be made const
-mike
