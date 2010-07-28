Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab0G1OgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 10:36:14 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:53557 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882Ab0G1OgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 10:36:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=BeqMb54Ua2bsRqWZi1xtr9WFFfAImbQM1ICf3KJh9xEBSBSfGKcFK7NZs/JKub0yj9
         tvnuCsByLASREZstSfco3W23Kc4mGVHAq+JHds63gGV2OmB4wgoVSllyF9huCMUNwU+T
         iXrJSZZ/Vynf2ZuDFTp3fHOT4S6dhliYQM/w8=
MIME-Version: 1.0
In-Reply-To: <20100728135625.GA12916@kroah.com>
References: <AANLkTiniwW+r1G40QvA+oja=1YDkykNWRahHL4LuiCAU@mail.gmail.com>
	<AANLkTi=x0D_5yd7pWmYAcD2eeQN3HC9ecBXWEY-TpyYO@mail.gmail.com>
	<20100728135625.GA12916@kroah.com>
Date: Wed, 28 Jul 2010 22:36:12 +0800
Message-ID: <AANLkTinMA7j4hBET+qHjakh7YZG9U71oni+LYne7=2sC@mail.gmail.com>
Subject: Re: BUG: 'Unknown symbol in module' happens after reloading ehci-hcd 
	module
From: Ming Lei <tom.leiming@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-usb <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/28 Greg KH <greg@kroah.com>:
> On Wed, Jul 28, 2010 at 03:33:30PM +0800, Ming Lei wrote:
>> 2010/7/28 Ming Lei <tom.leiming@gmail.com>:
>> > Hi,
>> >
>> > 'Unknown symbol in module' ?happens after the actions below:
>> >
>> > ? ? ? ? rmmod ehci-hcd
>> > ? ? ? ? modprobe ehci-hcd
>> >
>>
>> The issue is caused by returning failure of debugfs_create_dir, and
>> which may be fixed by replacing debugfs_remove with
>> debugfs_remove_recursive in ehci_hcd_cleanup.
>
> Or we can properly clean up all of the files, right?
>
> Care to send a patch to resolve this?

Sent, follows the patch's title:

           USB: ehci: fix remove of ehci debugfs dir

thanks,

-- 
Lei Ming
