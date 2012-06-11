Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab2FKMmi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 08:42:38 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:65477 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390Ab2FKMmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 08:42:37 -0400
Message-ID: <4FD5E7B8.1020502@suse.cz>
Date: Mon, 11 Jun 2012 14:42:32 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120530 Thunderbird/13.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Paul Bolle <pebolle@tiscali.nl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] delete seven tty headers
References: <1339145808.25798.28.camel@x61.thuisdomein> <4FD1DB30.80307@suse.cz> <1339155706.25798.55.camel@x61.thuisdomein> <201206081403.16608.arnd@arndb.de>
In-Reply-To: <201206081403.16608.arnd@arndb.de>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2012 04:03 PM, Arnd Bergmann wrote:
> I think we should just apply the patches the way you sent them. We are
> in the much stricter about binary compatibility than about source level
> compatibility, and we already broke any potential user space applications
> that might be using these headers by removing the drivers implementing
> the kernel side of them, after deciding that they were unused!

Yes, but this patch is about breaking builds of toolkits. Some of the
tools from such toolkits still might work without the removed drivers.

> Building user space code against new kernel headers to run on old
> kernels is not really supported, because that might rely on new interfaces
> to be present. The only reason to keep the headers around would be to
> keep broken user space code building. I would not expect such code to
> still exist for the two header files, and if it does, then giving
> it an extra six months before it needs to be fixed is not going to
> make much of a difference.

I agree (I wrote I doubt there are any users at all). But I would prefer
going through the deprecation phase (adding a #warning) anyway. Removing
the headers completely in a year, or maybe sooner is OK then.

> OTOH, if it turns out that a modern distro still contains a package
> that relies on these headers, I would advocate putting a minimal
> header file with a #warning back into the kernel.

I think this is too late. Distros would find this out after months and
there will be no reason to re-add empty headers and backport them to
stable trees in between at that time...

> The only reference I could find on the internet to the ioctl commands
> that are getting removed is in the FreeBSD "stallion" user space,
> and they ditched the driver four years ago:
> http://lists.freebsd.org/pipermail/freebsd-questions/2008-April/173526.html

I wish google codesearch was not abandoned...

thanks,
-- 
js
suse labs


