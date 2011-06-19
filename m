Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab1FSL3C (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 07:29:02 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:53041 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430Ab1FSL27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 07:28:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 9/10 v2] Generic Watchdog Timer Driver
Date: Sun, 19 Jun 2011 13:28:40 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: Wim Van Sebroeck <wim@iguana.be>, LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
References: <20110618172727.GJ3441@infomag.iguana.be> <201106182117.49026.arnd@arndb.de> <20110619110141.1ac221f1@lxorguk.ukuu.org.uk>
In-Reply-To: <20110619110141.1ac221f1@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106191328.40602.arnd@arndb.de>
X-Provags-ID: V02:K0:z2bq/83KNUiTBBWJVqiwnPElHwBboeGzv4pfIfebS24
 6KWw/+HOVFsTlxmEz9b0CBgXWQX07H8cEYDYS30VBD3XP8rTlt
 dD0w81wWiTcvneFaXduWuvTSMCmKG51VrKwn2utmdmSVp+D1SF
 k87vjafXdkAbVxUL+w50FG8aJ3L8M4W9XJkZm/FpOZQ8n9vv76
 EL49YiXBdxt2HMfRpvdAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 19 June 2011 12:01:41 Alan Cox wrote:
> > Hmm, I'm not sure about this one. It does make the conversion
> > of existing drivers easier but doesn't encourage doing a good
> > job there.
> 
> It's not ultimately about conversion. A lot of watchdogs have interfaces
> that are not quite generic, extra requirements and custom interfaces. The
> ioctl interface is needed for that, not for conversions.

It's probably fine to have additional custom interfaces in some watchdogs
where needed, but do you think we also need to give drivers a way to
override the common ones?

If a driver has a different interpretation of a common command, I would
consider that a bug, not a driver specific extension. I would also
like to see the proper extensions easily visible, so we can create
new common interfaces in cases where multiple drivers have the same
requirement.

	Arnd
