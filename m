Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab1FAWLP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 18:11:15 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:48226 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab1FAWLM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 18:11:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hELjl39OldANBgPZNYSQgvwv9B5ZafgT6JXtFQUkms4uiH61T7tAaSG5Kq9CwDmraC
         pRI86ZttullNssp986dIkZnjsiVHkH9N4mrzEFsJYaiuX3VrYQCQJcyIL3jLT4XCmQg/
         6Y3aBfx4/OZCQjxUnQM4Mz9gUpLp/ELc/vcFc=
MIME-Version: 1.0
In-Reply-To: <20110529065818.GA2122@elf.ucw.cz>
References: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>
	<20110518172552.6d482c7a.akpm@linux-foundation.org>
	<20110526060842.GA13933@localhost.ucw.cz>
	<4DDE80FE.7010005@schaufler-ca.com>
	<1306433514.24986.26.camel@localhost.localdomain>
	<20110526183849.GA4563@ucw.cz>
	<1306439347.3092.89.camel@localhost.localdomain>
	<20110526201725.GC15959@elf.ucw.cz>
	<1306518351.24986.102.camel@localhost.localdomain>
	<20110529065818.GA2122@elf.ucw.cz>
Date: Thu, 2 Jun 2011 01:11:11 +0300
Message-ID: <BANLkTingqy+C9xOoQb6R8XqO0GfvAjBH-A@mail.gmail.com>
Subject: Re: [PATCH v5 00/21] EVM
From: Dmitry Kasatkin <dmitry.s.kasatkin@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: David Safford <safford@watson.ibm.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        Greg KH <greg@kroah.com>, Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reposted in plain text..

On Sun, May 29, 2011 at 9:58 AM, Pavel Machek <pavel@ucw.cz> wrote:
>
> chattr already protects authenticity of my files, as do standard unix
> permissions.
>
> So... where's the difference?
>

chattr only protects against runtime attacks.
That is Access Control feature - not integrity.

>                                                                Pavel
> (*) but it does not change anything.
>
> True; determined attacker could steal my cellphone, open it up,
> desolder the flash, and change attributes of the filesystem.
>
> But... the same determined attacker can also replace
> bootloader&kernel&filesystem -- that is in the same flash! -- with
> unlocked versions. So the argumentation is the same for locked down
> phone.
>

That is completely incorrect in respect to locked/protected devices.
Chain of trust starts from ROM.
Bootloader is authenticated by the ROM and that will not allow to boot
the device.
Next bootloader will authenticate the kernel and display the message
on the screen
if it has been tampered.
And the next, authentic kernel will enforce filesystem integrity
protection using EVM.

The important use case is not to lock down phone against yourself,
but to protect normal users against possibility to sell/give them devices with
not authentic software which could do different nasty things, like
stealing the data or spying.
