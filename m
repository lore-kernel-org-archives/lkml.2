Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214Ab2JCWsy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 18:48:54 -0400
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:46511 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932105Ab2JCWsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 18:48:52 -0400
References: <4FE9169D.5020300@redhat.com> <20121002100319.59146693@redhat.com> <CA+55aFyzXFNq7O+M9EmiRLJ=cDJziipf=BLM8GGAG70j_QTciQ@mail.gmail.com> <20121002221239.GA30990@kroah.com> <20121002222333.GA32207@kroah.com> <CA+55aFwNEm9fCE+U_c7XWT33gP8rxothHBkSsnDbBm8aXoB+nA@mail.gmail.com> <506C562E.5090909@redhat.com> <CA+55aFweE2BgGjGkxLPkmHeV=Omc4RsuU6Kc6SLZHgJPsqDpeA@mail.gmail.com> <20121003170907.GA23473@ZenIV.linux.org.uk> <CA+55aFw0pB99ztq5YUS56db-ijdxzevA=mvY3ce5O_yujVFOcA@mail.gmail.com> <20121003195059.GA13541@kroah.com> <CA+55aFwjyABgr-nmsDb-184nQF7KfA8+5kbuBNwyQBHs671qQg@mail.gmail.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <CA+55aFwjyABgr-nmsDb-184nQF7KfA8+5kbuBNwyQBHs671qQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: udev breakages - was: Re: Need of an ".async_probe()" type of callback at driver's core - Was: Re: [PATCH] [media] drxk: change it to use request_firmware_nowait()
From: Andy Walls <awalls@md.metrocast.net>
Date: Wed, 03 Oct 2012 18:48:52 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>
CC: Al Viro <viro@zeniv.linux.org.uk>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ming Lei <ming.lei@canonical.com>, Kay Sievers <kay@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Ivan Kalvachev <ikalvachev@gmail.com>
Message-ID: <3560b86d-e2ad-484d-ab6e-2b9048894a12@email.android.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-10-03_02:2012-10-03,2012-10-03,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=11
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=6.0.2-1203120001 definitions=main-1210030276
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

>On Wed, Oct 3, 2012 at 12:50 PM, Greg KH <gregkh@linuxfoundation.org>
>wrote:
>>>
>>> Ok, like this?
>>
>> This looks good to me.  Having udev do firmware loading and tieing it
>to
>> the driver model may have not been such a good idea so many years
>ago.
>> Doing it this way makes more sense.
>
>Ok, I wish this had been getting more testing in Linux-next or
>something, but I suspect that what I'll do is to commit this patch
>asap, and then commit another patch that turns off udev firmware
>loading entirely for the synchronous firmware loading case.
>
>Why? Just to get more testing, and seeing if there are reports of
>breakage. Maybe some udev out there has a different search path (or
>because udev runs in a different filesystem namespace or whatever), in
>which case running udev as a fallback would otherwise hide the fact
>that he direct kernel firmware loading isn't working.
>
>We can (and will) revert things if that turns out to break things, but
>I'd like to make any failures of the firmware direct-load path be fast
>and hard, so that we can see when/what it breaks.
>
>Ok? Comments?
>
>              Linus
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

I don't know if you can remove the /sys/.../firmware ABI altogether, because there is at least one, somewhat popular udev replacement that also uses it: mdev

http://git.busybox.net/busybox/plain/docs/mdev.txt

Regards,
Andy
