Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932707Ab0KOIBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 03:01:22 -0500
Received: from mx01.sz.bfs.de ([194.94.69.103]:28073 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757691Ab0KOIBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 03:01:18 -0500
Message-ID: <4CE0E8CA.9010704@bfs.de>
Date: Mon, 15 Nov 2010 09:01:14 +0100
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.14) Gecko/20101013 SUSE/3.0.9 Thunderbird/3.0.9
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch 2/2] fbcmap: integer overflow bug
References: <20101027093716.GD6062@bicker> <20101105134018.2c11f283.akpm@linux-foundation.org> <20101113100718.GB1795@bicker> <20101115044820.GA8489@linux-sh.org> <AANLkTin0T5FN6WhUj0csypR=j0UPRbeHN+HC3N9xnk7E@mail.gmail.com> <20101115072014.GB21614@bicker>
In-Reply-To: <20101115072014.GB21614@bicker>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 15.11.2010 08:20, schrieb Dan Carpenter:
> On Mon, Nov 15, 2010 at 07:56:05AM +0100, Geert Uytterhoeven wrote:
>> On Mon, Nov 15, 2010 at 05:48, Paul Mundt <lethal@linux-sh.org> wrote:
>>> On Sat, Nov 13, 2010 at 01:07:18PM +0300, Dan Carpenter wrote:
>>>> @@ -256,8 +264,12 @@ int fb_set_user_cmap(struct fb_cmap_user *cmap, struct fb_info *info)
>>>>       int rc, size = cmap->len * sizeof(u16);
>>>>       struct fb_cmap umap;
>>>>
>>>> +     if (cmap->len * 2 > INT_MAX)
>>
>> Isn't that another integer overflow? I.e. should be "if (cmap->len >
>> INT_MAX / sizeof(u16))" instead?
>>
> 
> Yeah it is.  :/
> 
> I'll change it to:
> 	if (size < 0 || size < cmap->len)
> like Paul asked.
> 

I do not see the rest of the code but it looks like
cmap->len is size in int8_t. So the upper limit is something like
INT_MAX/(sizeof(u16)*2). Perhaps we can call it a char ?
is there ANY system that has a more than 256 colors in R|G|B ?

<spying for struct fb_cmap_user  >
 __u32 len;
 __u16 __user *red;

So no need to check for <0.

hope that helps,
re,
 wh
