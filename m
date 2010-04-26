Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417Ab0DZNQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 09:16:22 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:59093 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab0DZNQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 09:16:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alessio Igor Bogani <abogani@texware.it>
Subject: Re: [PATCH] USB: sisusbvga: Remove the BKL from open
Date: Mon, 26 Apr 2010 15:15:56 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Oliver Neukum <oneukum@suse.de>, "Greg Kroah-Hartman" <gregkh@suse.de>,
       Thomas Winischhofer <thomas@winischhofer.net>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Pete Zaitcev <zaitcev@redhat.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Fr??d??ric Weisbecker" <fweisbec@gmail.com>
References: <1272191830-23675-1-git-send-email-abogani@texware.it> <201004261406.50107.oneukum@suse.de> <h2i63a49ef41004260530x49db3ddczf43423aa49f3b9e1@mail.gmail.com>
In-Reply-To: <h2i63a49ef41004260530x49db3ddczf43423aa49f3b9e1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201004261515.56750.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+nJI8R+uiWUVCYmtIVS4BHIkXN/nE0MgKslRs
 9hu62+gpHJ0B0zMKjZK8T4QwvV9DSyWL8uOA6pviW3pQkqtYCx
 EqqKQcB0K7ZFnWaVjBx6g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 April 2010, Alessio Igor Bogani wrote:
> 2010/4/26 Oliver Neukum <oneukum@suse.de>:
> > Am Sonntag, 25. April 2010 12:37:10 schrieb Alessio Igor Bogani:
> >> BKL is not needed here because necessary locking is already provided
> >> by mutex sisusb->lock.
> >
> > Have you checked the fb layer doesn't need it?
> 
> The _open and _release functions are already serialized with mutex in
> fb layer. So that mutex could be removed but in my opinion this job
> should be done in a separate patch (like I have done some time ago for
> nvidiafb driver). Now I would want suggest to remove BKL here only.

What about the BKL in the sisusb_ioctl()? It seems to follow the
same logic, so I would think that you can simply remove the BKL
from the module entirely, rather than only half of it.

	Arnd
