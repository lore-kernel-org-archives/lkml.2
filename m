Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab0LHIEh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 03:04:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752538Ab0LHIEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 03:04:35 -0500
Message-ID: <4CFF3BE7.40007@redhat.com>
Date: Wed, 08 Dec 2010 09:03:51 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101110 Thunderbird/3.1.6
MIME-Version: 1.0
To: Jon Nelson <jnelson@jamponi.net>
CC: Chris Mason <chris.mason@oracle.com>, Mike Snitzer <snitzer@redhat.com>,
        Matt <jackdachef@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        dm-devel <dm-devel@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        htd <htd@fancy-poultry.org>, htejun <htejun@gmail.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption?
References: <AANLkTinG209iRAXgpNC0vNpn1C02wkYmVfveXRBqsKV-@mail.gmail.com> <4CF692D1.1010906@redhat.com> <AANLkTimA2PPXZoOHYgeOEV2ocrojeuBby8MYDYJ1yjx1@mail.gmail.com> <4CF6B3E8.2000406@redhat.com> <20101201212310.GA15648@redhat.com> <AANLkTimQtMvPVafWG_DffF-zXXpz1vBPXdCCwxRnzSGr@mail.gmail.com> <20101204193828.GB13871@redhat.com> <AANLkTin3A_ySn_sZQPqZMn-NORnteQZwTVVSiW_=r3sO@mail.gmail.com> <20101207142145.GA27861@think> <AANLkTikJt-ZOmzj68Jw92rjGHzu0EP-uCVD+eNSO=vGd@mail.gmail.com> <20101207182243.GB21112@redhat.com> <AANLkTikOXjh+D25=7Mzwn7bFN+a9xQSimPHs22q4o2TK@mail.gmail.com> <1291747731-sup-3099@think> <AANLkTin-Bvq9bNgarZGZhbK_2EONdu8x-qaLCLFcc1F_@mail.gmail.com> <1291751698-sup-9297@think> <AANLkTin79GzUbfuZNKyTtqcyoUSO9AJimO77_ZOvqggH@mail.gmail.com> <1291754340-sup-1631@think> <AANLkTim8uCmFK=LjkMmq_1O0KE3AiN_7g41AO0woxMv7@mail.gmail.com> <1291755258-sup-8760@think> <AANLkTi=OC9Z68U-j8s6vfU-_-6tkg5W7aUz9HEupidX9@mail.gmail.com>
In-Reply-To: <AANLkTi=OC9Z68U-j8s6vfU-_-6tkg5W7aUz9HEupidX9@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 12/08/2010 04:29 AM, Jon Nelson wrote:
> Maybe not so fantastic. I kept testing and had no more failures. At
> all. After 40+ iterations I gave up.
> I went back to trying ext4 on a LUKS volume. The 'hit' ratio went to
> something like 1 in 3, or better.

Encryption usually propagates bit corruption (not sure if it is
in this case). But in principle if there is one bit corrupted,
after decryption the whole sector is corrupted.
(That's why bit media errors have usually more serious impact
with FDE.)

Isn't there random noise instead of zeroes when reading
sparse files?
We should probably write some test focusing on sparse files
handling here...

Milan
