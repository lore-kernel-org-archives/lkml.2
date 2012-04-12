Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964974Ab2DLC2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 22:28:21 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:58653 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934134Ab2DLC2T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 22:28:19 -0400
MIME-Version: 1.0
In-Reply-To: <20120412010804.GI6589@ZenIV.linux.org.uk>
References: <4F80892A.7050104@zytor.com> <20120407202056.472d8ad9@pyramind.ukuu.org.uk>
 <da8cd76d-6116-44a9-a7b3-7a501cb3a8a9@email.android.com> <20120407212705.GD11295@thunk.org>
 <4F80B9AC.2010103@zytor.com> <CAPXgP12Zp7aHev8Sh=3W0zHA-vZoR9TpTW8c7ep9vTQQQScBPg@mail.gmail.com>
 <4F81D254.9090000@zytor.com> <CAPXgP10-_kS7VtdWonBhOxKJD2KatB9SznZ_xUUaxBz7-boT2A@mail.gmail.com>
 <20120412010804.GI6589@ZenIV.linux.org.uk>
From: Kay Sievers <kay@vrfy.org>
Date: Thu, 12 Apr 2012 04:27:55 +0200
Message-ID: <CAPXgP13zqFMTsndaW3YVZEA=aKMGsG-nO+i8k9frmSAzUNyrzA@mail.gmail.com>
Subject: Re: RFC: deprecating/removing the legacy mode of devpts
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Ted Ts'o" <tytso@mit.edu>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Greg Kroah-Hartman <gregkh@linux-foundation.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 03:08, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sun, Apr 08, 2012 at 09:16:22PM +0200, Kay Sievers wrote:
>
>> I guess the following:
>>   - remove the 'ptmx' cdev from drivers/tty/pty.c
>>   - add a new devtmpfs_create_link() to drivers/base/devtmpfs.c
>>   - call devtmpfs_create_link() from _init in fs/devpts/inode.c
>>   - change the default of ptxmode=0 to a sane default = 0666
>>   - get rid of the (rather broken) idea of 'legacy' vs 'non-legacy mode'
>>     mount options in the default setup; I don't think userspace should
>>     ever be required to fiddle with such stuff
>
> You do realize that there are people with _static_ /dev out there, don't
> you?  As well as those of us who are not using your latest and greatest
> udev and not enabling devtmpfs at all.  Not all world is Fedora...

Yeah, and? The dev_t still works from the static /dev/ like it didi 10
years ago. All good.

Not all breaks when I talk about it. :)

Kay
