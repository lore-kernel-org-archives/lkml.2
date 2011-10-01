Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237Ab1JAUiR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 16:38:17 -0400
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:34160 "EHLO
	homiemail-a80.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754872Ab1JAUiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 16:38:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=shealevy.com; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=shealevy.com;
	 b=DofKIGO1vmWrbrtJrIGc3BLp09N/je47MCGr7QMZJwvj7oSYr08EBnWUWslQL
	7AR0P4JCmmJbN/3ha/IqNCTId+bW0pZFdnukbW8dDmnKs1lKUhVTwyQTWTBPx25l
	VGdzTXpSv+RhJx9sIPR/H2Geq2pMWxNOivksaOX62H/Tv8=
Message-ID: <4E877A22.6070605@shealevy.com>
Date: Sat, 01 Oct 2011 16:37:54 -0400
From: Shea Levy <shea@shealevy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110928 Thunderbird/3.1.9
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <eric.dumazet@gmail.com>,
        "Alban Crequy" <alban.crequy@collabora.co.uk>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Davide Libenzi" <davidel@xmailserver.org>, netdev@vger.kernel.org
Subject: Re: Hang with "runaway loop modprobe net-pf-1" on Linux 3.0.4
References: <7ca3debde28dcc206c1f6f787df5c619.squirrel@webmail.shealevy.com>
In-Reply-To: <7ca3debde28dcc206c1f6f787df5c619.squirrel@webmail.shealevy.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2011 08:38 AM, shea@shealevy.com wrote:
> Hello,
>
> My initrd mounts /proc and /sys, puts a tmpfs at /dev, then loads ext4. On
> 2.6.39 (and earlier), this works fine and the initrd init continues
> happily. On 3.0.4, however, the kernel spits out
>
>> request_module: runaway loop modprobe net-pf-1
> a few times then hangs. If I drop into a shell before loading ext4 and run
> modprobe unix, the same problem occurs. The modprobe used is dynamically
> linked with glibc (which is included in the initrd), and it is the same
> modprobe on the working and non-working systems. From my searches, it
> appears that CONFIG_UNIX=y instead of =m would probably solve this
> problem, but I'd rather keep it as a module if it's possible to get it
> working. What's going wrong here? Why does it work on 2.6.39 but not
> 3.0.4?
>
> Regards,
> Shea Levy
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

CC'ing af_unix.c maintainers. Also, I had the same problem with 3.0.
