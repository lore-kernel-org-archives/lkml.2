Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab0HQTVG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 15:21:06 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:56630 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750730Ab0HQTU7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 15:20:59 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: linux-fsdevel@vger.kernel.org
Subject: Re: unable to mount a CD - iso9660 bug?
Date: Tue, 17 Aug 2010 21:20:43 +0200
User-Agent: KMail/1.9.10
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
        Johannes Stezenbach <js@sig21.net>, "A. C. Censi" <accensi@gmail.com>,
        Tao Ma <tao.ma@oracle.com>, 7eggert@gmx.de
References: <201008161438.57103.linux@rainbow-software.org> <201008171208.42512.linux@rainbow-software.org> <AANLkTim0OzEF9D4cScHO4osX8DBN=O5a=4Y6gDfRV8=w@mail.gmail.com>
In-Reply-To: <AANLkTim0OzEF9D4cScHO4osX8DBN=O5a=4Y6gDfRV8=w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 3752
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201008172120.48174.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 August 2010 13:50:39 A. C. Censi wrote:
> On Tue, Aug 17, 2010 at 7:08 AM, Ondrej Zary <linux@rainbow-software.org> 
wrote:
> > On Tuesday 17 August 2010, Tao Ma wrote:
> >> Hi Ondrej
> >>
> >> On 08/17/2010 12:50 AM, Ondrej Zary wrote:
> >> > On Monday 16 August 2010 16:18:57 Ondrej Zary wrote:
> >> >> On Monday 16 August 2010, Johannes Stezenbach wrote:
> >> >>> On Mon, Aug 16, 2010 at 02:38:54PM +0200, Ondrej Zary wrote:
> >> >>>> I have a CD that came with Samsung printer that Linux cannot mount
> >> >>>> but works fine in Windows. The CD is physically OK - "dd" made ISO
> >> >>>> image without any problems. This ISO image is unmountable too. When
> >> >>>> I force the filesystem to iso9660, it mounts but no files are
> >> >>>> visible:
> >> >>>
> >> >>> Maybe it's a multi-session disk where the first session is
> >> >>> HFS with Apple software.  Try mounting with -t iso9660 -o session=1.
> >> >>
> >> >> Still the same - no files. dmesg contains:
> >> >>
> >> >> ISOFS: Invalid session number or type of track
> >> >> ISOFS: Invalid session number
> >> >> ISO 9660 Extensions: Microsoft Joliet Level 3
> >> >> ISO 9660 Extensions: RRIP_1991A
> >> >
> >> > Here's the compressed ISO file if anyone wants to examine it:
> >> > http://www.rainbow-software.org/linux_files/samsung-bad.rar
> >>
> >> what is your kernel version? I can mount it successfully in my el5 box
> >> with kernel 2.6.35+.
> >
> > I have 2.6.35. Also tried it on another two machines with Debian Squeeze
> > 2.6.32 and Lenny 2.6.26 with the same result (no files visible when
> > mounted).
> >
> >
> > --
> > Ondrej Zary
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel"
> > in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> Try -unide mount option.
>
> If it does not work, try what is described in the last posts of this
> thread: http://www.pubbs.net/200910/kernel/12764-iso9660-mount-problem.html

Thanks. As Bodo Eggert said, "-o norock" helps.

In fact, I've hit two "bugs":
1. blkid is unable to recognize HFS+ISO9660 CD. Just tracked it down and fixed 
only to find that it was aleady fixed:
http://git.kernel.org/?p=utils/util-linux-ng/util-linux-ng.git;a=commitdiff;h=791a2fd67c118c3f07141e4cc95532fe908015a9

2. some kernel feature - when Rock Ridge is present on iso9660, it's preferred 
over Joliet. The CD contains both but seems that only Joliet has files 
inside? When it's mounted with "-o nojoliet,norock", it's empty too. Can we 
detect this case and avoid it somehow (switch to Joliet?)

-- 
Ondrej Zary
