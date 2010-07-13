Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425Ab0GMIyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 04:54:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30184 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581Ab0GMIx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 04:53:59 -0400
Message-ID: <4C3C299C.20306@redhat.com>
Date: Tue, 13 Jul 2010 10:53:48 +0200
From: Kevin Wolf <kwolf@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Josef Bacik <josef@redhat.com>
CC: Giangiacomo Mariotti <gg.mariotti@gmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Michael Tokarev <mjt@tls.msk.ru>, linux-kernel@vger.kernel.org,
        qemu-devel <qemu-devel@nongnu.org>
Subject: Re: [Qemu-devel] Re: BTRFS: Unbelievably slow with kvm/qemu
References: <AANLkTin1uF6WbVvxJ84oO1NKnCU-6VHrmWU1XFYTlqtp@mail.gmail.com>	<4C3ABF96.9070405@msgid.tls.msk.ru>	<AANLkTim7A9teJtk5c1jh2g6mDv07HAi72d5S6WveL8Gp@mail.gmail.com> <20100712134347.GB15754@dhcp231-156.rdu.redhat.com>
In-Reply-To: <20100712134347.GB15754@dhcp231-156.rdu.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 12.07.2010 15:43, schrieb Josef Bacik:
> On Mon, Jul 12, 2010 at 03:34:44PM +0200, Giangiacomo Mariotti wrote:
>> On Mon, Jul 12, 2010 at 9:09 AM, Michael Tokarev <mjt@tls.msk.ru> wrote:
>>>
>>> This looks quite similar to a problem with ext4 and O_SYNC which I
>>> reported earlier but no one cared to answer (or read?) - there:
>>> http://permalink.gmane.org/gmane.linux.file-systems/42758
>>> (sent to qemu-devel and linux-fsdevel lists - Cc'd too).  You can
>>> try a few other options, esp. cache=none and re-writing some guest
>>> files to verify.
>>>
>>> /mjt
>>>
>> Either way, changing to cache=none I suspect wouldn't tell me much,
>> because if it's as slow as before, it's still unusable and if instead
>> it's even slower, well it'd be even more unusable, so I wouldn't be
>> able to tell the difference. What I can say for certain is that with
>> the exact same virtual hd file, same options, same system, but on an
>> ext3 fs there's no problem at all, on a Btrfs is not just slower, it
>> takes ages.
>>
> 
> O_DIRECT support was just introduced recently, please try on the latest kernel
> with the normal settings (which IIRC uses O_DIRECT), that should make things
> suck alot less. 

IIUC, he uses the default cache option of qemu, which is
cache=writethrough and maps to O_DSYNC without O_DIRECT. O_DIRECT would
only be used for cache=none.

Kevin
