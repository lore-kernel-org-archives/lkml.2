Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760146Ab2COKvd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 06:51:33 -0400
Received: from toro.web-alm.net ([62.245.132.31]:34385 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755623Ab2COKvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 06:51:31 -0400
Message-ID: <4F61C843.8050307@osadl.org>
Date: Thu, 15 Mar 2012 11:45:23 +0100
From: Carsten Emde <C.Emde@osadl.org>
Organization: Open Source Automation Development Lab (OSADL)
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Bastien ROUCARIES <roucaries.bastien@gmail.com>
CC: David Airlie <airlied@linux.ie>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Keith Packard <keithp@keithp.com>,
        Paul Menzel <paulepanter@users.sourceforge.net>,
        DRI <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [V3 PATCH 1/2] drivers-gpu-drm-allow-to-load-edid-firmware.patch
References: <20120315095219.520461363@osadl.org>	<20120315095357.087317967@osadl.org> <CAE2SPAaz4oa7q4UTZ=iiKGv3v8=6xT_=odgMN-mrH9enRP26qQ@mail.gmail.com>
In-Reply-To: <CAE2SPAaz4oa7q4UTZ=iiKGv3v8=6xT_=odgMN-mrH9enRP26qQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bastien,

>> Broken monitors and/or broken graphic boards may send erroneous or no
>> EDID data. This also applies to broken KVM devices that are unable to
>> correctly forward the EDID data of the connected monitor but invent
>> their own fantasy data.
>>
>> This patch allows to specify an EDID data set to be used instead of
>> probing the monitor for it. It contains built-in data sets of frequently
>> used screen resolutions. In addition, a particular EDID data set may be
>> provided in the /lib/firmware directory and loaded via the firmware
>> interface. The name is passed to the kernel as module parameter of the
>> drm_kms_helper module either when loaded
>>   options drm_kms_helper edid_firmware=edid/1280x1024.bin
>> or as kernel commandline parameter
>>   drm_kms_helper.edid_firmware=edid/1280x1024.bin
>
> Windows allow vendor to override eddid based on 3 bytes manufacturer
> and product code.
This may solve the situation when a particular monitor lies about the
required setting or its EDID data set has an invalid CRC. However, this
does not solve the situation when we do not get any useful EDID
information, because something is totally broken. This also applies to
the KVM situation when the KVM sends EDID data that are totally
unrelated to the monitor at the other side of the KVM.

> Seems a reasonnable approach to follow.
I am not yet convinced.

	-Carsten.
