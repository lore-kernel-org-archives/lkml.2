Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957Ab0L2JmX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 04:42:23 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62712 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847Ab0L2JmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 04:42:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=dMd38y1qT4Zws28E+so8X3o/jtWJCyIpYIVgdfaibwyfMRC8gJUg91jlYCnRusJBfy
         leF6D0GORJF+RGZBal71mC276tRKjUsfcPdke76BKc3harkRXVvmU04hLaZKo/9WHO8M
         DXpXTwbT+n4x8NtBhyym2pEJEK+jHtD7Ssp+M=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=X=Av0SaqphXUfiXMNX_tD8OF1CWes34keZ8O1@mail.gmail.com>
References: <1292870624-25450-1-git-send-email-felipe.contreras@nokia.com>
	<AANLkTikisHaAMZphRJVYdcokVbaZXVF9COrwkdGTDg__@mail.gmail.com>
	<AANLkTi=9AL3aWUsMeih+Gb-sMov=MgBZ1eTp8wb=q1hZ@mail.gmail.com>
	<AANLkTinX8t=3b48e2sxPU-V_G-nGm_1DyEg6B-CeqXDa@mail.gmail.com>
	<1293452486-notmuch-felipe.contreras@nokia.com>
	<AANLkTinz0HuhGB_WzTQbK8XkfkGALjtg928WdOUYsySf@mail.gmail.com>
	<AANLkTimCB5g29gzWFzaFU1N8+doROTpWaXy18VU5AJyH@mail.gmail.com>
	<AANLkTi=xmxkWnhuYcjtDNDHgep_2EztfGXDv+winW2Y5@mail.gmail.com>
	<AANLkTiksjHKjKQ+mWE=Zf0+967_E46V3+RURcMC-s5cD@mail.gmail.com>
	<AANLkTi=X=Av0SaqphXUfiXMNX_tD8OF1CWes34keZ8O1@mail.gmail.com>
Date: Wed, 29 Dec 2010 11:42:20 +0200
Message-ID: <AANLkTin3A__2OU+N-tQYJ_xOMz7-GXwia1yw10nzpU3V@mail.gmail.com>
Subject: Re: [PATCH v2] staging: tidspbridge: protect dmm_map properly
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Felipe Contreras <felipe.contreras@nokia.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        greg@kroah.com, omar.ramirez@ti.com, fernando.lugo@ti.com, nm@ti.com,
        ameya.palande@nokia.com, h-kanigeri2@ti.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 28, 2010 at 4:48 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> On Tue, Dec 28, 2010 at 2:12 PM, Felipe Contreras
> <felipe.contreras@gmail.com> wrote:
>> On Tue, Dec 28, 2010 at 12:56 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
>>> I still don't know how exactly you triggered the bug: is gst-dsp
>>> multithreaded ? and one of its threads invoked proc_un_map() while
>>> another thread called proc_begin_dma() ?
>>
>> I haven't investigated why that happens
>
> Btw, I still think you should look into this.
>
> The kernel panic will be solved, but you may still have a race there
> that can lead to data corruption: if proc_un_map will be fast enough,
> it will acquire the proc_lock mutex before proc_begin_dma(), and then
> you will miss a cache operation.

Aquiring the lock is the first thing done; if proc_un_map() aquires
the lock first, it's because it was run first, and thus a problem for
user-space. If user-space wants the cache operation, it must run
proc_begin_dma() first, there's nothing kernel-space can do to fix
that.

-- 
Felipe Contreras
