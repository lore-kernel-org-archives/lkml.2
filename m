Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab0H3ALf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 20:11:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313Ab0H3ALe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 20:11:34 -0400
Date: Sun, 29 Aug 2010 20:14:41 -0400
From: Josef Bacik <josef@redhat.com>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        hch@infradead.org, gg.mariotti@gmail.com,
        "Justin P. Mattock" <justinmattock@gmail.com>, mjt@tls.msk.ru,
        josef@redhat.com, tytso@mit.edu
Subject: Re: BTRFS: Unbelievably slow with kvm/qemu
Message-ID: <20100830001441.GA838@dhcp231-156.rdu.redhat.com>
References: <4C7AB645.5090804@wpkg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C7AB645.5090804@wpkg.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 29, 2010 at 09:34:29PM +0200, Tomasz Chmielewski wrote:
> Christoph Hellwig wrote:
>
>> There are a lot of variables when using qemu.
>>
>> The most important one are:
>>
>>  - the cache mode on the device.  The default is cache=writethrough,
>>    which is not quite optimal.  You generally do want to use cache=none
>>    which uses O_DIRECT in qemu.
>>  - if the backing image is sparse or not.
>>  - if you use barrier - both in the host and the guest.
>
> I noticed that when btrfs is mounted with default options, when writing  
> i.e. 10 GB on the KVM guest using qcow2 image, 20 GB are written on the  
> host (as measured with "iostat -m -p").
>
>
> With ext4 (or btrfs mounted with nodatacow), 10 GB write on a guest  
> produces 10 GB write on the host.
>

Whoa 20gb?  That doesn't sound right, COW should just mean we get quite a bit of
fragmentation, not write everything twice.  What exactly is qemu doing?  Thanks,

Josef
