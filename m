Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab2DHSBK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 14:01:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59512 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754460Ab2DHSBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 14:01:09 -0400
Message-ID: <4F81D254.9090000@zytor.com>
Date: Sun, 08 Apr 2012 11:00:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Kay Sievers <kay@vrfy.org>
CC: "Ted Ts'o" <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Greg Kroah-Hartman <gregkh@linux-foundation.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: Re: RFC: deprecating/removing the legacy mode of devpts
References: <4F80892A.7050104@zytor.com> <20120407202056.472d8ad9@pyramind.ukuu.org.uk> <da8cd76d-6116-44a9-a7b3-7a501cb3a8a9@email.android.com> <20120407212705.GD11295@thunk.org> <4F80B9AC.2010103@zytor.com> <CAPXgP12Zp7aHev8Sh=3W0zHA-vZoR9TpTW8c7ep9vTQQQScBPg@mail.gmail.com>
In-Reply-To: <CAPXgP12Zp7aHev8Sh=3W0zHA-vZoR9TpTW8c7ep9vTQQQScBPg@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2012 12:30 AM, Kay Sievers wrote:
> 
> I don't think it has much to do with udev, it follows 100%
> instructions from the kernel, and it does not create the device node
> that is in the way here.
> 
> Udev does not name any device in the system since a long time. Since
> quite a while it has not even the code to do mknod() and requires
> devtmpfs. The device node part of udev these day is limited to manage
> device node permissions and creating additional symlinks. All device
> node creation happens inside the kernel itself - where it belongs -
> and not in userspace.
> 
> If the default behaviour of /dev/pts/* should be changed, the kernel
> should be changed to support the multi-instance mode right away
> without involving userspace. We better do not require userspace to
> gain any knowledge about such stuff. I'm confident, that we should not
> add more, or require to support multiple alternative ways of handling
> kernel internals in userspace.
> 
> So, I think we either remove the '/sys/class/tty/ptmx' device from the
> system, and let the devpts code create the symlink in the 'devtmpfs'
> filesystem, or alternatively the '/sys/class/tty/ptmx' device supports
> the multi-instance mode itself, instead of requiring a symlink. Such
> stuff belongs entirely into the kernel these day. Anything else seems
> to just ask for trouble.
> 

OK, this seems very reasonable, and something that could (and probably
*has to*) be done as an atomic change... maybe.

There is no way for /dev/ptmx to support the multiinstance mode since it
is located outside any devpts filesystem; it *has* to be inside the
devpts filesystem in order to function... if that wasn't the case this
whole thing would have been trivial from the get-go.

Greg, do you have any insights in what would have to be necessary
mechanics to make this.

	-hpa

