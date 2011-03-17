Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719Ab1CQNyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 09:54:47 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:53851 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab1CQNyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 09:54:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Waldemar.Rymarkiewicz@tieto.com
Subject: Re: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Date: Thu, 17 Mar 2011 14:54:42 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1299766808-2535-1-git-send-email-waldemar.rymarkiewicz@tieto.com> <201103171407.58164.arnd@arndb.de> <99B09243E1A5DA4898CDD8B70011144810830AB18B@EXMB04.eu.tieto.com>
In-Reply-To: <99B09243E1A5DA4898CDD8B70011144810830AB18B@EXMB04.eu.tieto.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103171454.42838.arnd@arndb.de>
X-Provags-ID: V02:K0:hInXbPfTG3ABeU/pnW8O+d++acuLekelfhSY3XFN1bp
 9NfZMZKAAWIFJRPCu3NWxIOCTF3ULZXJMaC7Muwv+wBBKYilqd
 FR1YPF09Vh3OatmzOTdbeQ3qfe2dOv7ktjGqN9OqxovJ0jKIS1
 x5sN2cky/aalIX/+aMsGK3mXQmrjSc3xUk8ExpUFx2cXk+1FWY
 voCIm36XL+6xO7wdNy/Fw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 March 2011, Waldemar.Rymarkiewicz@tieto.com wrote:
> >This is not very different from opening the file descriptor in 
> >multiple processes, which you prevent using your logic.
> 
> but in the case when two independent applications try to open 
> my device I can't let the second to access. They obviously won't
> synch the access.

My point was that you don't need to worry.
 
> >You can of course argue that you try your best to prevent the 
> >race. Traditionally, e.g. on serial ports and the like, we 
> >don't do this but instead rely on user space synchronizing the 
> >access. What you have to make sure of course is that multiple 
> >threads calling read on the same file can never bring the 
> >kernel driver into an invalid state.
> 
> I assume, if an application shares the file pointer deliberately
> it have to sync the access. In other cases, the driver needs to
> secure it.

As I said, it's not important if you do it and it certainly doesn't
cause harm to prevent multiple open. It's just that generally
we don't care too much about this problem.

	Arnd
