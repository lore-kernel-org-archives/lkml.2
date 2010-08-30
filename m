Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844Ab0H3QJV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 12:09:21 -0400
Received: from m209-5.dsl.rawbw.com ([198.144.209.5]:44151 "EHLO
	kyoto.noir.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753475Ab0H3QJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 12:09:20 -0400
X-Greylist: delayed 575 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Aug 2010 12:09:19 EDT
Message-ID: <4C7BD569.9000702@noir.com>
Date: Mon, 30 Aug 2010 08:59:37 -0700
From: "K. Richard Pixley" <rich@noir.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.8) Gecko/20100802 Lightning/1.0b2 Thunderbird/3.1.2
MIME-Version: 1.0
To: Josef Bacik <josef@redhat.com>
CC: Tomasz Chmielewski <mangoo@wpkg.org>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, hch@infradead.org, gg.mariotti@gmail.com,
        "Justin P. Mattock" <justinmattock@gmail.com>, mjt@tls.msk.ru,
        tytso@mit.edu
Subject: Re: BTRFS: Unbelievably slow with kvm/qemu
References: <4C7AB645.5090804@wpkg.org> <20100830001441.GA838@dhcp231-156.rdu.redhat.com>
In-Reply-To: <20100830001441.GA838@dhcp231-156.rdu.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 8/29/10 17:14 , Josef Bacik wrote:
> On Sun, Aug 29, 2010 at 09:34:29PM +0200, Tomasz Chmielewski wrote:
>> Christoph Hellwig wrote:
>>> There are a lot of variables when using qemu.
>>>
>>> The most important one are:
>>>
>>>   - the cache mode on the device.  The default is cache=writethrough,
>>>     which is not quite optimal.  You generally do want to use cache=none
>>>     which uses O_DIRECT in qemu.
>>>   - if the backing image is sparse or not.
>>>   - if you use barrier - both in the host and the guest.
>> I noticed that when btrfs is mounted with default options, when writing
>> i.e. 10 GB on the KVM guest using qcow2 image, 20 GB are written on the
>> host (as measured with "iostat -m -p").
>>
>> With ext4 (or btrfs mounted with nodatacow), 10 GB write on a guest
>> produces 10 GB write on the host
> Whoa 20gb?  That doesn't sound right, COW should just mean we get quite a bit of
> fragmentation, not write everything twice.  What exactly is qemu doing?  Thanks,
Make sure you build your file system with "mkfs.btrfs -m single -d 
single /dev/whatever".  You may well be writing duplicate copies of 
everything.

--rich
