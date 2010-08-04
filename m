Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611Ab0HDP3I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 11:29:08 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:62749 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab0HDP3G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 11:29:06 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTik=thmEH7b+wRGM=m9LA3kjmg-dZ_yv19-SotrM@mail.gmail.com>
References: <AANLkTim6Bn++JaspY0cbpLLvi=MYBLNgUhARwKQkoYpE@mail.gmail.com> 
	<1280887483-2979-2-git-send-email-wad@chromium.org> <20100804090049.GH5464@nb.net.home> 
	<AANLkTin8eVm=_pw_DgP2wJW9pE0LgugqfXJE8aVXiH6R@mail.gmail.com> 
	<AANLkTik=thmEH7b+wRGM=m9LA3kjmg-dZ_yv19-SotrM@mail.gmail.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 4 Aug 2010 17:28:47 +0200
Message-ID: <AANLkTikh3pGh5jpFZ-Petoizw7DQBXZUqk1pzrHXEjmV@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] genhd, efi: add efi partition metadata to 
	hd_structs
To: Will Drewry <wad@chromium.org>
Cc: Tejun Heo <tj@kernel.org>, Karel Zak <kzak@redhat.com>,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Jan Blunck <jblunck@suse.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 4, 2010 at 16:44, Will Drewry <wad@chromium.org> wrote:
> On Wed, Aug 4, 2010 at 5:14 AM, Kay Sievers <kay.sievers@vrfy.org> wrote:

>> But the only thing we are really interested in is the UUID, which,
>> like Tejun already suggested, we should probably store
>> format-independent, and have it always accessible. That way, we would
>> not need any type-specific parser, we just handle the normal DCE
>> format.
>
> I'll bump it out and make it the efi code generic-ify its uuid.  Out
> of curiousity, were you and Tejun thinking of keeping it as a 36 byte
> string or as the 16 byte packed value.  While less space efficient,
> I'd prefer the u8[36] as it avoids dealing with versioning when
> parsing the user-supplied string.  Instead, each partition type can
> properly unparse its uuids according to what they expect.

I think we should use the packed version, which is case-insensitive,
or at least normalize it to a defined case.

Kay
