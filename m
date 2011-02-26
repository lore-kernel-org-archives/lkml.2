Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629Ab1BZXeP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 18:34:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:32982 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087Ab1BZXeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 18:34:13 -0500
Message-ID: <4D698DF1.7060303@suse.com>
Date: Sat, 26 Feb 2011 18:34:09 -0500
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Roman Zippel <zippel@linux-m68k.org>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Add ``cloneconfig'' target
References: <4D671556.80607@suse.com>	<20110225060706.GA12723@merkur.ravnborg.org>	<AANLkTimFd+KFKgiOF8iVoM8Pk77Zy+5CsFs5BCYqCw=L@mail.gmail.com>	<AANLkTimTm40Sp5-kMaL4d1oXf3CzytZsBCus3DN0jwD-@mail.gmail.com> <AANLkTi=bJRh=0N6wP3LJWTQHSXsX4xdE7oOzK0CFcTfc@mail.gmail.com>
In-Reply-To: <AANLkTi=bJRh=0N6wP3LJWTQHSXsX4xdE7oOzK0CFcTfc@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 02/26/2011 05:57 PM, Arnaud Lacombe wrote:
> Hi,
> 
> On Sat, Feb 26, 2011 at 5:47 PM, Miguel Ojeda
> <miguel.ojeda.sandonis@gmail.com> wrote:
>> On Sat, Feb 26, 2011 at 8:47 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
>>> Why ? Thing should be kept simple. kconfig's job is not to know about
>>> the trillion file format which exist in the world, even more if the
>>> implementation is made by building a command[0], executing it in a
>>> separate process and reading the output. This is the shell's job. What
>>> may be useful in the contrary would be to eventually teach kconfig to
>>> read from <stdin>.
>>
>> /proc/config.gz is provided by the kernel and its format is defined by
>> kconfig itself which is, as well, part of the kernel (it is not one
>> random format from a pool of a trillion), so it will be nice if
>> kconfig learns how to read its own configuration from there.
>>
> your point being ? kconfig is not only used by the Linux kernel, and
> you cannot expect the feature to only be used in the cozy Linux kernel
> environment.

But this argument isn't really relevant. As with all of the other files
listed in the defconfig_list, if it's missing (or can't be read), it
will move on to the next one. Decompressing it first just makes things
/more/ confusing since the initial message of 'defaults read from...'
will read the name of the decompressed temporary file, not the source.
It makes more sense to see it as "reading defaults from /proc/config.gz
since that's obvious to anyone with kernel experience.

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAk1pjfEACgkQLPWxlyuTD7Ki0wCfU8KrumyxlD+qTFajlhc1eHOn
rMoAn0PqPyBYhBWlFTBT8YaL8/MWjw1J
=PVwv
-----END PGP SIGNATURE-----
