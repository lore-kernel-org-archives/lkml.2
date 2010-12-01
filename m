Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651Ab0LATe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 14:34:28 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37210 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399Ab0LATe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 14:34:27 -0500
MIME-Version: 1.0
In-Reply-To: <4CF692D1.1010906@redhat.com>
References: <20101107194547.GA12521@basil.fritz.box> <4CD71C8B.1050604@redhat.com>
 <20101107230508.GB17592@basil.fritz.box> <20101108145809.GD29714@redhat.com>
 <1289238930-sup-9765@think> <20101114205925.GA20451@redhat.com>
 <AANLkTi=rVyozmvqCJD1kGqnV3uEn-0ak6B12-O_9XOKJ@mail.gmail.com>
 <4CE05A9E.9090204@redhat.com> <AANLkTimT0t3xqgKdAn7MBPD7ED-9uPS+WJE0z+K8tciu@mail.gmail.com>
 <AANLkTik_p0yxQBQ3ehHWYPLfiqxGbSNUT5XUk9dC5-x6@mail.gmail.com>
 <20101201165229.GC13415@redhat.com> <AANLkTinG209iRAXgpNC0vNpn1C02wkYmVfveXRBqsKV-@mail.gmail.com>
 <4CF692D1.1010906@redhat.com>
From: Jon Nelson <jnelson@jamponi.net>
Date: Wed, 1 Dec 2010 13:34:05 -0600
Message-ID: <AANLkTimA2PPXZoOHYgeOEV2ocrojeuBby8MYDYJ1yjx1@mail.gmail.com>
Subject: Re: dm-crypt barrier support is effective
To: Milan Broz <mbroz@redhat.com>
Cc: Matt <jackdachef@gmail.com>, Mike Snitzer <snitzer@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        dm-devel <dm-devel@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        htd <htd@fancy-poultry.org>, Chris Mason <chris.mason@oracle.com>,
        htejun@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 1, 2010 at 12:24 PM, Milan Broz <mbroz@redhat.com> wrote:
> On 12/01/2010 06:35 PM, Matt wrote:
>> Thanks for pointing to v6 ! I hadn't noticed that there was a new one :)
>>
>> Well, so I'll restore my box to a working/productive state and will
>> try out v6 (I'm pretty confident that it'll work without problems).
>
> It's the same as previous, just with fixed header (to track it properly
> in patchwork) , second patch adds some read optimisation, nothing what
> should help here.
>
> Anyway, I run several tests on 2.6.37-rc3+ and see no integrity
> problems (using xfs,ext3 and ext4 over dmcrypt).
>
> So please try to check which change causes these problems for you,
> it can be something completely unrelated to these patches.
>
> (If if anyone know how to trigger some corruption with btrfs/dmcrypt,
> let me know I am not able to reproduce it either.)

Perhaps this is useful: for myself, I found that when I started using
2.6.37rc3 that postgresql starting having a *lot* of problems with
corruption. Specifically, I noted zeroed pages, corruption in headers,
all sorts of stuff on /newly created/ tables, especially during index
creation. I had a fairly high hit rate of failure. I backed off to
2.6.34.7 and have *zero* problems (in fact, prior to 2.6.37rc3, I had
never had a corruption issue with postgresql). I ran on 2.6.36 for a
few weeks as well, without issue.

I am using kcrypt with lvm on top of that, and ext4 on top of that.

-- 
Jon
