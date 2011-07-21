Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab1GUNAx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 09:00:53 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42045 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab1GUNAw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 09:00:52 -0400
MIME-Version: 1.0
X-Originating-IP: [92.140.109.150]
In-Reply-To: <20110721112331.GA15059@linuxaudio.org>
References: <20110719143758.GA15283@linuxaudio.org> <CAFEhRJf-5U=cS3iptpvGEVSHV+S=aBF_mWfWkC_QMRty_WnoPA@mail.gmail.com>
 <20110720131120.GA1836@linuxaudio.org> <CAFEhRJd9ZCSpx52S__vMdWK18mhMQrRoU9R5zNaZE=wksLRTvg@mail.gmail.com>
 <20110720153023.GA11502@linuxaudio.org> <CAFEhRJczj=_B7fK7GvBEnqpB2GJGnCnGkoA2w5vzbFfM2wAGZw@mail.gmail.com>
 <20110720163844.GB16901@linuxaudio.org> <CAG-2HqWqATSJ=oJTTvULXwPEG82yN+8e6GJFs759hPA-=krAOQ@mail.gmail.com>
 <20110721100944.GA13971@linuxaudio.org> <CAG-2HqX23C79vfccnu0tMqx+6K9Z5pS0_HekaLizQx7XfkPQ1Q@mail.gmail.com>
 <20110721112331.GA15059@linuxaudio.org>
From: Tom Gundersen <teg@jklm.no>
Date: Thu, 21 Jul 2011 15:00:32 +0200
Message-ID: <CAG-2HqWK3x5-szkyzX8AMxuMpDZNVRXHYtQ0AkAPMsGcLK0Z9w@mail.gmail.com>
Subject: Re: [arch-general] Panic - no sound devices after upgrade
To: General Discussion about Arch Linux <arch-general@archlinux.org>,
        Fons Adriaensen <fons@linuxaudio.org>
Cc: Adrian Knoth <adi@drcomp.erfurt.thur.de>, Takashi Iwai <tiwai@suse.de>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian, Takashi: I added you to cc, as you last touched this code,
sorry if I should have cc'ed someone else. It appears that the HDSPM
module does not recognise cards with firmware revision 0xCC:

On Thu, Jul 21, 2011 at 1:23 PM, Fons Adriaensen <fons@linuxaudio.org> wrote:
>>>>> * The driver for my card (RME HDSP MADI, snd_hdpsm) is loaded.
>> > [   48.057757] HDSPM: unknown firmware revision cc
[...]
> Today I tried again downgrading the kernel to 2.6.37, to check if
> the firmware revision error would occur. It doesn't.
[...]
> Tentative conclusion: the snd_hdspm driver in 2.6.39 is not OK.

Ah, I see. Thanks for the clarification. This means that the kernel is
not able to recognise your card. Pre-.39 it would load anyway, but
since .39 it gives the warning you posted and refuses to load. Your
firmware revision is 0xCC, which is not recognised. If your card is
MADI, the kernel expects the firmware revision to be 0xD2 (or starting
in 3.0, it also accepts 0xCF).

I guess this can be fixed easily by adding your firmware revision to
the list of accepted revs.

Adrian: is any more info needed to add this rev?

Cheers,

Tom
