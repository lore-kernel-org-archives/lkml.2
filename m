Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab0ITLTo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 07:19:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58478 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755365Ab0ITLTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 07:19:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: New compat_alloc_user_space() GPLness and fglrx
Date: Mon, 20 Sep 2010 13:19:40 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@suse.de>
References: <20100918014232.GA17699@khazad-dum.debian.net> <201009181026.58002.arnd@arndb.de> <20100918124214.GA31802@khazad-dum.debian.net>
In-Reply-To: <20100918124214.GA31802@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009201319.40563.arnd@arndb.de>
X-Provags-ID: V02:K0:hpcatKJ91mYG6ZsnxxXW5WY+ags8iY8XxRyGJ7PqxC0
 LhnbOdzWLIRdLaMfsVWXzN1aa715dhU/0ctdWiqQTorq3WfPrU
 W28u+9tnCfWbSWur8yQb/MfBf6onQqpFMkc7wsHEZk/1iT6MAR
 4o6AHZlInQ91nJroLOWrUVjZfXDWZ9yA/WiNNHx8hOXAoOAtzU
 of+oQMM9znkKXw17NjYjw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 18 September 2010, Henrique de Moraes Holschuh wrote:
> Well, that means ATI needs to mess with the insides of their binary
> blob... Anyone knows of a channel to talk to them?  Someone must tell
> them about this, I am just an unwilling user of fglrx (R600 support in
> the open drivers is nowhere near what I need yet).
> 
> Meanwhile, what is the solution?  Keep using (the newly named)
> arch_compat_alloc_user_space()?

Since you don't know how that is used in the driver, that could
very well keep the security hole open as long as the driver is loaded.

You still have the obvious options that you won't like:

1. stay on an older (broken) kernel
2. don't use fglrx until this is fixed
3. copy the new compat_alloc_user_space as an inline function
   into the wrapper module (possibly making it undistributable)

	Arnd
