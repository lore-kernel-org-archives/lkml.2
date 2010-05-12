Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab0ELKiW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 06:38:22 -0400
Received: from mx4.sophos.com ([74.202.89.161]:60507 "EHLO mx4.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752706Ab0ELKiU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 06:38:20 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.33.2 kmalloc-8 slab leaks ~512 objects per second
Date: Wed, 12 May 2010 11:38:05 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33.2; KDE/4.3.5; x86_64; ; )
CC: <dri-devel@lists.sourceforge.net>, David Airlie <airlied@linux.ie>
References: <11758_1273660249_4BEA8359_11758_1675_1_201005121121.49135.tvrtko.ursulin@sophos.com>
In-Reply-To: <11758_1273660249_4BEA8359_11758_1675_1_201005121121.49135.tvrtko.ursulin@sophos.com>
MIME-Version: 1.0
Message-ID: <201005121138.05254.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 12/05/2010 11:38:05,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 12/05/2010 11:38:06,
	Serialize complete at 12/05/2010 11:38:06
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 May 2010 11:21:48 Tvrtko Ursulin wrote:
> Hi all,
>
> As the subject says, is this a know issue? I have been tracking the growth
>  at one second intervals and it looks like this:
>
> 512 (67716608) Slab:             606744 kB
> 512 (67717120) Slab:             606752 kB
> 512 (67717632) Slab:             606756 kB
> 0 (67718144) Slab:             606756 kB
> 512 (67718144) Slab:             606760 kB
> 1024 (67718656) Slab:             606768 kB
> 512 (67719680) Slab:             606772 kB
> 512 (67720192) Slab:             606776 kB
> 0 (67720704) Slab:             606776 kB
> 512 (67720704) Slab:             606780 kB
>
> First fiels is the diff in numobj, in parentheses is actual numobj and last
>  is the total slab size from /proc/meminfo.
>
> kmalloc-8         68044800 68044800      8  512    1 : tunables    0    0
>   0
>
> : slabdata 132900 132900      0
>
> dm-io slab also seems large, don't know... :
> dm_io              75924 147288     40  102    1 : tunables    0    0    0
>  : slabdata   1444   1444      0
>
> Some other info about the system/kernel is attached.

I think it is DRM (radeon) related, leak stopped when I closed all X programs.
I am compiling 2.6.33.3 right now and will soon reboot into it.

Tvrtko

Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
Company Reg No 2096520. VAT Reg No GB 348 3873 20.
