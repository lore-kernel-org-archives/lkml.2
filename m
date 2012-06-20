Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab2FTM52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 08:57:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54985 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552Ab2FTM51 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 08:57:27 -0400
MIME-Version: 1.0
In-Reply-To: <20120620080652.GA15937@ioremap.net>
References: <1339949879-26085-1-git-send-email-devendra.aaru@gmail.com>
	<20120620080652.GA15937@ioremap.net>
Date: Wed, 20 Jun 2012 18:27:26 +0530
Message-ID: <CAHdPZaMgqnbVH=A1g+qsEvt3VN7yqk13qTS-kHeqTY41wM9smQ@mail.gmail.com>
Subject: Re: [PATCH] drivers/w1: free the w1_master at w1_free_dev and return
 a correct return value
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Evgeniy,
On Wed, Jun 20, 2012 at 1:36 PM, Evgeniy Polyakov <zbr@ioremap.net> wrote:
> Hi
>
> On Sun, Jun 17, 2012 at 09:47:59PM +0530, Devendra Naga (devendra.aaru@gmail.com) wrote:
>> the w1_master pointer is allced at the w1_alloc_master and is not freed when called with
>> w1_remove_master.
>>
>> when w1_alloc_dev fails the return should be -ENODEV as it does
>> device_register, and that is the last case where that function
>> will fail.
>>
>> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
>
> Hmm, looks correct, but I wonder how whatever_free() function happend
> not to free its arguments.
>
I think , it its good to have the kfree after calling the w1_free_dev
as this way looks so wierd calling of kfree.
> Looks like device_unregister() calls release callback, but we do not
> provide one.
>
vim -t device_unregister points me to drivers/base/core.c
device_unregister function, where we do a device_del, where we do a
dev_release_all where it calls  release_nodes which calls the release
callback. is that what you are telling?

if so actually we are passing the structure w1_master_device which is
of struct device. its having a release callback. and there we free the
master device.

please suggest me if i mistaken....
> Greg, please pull it into your tree. Thank you.
> Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
>
> --
>        Evgeniy Polyakov

Thanks,
Devendra.
