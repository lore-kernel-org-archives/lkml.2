Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924Ab2EUNka (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 09:40:30 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57036 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501Ab2EUNk2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 09:40:28 -0400
MIME-Version: 1.0
In-Reply-To: <CAFub=KSmCj9EryT8p6m6KvSPQxBcuaHAXRiVeFbvBYYndPORHg@mail.gmail.com>
References: <CAFub=KS1_Bj=b2OVTf33VHtQ7BKY2k3Wd1oGwmVVJNgbexZ=6w@mail.gmail.com>
 <CAB=NE6VFghHT6zvGfW+9-Vsik39A_4Df=U3J1OtFFpM8LKDzvw@mail.gmail.com> <CAFub=KSmCj9EryT8p6m6KvSPQxBcuaHAXRiVeFbvBYYndPORHg@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Mon, 21 May 2012 06:40:05 -0700
X-Google-Sender-Auth: HaYU2OxKAvVpifKxQ9tlpMF97WU
Message-ID: <CAB=NE6X7ptSxB8aDW9boYqWDgTKpc8HuyJhN2UtHnW1CffVQbQ@mail.gmail.com>
Subject: Re: [Lf_driver_backport] scripts in compat tree
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
        lf_driver_backport@lists.linux-foundation.org,
        linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 6:15 AM, Ozan Çağlayan <ozancag@gmail.com> wrote:
>> Well kernel.org does not have already built kernels. Ubuntu's PPA
>> kernels *are* vanilla kernels, in fact that is why they were put up,
>> they are guaranteed to be built on vanilla kernels. We couldn't get a
>> more generic approach then. The only thing though is -- the PPA
>> kernels obviously have the kernels integrated on .debs. There are a
>> few options here:
>>
>>  1) If Ubuntu can dpkg -x the kernels for us onto tarballs that'd be swell
>>  2) We could write our own script to do this with C code that does
>> the dpkg -x for us
>>
>> There are ways to do 2) suggested in the thread above.
>
> ah you are right, we need to have built kernels in order to build the
> modules. Well then the 2nd solution seems reasonable if we can mimic
> dpkg -x. I googled a bit and people says that debs are generic .ar
> archives so it would be easy to take the tarball inside of them.
>
> If I succeed this can be used on any distro since that they are
> vanilla without any patches. But if the PPA disappears one day, we'll
> have to find another solution :)

Indeed :) the PPA must not seize to exist! Or something.

> BTW you also download the kernel images probably for booting into them
> to test the compat builds. Booting using those images on other
> distributions can be messy and unsuccessful as initramfs and booting
> mechanisms differ widely. I'll test those too.

Yeap... indeed. Mandrake for example loves to compress their modules.
compat-wireless handles the initramfs I think well, so *if* you do
want to address that, you could look at how we address initramfs
there, but I frankly don't think having this option available for all
distributions is a requirement. It'd be nice, but I think it'd be
nicer if ckmake itself could run for all options without root
privileges. So for example right now ckmake does require privileges to
install the debs, it'd be nicer if instead we just unload the kernels
to a $USER/ dir somewhere that ckmake has rights to under the user
calling it. In this case I'd be willing to remove the option to even
boot into these kernels.

 Luis
