Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145Ab0HaVqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 17:46:53 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47886 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909Ab0HaVqv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 17:46:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=RTom53dvWpMfTx0qd78dCuPs6WskSRi7KWL/Gfggf13Lb9GsQTWGQOpxqz4V94F71g
         b3+KNquE0WX8v8pFvc0hiFsxpD3OImzuNPYtxiMOt57tPHlRXNFMd5Dve/13TbYPUC1l
         mgZoPbb8FYFjAgisRv1+6RGEuhzrxrX2X3LWo=
MIME-Version: 1.0
In-Reply-To: <4C7BD569.9000702@noir.com>
References: <4C7AB645.5090804@wpkg.org>
	<20100830001441.GA838@dhcp231-156.rdu.redhat.com>
	<4C7BD569.9000702@noir.com>
Date: Tue, 31 Aug 2010 14:46:49 -0700
X-Google-Sender-Auth: 1CAFWGynkwabrW5-MT1iX8dgfdQ
Message-ID: <AANLkTin-BZvqCChXEmsDfjhVmRmJLaoaudnuFL6EXZQx@mail.gmail.com>
Subject: Re: BTRFS: Unbelievably slow with kvm/qemu
From: Mike Fedyk <mfedyk@mikefedyk.com>
To: "K. Richard Pixley" <rich@noir.com>
Cc: Josef Bacik <josef@redhat.com>, Tomasz Chmielewski <mangoo@wpkg.org>,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        hch@infradead.org, gg.mariotti@gmail.com,
        "Justin P. Mattock" <justinmattock@gmail.com>, mjt@tls.msk.ru,
        tytso@mit.edu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 8:59 AM, K. Richard Pixley <rich@noir.com> wrote:
>  On 8/29/10 17:14 , Josef Bacik wrote:
>>
>> On Sun, Aug 29, 2010 at 09:34:29PM +0200, Tomasz Chmielewski wrote:
>>>
>>> Christoph Hellwig wrote:
>>>>
>>>> There are a lot of variables when using qemu.
>>>>
>>>> The most important one are:
>>>>
>>>>  - the cache mode on the device.  The default is cache=writethrough,
>>>>    which is not quite optimal.  You generally do want to use cache=none
>>>>    which uses O_DIRECT in qemu.
>>>>  - if the backing image is sparse or not.
>>>>  - if you use barrier - both in the host and the guest.
>>>
>>> I noticed that when btrfs is mounted with default options, when writing
>>> i.e. 10 GB on the KVM guest using qcow2 image, 20 GB are written on the
>>> host (as measured with "iostat -m -p").
>>>
>>> With ext4 (or btrfs mounted with nodatacow), 10 GB write on a guest
>>> produces 10 GB write on the host
>>
>> Whoa 20gb?  That doesn't sound right, COW should just mean we get quite a
>> bit of
>> fragmentation, not write everything twice.  What exactly is qemu doing?
>>  Thanks,
>
> Make sure you build your file system with "mkfs.btrfs -m single -d single
> /dev/whatever".  You may well be writing duplicate copies of everything.
>
There is little reason not to use duplicate metadata.  Only small
files (less than 2kb) get stored in the tree, so there should be no
worries about images being duplicated without data duplication set at
mkfs time.
