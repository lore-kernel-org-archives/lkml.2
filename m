Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934074Ab0EDU0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 16:26:44 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:60852 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933865Ab0EDU0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 16:26:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@linux.intel.com>
Subject: Re: possible locking bug in tty_open
Date: Tue, 4 May 2010 22:26:25 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.34-rc6-00090-g1509e54-dirty; KDE/4.4.2; x86_64; ; )
Cc: lkml <linux-kernel@vger.kernel.org>, "Greg Kroah-Hartman" <gregkh@suse.de>
References: <201005022247.33857.arnd@arndb.de> <20100504204236.5dc6a34e@linux.intel.com>
In-Reply-To: <20100504204236.5dc6a34e@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005042226.26030.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX196xd/gOsSkxGLwjX6L0C1iMIWwO9W8PmVLqof
 JFQEioUWS94h+YzS0PN1fRRK/1bkScyc+ZHKcYPdxFRXbLzHYJ
 /QEizVV2zXpsoGDy/27PA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 May 2010 21:42:36 Alan Cox wrote:
> On Sun, 2 May 2010 22:47:33 +0200
> Arnd Bergmann <arnd@arndb.de> wrote:

> > After the "retry_open:" label, we first get the tty_mutex
> > and then the BKL. However a the end of tty_open, we jump
> > back to retry_open with the BKL still held. If we run into
> > this case, the tty_open function will be left with the BKL
> > still held.

> I think all we need is probably this
> 
> tty: Fix unbalanced BKL handling in error path
>     
> Arnd noted:
>     
> After the "retry_open:" label, we first get the tty_mutex
> and then the BKL. However a the end of tty_open, we jump
> back to retry_open with the BKL still held. If we run into
> this case, the tty_open function will be left with the BKL
> still held.

Yes, looks good.

>     
> Signed-off-by: Alan Cox <alan@linux.intel.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
