Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab1BZTrF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 14:47:05 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53119 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab1BZTrC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 14:47:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oLo3bD4u5Wf+ngB6j4jT0sflH+IpPTI/EI9zdR88m4+CXfKHNSj3sWNh4UxUAUNtQx
         /b1wg/AEvDmu2ulO3qYSYOGHZGrGuk3qk2AzRbUhdas6XQNZhOa8jlRpabiY2VkUs6Hw
         jn+Dz5OfQqaosbUXT7Z2VwZzvO+e0YSlVOY9o=
MIME-Version: 1.0
In-Reply-To: <20110225060706.GA12723@merkur.ravnborg.org>
References: <4D671556.80607@suse.com>
	<20110225060706.GA12723@merkur.ravnborg.org>
Date: Sat, 26 Feb 2011 14:47:01 -0500
Message-ID: <AANLkTimFd+KFKgiOF8iVoM8Pk77Zy+5CsFs5BCYqCw=L@mail.gmail.com>
Subject: Re: [PATCH] Add ``cloneconfig'' target
From: Arnaud Lacombe <lacombar@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jeff Mahoney <jeffm@suse.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Roman Zippel <zippel@linux-m68k.org>, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Feb 25, 2011 at 1:07 AM, Sam Ravnborg <sam@ravnborg.org> wrote:
> We already have something remotely similar in kconfig.
> We use the following list:
> config DEFCONFIG_LIST
>        string
>        depends on !UML
>        option defconfig_list
>        default "/lib/modules/$UNAME_RELEASE/.config"
>        default "/etc/kernel-config"
>        default "/boot/config-$UNAME_RELEASE"
>        default "$ARCH_DEFCONFIG"
>        default "arch/$ARCH/defconfig"
>
I may argue that anything within the Linux tree which point
_by_default_ to something outside the tree itself is broken. Say I try
to build a Linux kernel on a system with has its own non-kconfig
`/etc/kernel-config', I guess this would make the configuration fail.

> It would be better to teach kconfig to read /proc/config.gz
> and then add it to the list above.
>
Why ? Thing should be kept simple. kconfig's job is not to know about
the trillion file format which exist in the world, even more if the
implementation is made by building a command[0], executing it in a
separate process and reading the output. This is the shell's job. What
may be useful in the contrary would be to eventually teach kconfig to
read from <stdin>.

 - Arnaud

[0]: which is built depending on an extension, which is even more awful ...

> This list is used if you just type "make enuconfig" without
> any configuration.
>
>        Sam
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
