Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab0L1OtJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 09:49:09 -0500
Received: from mail-iy0-f194.google.com ([209.85.210.194]:48221 "EHLO
	mail-iy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796Ab0L1OtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 09:49:07 -0500
MIME-Version: 1.0
X-Originating-IP: [93.172.188.89]
In-Reply-To: <AANLkTiksjHKjKQ+mWE=Zf0+967_E46V3+RURcMC-s5cD@mail.gmail.com>
References: <1292870624-25450-1-git-send-email-felipe.contreras@nokia.com>
 <AANLkTikisHaAMZphRJVYdcokVbaZXVF9COrwkdGTDg__@mail.gmail.com>
 <AANLkTi=9AL3aWUsMeih+Gb-sMov=MgBZ1eTp8wb=q1hZ@mail.gmail.com>
 <AANLkTinX8t=3b48e2sxPU-V_G-nGm_1DyEg6B-CeqXDa@mail.gmail.com>
 <1293452486-notmuch-felipe.contreras@nokia.com> <AANLkTinz0HuhGB_WzTQbK8XkfkGALjtg928WdOUYsySf@mail.gmail.com>
 <AANLkTimCB5g29gzWFzaFU1N8+doROTpWaXy18VU5AJyH@mail.gmail.com>
 <AANLkTi=xmxkWnhuYcjtDNDHgep_2EztfGXDv+winW2Y5@mail.gmail.com> <AANLkTiksjHKjKQ+mWE=Zf0+967_E46V3+RURcMC-s5cD@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 28 Dec 2010 16:48:46 +0200
Message-ID: <AANLkTi=X=Av0SaqphXUfiXMNX_tD8OF1CWes34keZ8O1@mail.gmail.com>
Subject: Re: [PATCH v2] staging: tidspbridge: protect dmm_map properly
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Felipe Contreras <felipe.contreras@nokia.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        greg@kroah.com, omar.ramirez@ti.com, fernando.lugo@ti.com, nm@ti.com,
        ameya.palande@nokia.com, h-kanigeri2@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 28, 2010 at 2:12 PM, Felipe Contreras
<felipe.contreras@gmail.com> wrote:
> On Tue, Dec 28, 2010 at 12:56 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
>> I still don't know how exactly you triggered the bug: is gst-dsp
>> multithreaded ? and one of its threads invoked proc_un_map() while
>> another thread called proc_begin_dma() ?
>
> I haven't investigated why that happens

Btw, I still think you should look into this.

The kernel panic will be solved, but you may still have a race there
that can lead to data corruption: if proc_un_map will be fast enough,
it will acquire the proc_lock mutex before proc_begin_dma(), and then
you will miss a cache operation.
