Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956Ab0GLHQr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 03:16:47 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:59942 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213Ab0GLHQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 03:16:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Con4U55cY/GMnhEdGH/LFbEpfy0b9ERfkEF2i71UgYI4Uhf8xlnh3Ru5ssEMBObBPW
         26jMyJMHwLIFZEu+s6xknHfjz7YRRl24ojNlPQaSUFW3pq4QWdpHiqHWVtvB1ymzoCkN
         QIKlJaw4+dK1oBG8M9IaCUga1TlZBikZcPpac=
Message-ID: <4C3AC187.2080909@gmail.com>
Date: Mon, 12 Jul 2010 00:17:27 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Michael Tokarev <mjt@tls.msk.ru>
CC: Giangiacomo Mariotti <gg.mariotti@gmail.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>
Subject: Re: BTRFS: Unbelievably slow with kvm/qemu
References: <AANLkTin1uF6WbVvxJ84oO1NKnCU-6VHrmWU1XFYTlqtp@mail.gmail.com> <4C3ABF96.9070405@msgid.tls.msk.ru>
In-Reply-To: <4C3ABF96.9070405@msgid.tls.msk.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2010 12:09 AM, Michael Tokarev wrote:
> 12.07.2010 09:24, Giangiacomo Mariotti wrote:
>> Hi, is it a known problem how much slow is Btrfs with kvm/qemu(meaning
>> that the image kvm/qemu uses as the hd is on a partition formatted
>> with Btrfs, not that the fs used by the hd inside the kvm environment
>> is Btrfs, in fact inside kvm the / partition is formatted with ext3)?
>> I haven't written down the exact numbers, because I forgot, but while
>> I was trying to make it work, after I noticed how much longer than
>> usual it was taking to just install the system, I took a look at iotop
>> and it was reporting a write speed of the kvm process of approximately
>> 3M/s, while the Btrfs kernel thread had an approximately write speed
>> of 7K/s! Just formatting the partitions during the debian installation
>> took minutes. When the actual installation of the distro started I had
>> to stop it, because it was taking hours! The iotop results made me
>> think that the problem could be Btrfs, but, to be sure that it wasn't
>> instead a kvm/qemu problem, I cut/pasted the same virtual hd on an
>> ext3 fs and started kvm with the same parameters as before. The
>> installation of debian inside kvm this time went smoothly and fast,
>> like normally it does. I've been using Btrfs for some time now and
>> while it has never been a speed champion(and I guess it's not supposed
>> to be one and I don't even really care that much about it), I've never
>> had any noticeable performance problem before and it has always been
>> quite stable. In this test case though, it seems to be doing very bad.
>
> This looks quite similar to a problem with ext4 and O_SYNC which I
> reported earlier but no one cared to answer (or read?) - there:
> http://permalink.gmane.org/gmane.linux.file-systems/42758
> (sent to qemu-devel and linux-fsdevel lists - Cc'd too).  You can
> try a few other options, esp. cache=none and re-writing some guest
> files to verify.
>
> /mjt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

cool a solution... glad to see... no chance at a bisect with this?
(getting this down too a commit or two makes things easier)

Justin P. Mattock
