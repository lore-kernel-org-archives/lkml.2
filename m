Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab2JNKwr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 06:52:47 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:5429 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445Ab2JNKwq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 06:52:46 -0400
X-Authority-Analysis: v=2.0 cv=OOOlLFmB c=1 sm=0 a=YPDeGStqRoQnMAluW+pq4Q==:17 a=65KWcu232dMA:10 a=h9GbcFHyNoYA:10 a=DpEkYpXRGzUA:10 a=05ChyHeVI94A:10 a=IkcTkHD0fZMA:10 a=ayC55rCoAAAA:8 a=nULq49Tkjo8A:10 a=eKWvBVOvAAAA:8 a=ehcPXXhigl7-auNbUk8A:9 a=QEXdDO2ut3YA:10 a=YPDeGStqRoQnMAluW+pq4Q==:117
X-Cloudmark-Score: 0
X-Originating-IP: 50.89.247.146
Message-ID: <507A997D.7070508@cfl.rr.com>
Date: Sun, 14 Oct 2012 06:52:45 -0400
From: Mark Hounschell <dmarkh@cfl.rr.com>
Reply-To: dmarkh@cfl.rr.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: =?UTF-8?B?QnJ1bm8gUHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
CC: markh@compro.net, linux-kernel@vger.kernel.org,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Subject: Re: Intel graphics drm issue?
References: <507812E8.3060607@compro.net> <20121012231459.166e29fd@neptune.home> <5079B97C.7020401@cfl.rr.com> <5079BE5C.8020401@cfl.rr.com> <20121014104138.7e8a9c59@neptune.home>
In-Reply-To: <20121014104138.7e8a9c59@neptune.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2012 04:41 AM, Bruno Prémont wrote:

>
> Your best solution is probably to write an EDID blob (or reuse one you find
> somewhere) that provides at least one mode matching your TV's native mode
> (probably full-HD).
>
> Google suggested the following document:
> http://www.jordansmanuals.com/ServiceManuals%5CLG%5CTV%5CLCD%5C42LB9DF%5C42LB9DF%20Service%20Manual.pdf
> which on page 13/14 shows the full EDID blob for the various HDMI outputs of the
> TV. You may want to read that document, convert the EDID blobs to 512 bytes binary
> files and hell DRM core to use the right one via module/kernel cmdline option:
>
>   drm_kms_helper.edid_firmware=edid/lg42lb9df.edid
> or
>   modprobe drm-kms-helper edid_firmware=edid/lg42lb9df.edid
>
> where
>   /lib/firmware/edid/lg42lb9df.edid
> is the 512-bytes EDID blob created according to data from above manual.
> (note, that will only work for intel, radeon and nouveau drivers but will
>   not work for closed drivers of AMD/nVidia)
>

This certainly looks doable. That firmware file, should it contain all 4 
tables or just the one for the port I'm connected to? Will it matter what 
order they were in?

Thanks
Mark

