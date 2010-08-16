Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab0HPHSD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 03:18:03 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58931 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab0HPHSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 03:18:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: piotr@hosowicz.com
Subject: Re: ioctl definition - has it changed recently?
Date: Mon, 16 Aug 2010 09:17:22 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc4-next-20100709+; KDE/4.4.92; x86_64; ; )
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
References: <4C67023D.6050603@example.com> <201008160858.42947.arnd@arndb.de> <4C68E4A5.3050800@example.com>
In-Reply-To: <4C68E4A5.3050800@example.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201008160917.23260.arnd@arndb.de>
X-Provags-ID: V02:K0:jMYn8+nn7LWWcoNnWdtxrh2fHdDKNG6nbdYco/JEP3l
 +xDpqucg/V8bKrcSGi6bnlgLOVche2fO0MMZSI9yGUWYVnNDS1
 XuHeMr+mQ+jYuzYEMxpIq9IdGKeNadKbv4KxVAgaXMjzI/XA26
 tW0pgFeeNCdnZsV7wqsX2+1ZXwMg2jnzDeuqKACpsSfHtrU0U9
 JJ4hEr2TrJKWedISMMiLw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 August 2010 09:11:33 Piotr Hosowicz wrote:
> > and then make it use the unlocked_ioctl operation.
> 
> This I do not know. Can You help me?
> 

Just take a look at all the other patches that went into the
kernel to do this for other drivers. You only really
need to change the line with .ioctl=... to .unlocked_ioctl=
and change the prototype of the referenced function to

static long foo_ioctl(struct file *file, unsigned int cmd, unsigned long arg)

	Arnd
