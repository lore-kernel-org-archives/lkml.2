Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab1EHPJs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 11:09:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:65526 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585Ab1EHPJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 11:09:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: Re: [PATCH][WAS:bcmai,axi] bcma: add Broadcom specific AMBA bus driver
Date: Sun, 8 May 2011 17:06:12 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        b43-dev@lists.infradead.org, Greg KH <greg@kroah.com>,
        Michael =?utf-8?q?B=C3=BCsch?= <mb@bu3sch.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        George Kashperko <george@znau.edu.ua>,
        Arend van Spriel <arend@broadcom.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <rmk@arm.linux.org.uk>,
        Andy Botting <andy@andybotting.com>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1304632783-8781-1-git-send-email-zajec5@gmail.com> <BANLkTikjr0ZTNOu69F+iKhwufE9KKMg4Tg@mail.gmail.com> <BANLkTimGBNT4FkS4mO9ToLWft0bCEYcEgg@mail.gmail.com>
In-Reply-To: <BANLkTimGBNT4FkS4mO9ToLWft0bCEYcEgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201105081706.12449.arnd@arndb.de>
X-Provags-ID: V02:K0:rWIxbaDGyD6e4mOcIoqqw6eXg4nzR9wIUxG6UUIgK6a
 Jhx219o7hbSVEB8YldvHZUXDnjQfDsWLmhhEf2/DVOTUzW/VdK
 Nd39AketuaFnwJpnyRVhvBB0pFC6a6WtjrAGOKI5DhfsfiSleL
 r1okD6e5mCPVH3ZAJ6FqfaSNlHvn25eLcl2esIkHYLMPeWZpWu
 rP2fmefC9AuS961Gl79iQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 07 May 2011, Rafał Miłecki wrote:
> > Well, maybe. We call it only once, at init time. In any case we're
> > still waiting for Broadcom to clarify which cores are really used for
> > BCMA.
> 
> Arnd: did you have a look at defines at all?
> 
> Most of the defines have values in range 0x800 → 0x837. Converting
> this to array means loosing 0x800 u16 entries. We can not use 0x800
> offset, because there are also some defined between 0x000 and 0x800:
> #define BCMA_CORE_OOB_ROUTER           0x367   /* Out of band */
> #define BCMA_CORE_INVALID              0x700

I did not mean using the enum value as index, just make an array of
simple structs:

struct bcma_device_name {
	unsigned int id;
	const char *name;
};

struct bcma_device_name bcma_device_names = {
	{ BCMA_CORE_OOB_ROUTER, "Out of band router" },
	{ BCMA_CORE_INVALID,	"Invalid" },
	...
};

The data size for this should be way smaller than the code needed
to represent the whole function otherwise, and be more readable.

	Arnd

