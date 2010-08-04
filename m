Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab0HDP5E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 11:57:04 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62822 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486Ab0HDP5B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 11:57:01 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTikh3pGh5jpFZ-Petoizw7DQBXZUqk1pzrHXEjmV@mail.gmail.com>
References: <AANLkTim6Bn++JaspY0cbpLLvi=MYBLNgUhARwKQkoYpE@mail.gmail.com>
	<1280887483-2979-2-git-send-email-wad@chromium.org>
	<20100804090049.GH5464@nb.net.home>
	<AANLkTin8eVm=_pw_DgP2wJW9pE0LgugqfXJE8aVXiH6R@mail.gmail.com>
	<AANLkTik=thmEH7b+wRGM=m9LA3kjmg-dZ_yv19-SotrM@mail.gmail.com>
	<AANLkTikh3pGh5jpFZ-Petoizw7DQBXZUqk1pzrHXEjmV@mail.gmail.com>
Date: Wed, 4 Aug 2010 10:56:59 -0500
Message-ID: <AANLkTi=b_zBigV8ePRPO1_qHpbMTALnCAV7v=dSTO5wc@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] genhd, efi: add efi partition metadata to 
	hd_structs
From: Will Drewry <wad@chromium.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Tejun Heo <tj@kernel.org>, Karel Zak <kzak@redhat.com>,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Jan Blunck <jblunck@suse.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 4, 2010 at 10:28 AM, Kay Sievers <kay.sievers@vrfy.org> wrote:
> On Wed, Aug 4, 2010 at 16:44, Will Drewry <wad@chromium.org> wrote:
>> On Wed, Aug 4, 2010 at 5:14 AM, Kay Sievers <kay.sievers@vrfy.org> wrote:
>
>>> But the only thing we are really interested in is the UUID, which,
>>> like Tejun already suggested, we should probably store
>>> format-independent, and have it always accessible. That way, we would
>>> not need any type-specific parser, we just handle the normal DCE
>>> format.
>>
>> I'll bump it out and make it the efi code generic-ify its uuid.  Out
>> of curiousity, were you and Tejun thinking of keeping it as a 36 byte
>> string or as the 16 byte packed value.  While less space efficient,
>> I'd prefer the u8[36] as it avoids dealing with versioning when
>> parsing the user-supplied string.  Instead, each partition type can
>> properly unparse its uuids according to what they expect.
>
> I think we should use the packed version, which is case-insensitive,
> or at least normalize it to a defined case.

Yeah, I'm all for tolower()ing the entire value instead of packing :)
, but looking at the uuid code quickly, and it seems that the only
real difference in ordering practically is big-endian versus little
endian.  Since sprintf supports converting both of those to strings,
it would make sense to just have a part_pack_uuid(char *uuid) which
will always do, let's say big endian, packing.  Then it won't be too
much work for the partition format to export the value either directly
to the right format or just via sprintf then pack.

I'll add a common packer/unpacker, and see how it looks.
