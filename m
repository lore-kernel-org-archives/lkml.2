Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571Ab1BZWsB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 17:48:01 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51572 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab1BZWr5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 17:47:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iLcB2nEYIDEDGukYJwHDW0K9rq2jHPqbM5cuIM7BpK485tg4/LdW7Xs41zvzurksUf
         mXWqy2F37zRtRiy/iIxXao2KA4CWsl/In1L6BgwXCaavQABU67j4553HA+ry8h/hCfle
         y5Jp1WSsU3TCQMnn0868ABA9RDEcwfDnZjd5I=
MIME-Version: 1.0
In-Reply-To: <AANLkTimFd+KFKgiOF8iVoM8Pk77Zy+5CsFs5BCYqCw=L@mail.gmail.com>
References: <4D671556.80607@suse.com>
	<20110225060706.GA12723@merkur.ravnborg.org>
	<AANLkTimFd+KFKgiOF8iVoM8Pk77Zy+5CsFs5BCYqCw=L@mail.gmail.com>
Date: Sat, 26 Feb 2011 23:47:55 +0100
Message-ID: <AANLkTimTm40Sp5-kMaL4d1oXf3CzytZsBCus3DN0jwD-@mail.gmail.com>
Subject: Re: [PATCH] Add ``cloneconfig'' target
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Jeff Mahoney <jeffm@suse.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Roman Zippel <zippel@linux-m68k.org>, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Feb 26, 2011 at 8:47 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> Hi,
>
> On Fri, Feb 25, 2011 at 1:07 AM, Sam Ravnborg <sam@ravnborg.org> wrote:
>> We already have something remotely similar in kconfig.
>> We use the following list:
>> config DEFCONFIG_LIST
>>        string
>>        depends on !UML
>>        option defconfig_list
>>        default "/lib/modules/$UNAME_RELEASE/.config"
>>        default "/etc/kernel-config"
>>        default "/boot/config-$UNAME_RELEASE"
>>        default "$ARCH_DEFCONFIG"
>>        default "arch/$ARCH/defconfig"
>>
> I may argue that anything within the Linux tree which point
> _by_default_ to something outside the tree itself is broken. Say I try
> to build a Linux kernel on a system with has its own non-kconfig
> `/etc/kernel-config', I guess this would make the configuration fail.

It is true that it may be annoying/unexpected, but the most common use
case is to build the kernel in the same machine which will run it.

In addition, it does not make the configuration fail, you just get the
machine's configuration. If you typed "menuconfig" instead of
"oldconfig" it means that you didn't have any configuration at all in
the first place, so if you are building a kernel for some other
machine you will have to configure through all the options manually
anyway.

>
>> It would be better to teach kconfig to read /proc/config.gz
>> and then add it to the list above.
>>
> Why ? Thing should be kept simple. kconfig's job is not to know about
> the trillion file format which exist in the world, even more if the
> implementation is made by building a command[0], executing it in a
> separate process and reading the output. This is the shell's job. What
> may be useful in the contrary would be to eventually teach kconfig to
> read from <stdin>.

/proc/config.gz is provided by the kernel and its format is defined by
kconfig itself which is, as well, part of the kernel (it is not one
random format from a pool of a trillion), so it will be nice if
kconfig learns how to read its own configuration from there.

kconfig only knows about config files (one format). The fact that it's
gzipped its irrelevant, any reasonable machine capable of building the
kernel has gzip installed.

>
>  - Arnaud
>
> [0]: which is built depending on an extension, which is even more awful ...
>
>> This list is used if you just type "make enuconfig" without
>> any configuration.
>>
>>        Sam
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
