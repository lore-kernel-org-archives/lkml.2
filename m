Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab1D0K2y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 06:28:54 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61119 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab1D0K2x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 06:28:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=eH0ZdpBPlDQcqi9ONFmYpYwVQRv+mcPIrvx/ywcSmxbXiWQ0gH9sEx9P4ekqUCpXES
         52lgjd1MG1o2ZN71yHQ+L9IhZZb8XpmzJNoxvKIJfkAoWRHRA6cdCsnMDrTX9K7qCaRR
         DEGXzvJmj11qiNGeYE6inKAScjXFx5n6w5rTM=
MIME-Version: 1.0
In-Reply-To: <BANLkTikSLA59tdgRL4B=cr5tvP2NbzZ=KA@mail.gmail.com>
References: <20110424202158.45578f31@neptune.home>
	<20110424235928.71af51e0@neptune.home>
	<20110425114429.266A.A69D9226@jp.fujitsu.com>
	<BANLkTinVQtLbmBknBZeY=7w7AOyQk61Pew@mail.gmail.com>
	<20110425111705.786ef0c5@neptune.home>
	<BANLkTi=d0UHrYXyTK0CBZYCSK-ax8+wuWQ@mail.gmail.com>
	<20110425180450.1ede0845@neptune.home>
	<BANLkTikSLA59tdgRL4B=cr5tvP2NbzZ=KA@mail.gmail.com>
Date: Wed, 27 Apr 2011 11:28:52 +0100
X-Google-Sender-Auth: aysJ_DYu7NXqRjTIZQdfS5031NM
Message-ID: <BANLkTi==7UeCPf0WfD66f1jMXV7j8wsWEA@mail.gmail.com>
Subject: Re: 2.6.39-rc4+: Kernel leaking memory during FS scanning, regression?
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: =?UTF-8?Q?Bruno_Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
        Mike Frysinger <vapier.adi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Pekka Enberg <penberg@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 April 2011 17:31, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 2011/4/25 Bruno Prémont <bonbons@linux-vserver.org>:
>> kmemleak reports 86681 new leaks between shortly after boot and -2 state.
>> (and 2348 additional ones between -2 and -4).
>
> I wouldn't necessarily trust kmemleak with the whole RCU-freeing
> thing. In your slubinfo reports, the kmemleak data itself also tends
> to overwhelm everything else - none of it looks unreasonable per se.

Kmemleak reports that it couldn't find any pointers to those objects
when scanning the memory. In theory, it is safe with RCU since objects
queued for freeing via the RCU are in a linked list and still
referred.

There are of course false positives, usually when pointers are stored
in some structures not scanned by kmemleak (e.g. some arrays allocated
with alloc_pages which are not explicitly tracked by kmemleak) but I
haven't seen any related to RCU (yet).

-- 
Catalin
