Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab2JUVAa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 17:00:30 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42480 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab2JUVA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 17:00:28 -0400
Message-ID: <50846264.302@gmail.com>
Date: Sun, 21 Oct 2012 23:00:20 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: "Artem S. Tashkinov" <t.artem@lycos.com>
CC: bp@alien8.de, pavel@ucw.cz, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, security@kernel.org,
        linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        alsa-devel@alsa-project.org, stern@rowland.harvard.edu
Subject: Re: A reliable kernel panic (3.6.2) and system crash when visiting
 a particular website
References: <2104474742.26357.1350734815286.JavaMail.mail@webmail05> <20121020162759.GA12551@liondog.tnic> <966148591.30347.1350754909449.JavaMail.mail@webmail08> <20121020203227.GC555@elf.ucw.cz> <20121020225849.GA8976@liondog.tnic> <1781795634.31179.1350774917965.JavaMail.mail@webmail04> <20121021002424.GA16247@liondog.tnic> <1798605268.19162.1350784641831.JavaMail.mail@webmail17> <20121021110851.GA6504@liondog.tnic> <121566322.100103.1350820776893.JavaMail.mail@webmail20> <20121021170315.GB20642@liondog.tnic> <1906833625.122006.1350848941352.JavaMail.mail@webmail16> <5084530B.6030209@gmail.com> <1651404200.40745.1350852195790.JavaMail.mail@webmail04>
In-Reply-To: <1651404200.40745.1350852195790.JavaMail.mail@webmail04>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.10.2012 22:43, Artem S. Tashkinov wrote:
>> Nice. Could you do that again with the patch applied I sent yo some
>> hours ago?
> 
> That patch was of no help - the system has crashed and I couldn't spot relevant
> messages.
> 
> I've no idea what it means.

The sequence of driver callbacks issued on a stream start is

 .open()
 .hw_params()
 .prepare()
 .trigger()

If the ALSA part really causes this issue, the bad things happen either
in any of the driver callback functions or in the core underneath.

The patch I sent returns an error from the hw_params callback, and as
you still see the problem, that means that the crash happens before any
of the USB audio streaming really starts.

Could you try and return -EINVAL from snd_usb_capture_open() please?

If anyone has a better idea on how to debug this, please chime in.


Daniel

