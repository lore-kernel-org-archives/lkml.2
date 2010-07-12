Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab0GLNky (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 09:40:54 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:34525 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430Ab0GLNkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 09:40:53 -0400
Message-ID: <4C3B1B62.3080900@msgid.tls.msk.ru>
Date: Mon, 12 Jul 2010 17:40:50 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Giangiacomo Mariotti <gg.mariotti@gmail.com>
CC: linux-kernel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>
Subject: Re: BTRFS: Unbelievably slow with kvm/qemu
References: <AANLkTin1uF6WbVvxJ84oO1NKnCU-6VHrmWU1XFYTlqtp@mail.gmail.com>	<4C3ABF96.9070405@msgid.tls.msk.ru> <AANLkTim7A9teJtk5c1jh2g6mDv07HAi72d5S6WveL8Gp@mail.gmail.com>
In-Reply-To: <AANLkTim7A9teJtk5c1jh2g6mDv07HAi72d5S6WveL8Gp@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Giangiacomo Mariotti wrote:
> On Mon, Jul 12, 2010 at 9:09 AM, Michael Tokarev <mjt@tls.msk.ru> wrote:
>> This looks quite similar to a problem with ext4 and O_SYNC which I
>> reported earlier but no one cared to answer (or read?) - there:
>> http://permalink.gmane.org/gmane.linux.file-systems/42758
>> (sent to qemu-devel and linux-fsdevel lists - Cc'd too).  You can
>> try a few other options, esp. cache=none and re-writing some guest
>> files to verify.
>>
>> /mjt
>>
> Either way, changing to cache=none I suspect wouldn't tell me much,
> because if it's as slow as before, it's still unusable and if instead
> it's even slower, well it'd be even more unusable, so I wouldn't be
> able to tell the difference.

Actually it's not that simple.

>     What I can say for certain is that with
> the exact same virtual hd file, same options, same system, but on an
> ext3 fs there's no problem at all, on a Btrfs is not just slower, it
> takes ages.

It is exactly the same with ext4 vs ext3.  But only on metadata-intensitive
operations (for qcow2 image).  Once you allocate space, it becomes fast,
and _especially_ fast with cache=none.  Actually, it looks like O_SYNC
(default cache mode) is _slower_ on ext4 than O_DIRECT (cache=none).

(And yes, I know O_DIRECT does NOT imply O_SYNC and vise versa).

/mjt
