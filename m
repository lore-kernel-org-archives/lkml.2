Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab1DIHNJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 03:13:09 -0400
Received: from mail.academy.zt.ua ([82.207.120.245]:55555 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920Ab1DIHNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 03:13:06 -0400
X-MDAV-Processed: mail.academy.zt.ua, Sat, 09 Apr 2011 10:13:04 +0300
X-Spam-Processed: mail.academy.zt.ua, Sat, 09 Apr 2011 10:13:02 +0300
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: george@academy.zt.ua
X-Return-Path: george@znau.edu.ua
X-Envelope-From: george@znau.edu.ua
Subject: Re: [RFC][PATCH] bcmai: introduce AI driver
From: George Kashperko <george@znau.edu.ua>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        George Kashperko <george@znau.edu.ua>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <rmk@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <op.vtmqm7fw3ri7v4@arend-laptop>
References: <1302033463-1846-1-git-send-email-zajec5@gmail.com>
	 <op.vtisojsk3ri7v4@arend-laptop>
	 <BANLkTin1yyow595tcYveB5fh8q3x+U_GOw@mail.gmail.com>
	 <op.vtmqm7fw3ri7v4@arend-laptop>
Content-Type: text/plain; charset=utf-8
Date: Sat, 09 Apr 2011 10:10:26 +0300
Message-Id: <1302333026.18361.8.camel@dev.znau.edu.ua>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-19.el5) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Fri, 08 Apr 2011 18:56:13 +0200, Rafał Miłecki <zajec5@gmail.com> wrote:
> 
> > 2011/4/6 Arend van Spriel <arend@broadcom.com>:
> >> 3. Device identification
> >>
> >> The cores are identified by manufacturer, core id and revision in your
> >> patch. I would not use the revision because 4 out of 5 times a revision
> >> change does indicate a hardware change but no change in programming
> >> interface. The enumeration data does contain a more selective field
> >> indicating the core class (4 bits following the core identifier). I  
> >> suggest
> >> to replace the revision field by this class field.
> >
> > Could you say something more about *class*, please? For my BCM43224 it
> > seems to be 0x0. WIll check BCM4313 in a moment.
> >
> 
> In principal the manufacturer id is unique (defined/assigned by JEDEC  
> www.jedec.org) and the chip id and chip class are defined by the  
> manufacturer. So I can only indicate what classes Broadcom uses in  
> combination with the manufacturer id BRCM, ARM and MIPS.
> 
> /* Component Classes */
> #define	CC_SIM			0
> #define	CC_EROM			1
> #define	CC_CORESIGHT		9
> #define	CC_VERIF		0xb
> #define	CC_OPTIMO		0xd
> #define	CC_GEN			0xe
> #define	CC_PRIMECELL		0xf
> 
> Looking at this it seems strange that you see a class value of 0x0. It may  
> be rarely used or for non-production chips only (for simulation, chip  
> bringup) which may require additional (debug) functions. So question is  
> whether you will need it, but it is specified by ARM and it is up to  
> manufacturers to use it. So I it is better to be safe than sorry and have  
> this in the device id.
> 
> Gr. AvS
When parsing bcm4716 EROM I have
cia & CIA_CCL_MASK equal to 0 for all 9 cores

You mentioned ARM DMP (Device Management Plugin) several times in
earlier messages some time ago but I can't find anything relevant about
that at ARM infocenter. Any chance you can point more precise location
for any DMP reference?

Have nice day,
George



