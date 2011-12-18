Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750Ab1LRIyy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 03:54:54 -0500
Received: from mail01.manz-automation.com ([88.79.234.227]:35893 "EHLO
	mail01.manz-automation.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751241Ab1LRIyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 03:54:52 -0500
Message-ID: <1324198486.4924.3.camel@raz>
Subject: Re: Subject:[PATCH 1:1] boot paramer "root=" gets a list of devices
From: Raz Ben Yehuda <rbenyehuda@manz.com>
Reply-To: <rbenyehuda@manz.com>
To: Kay Sievers <kay.sievers@vrfy.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, "wad@chromium.org" <wad@chromium.org>,
        Rasty Slutsker <RSlutsker@manz.com>, Lior Brafman <LBrafman@manz.com>,
        <linux-kernel@vger.kernel.org>
Date: Sun, 18 Dec 2011 10:54:46 +0200
In-Reply-To: <CAPXgP12QS3jGi3pcEhSAoGcWdtjmujL-HP69Cgy9_+kRLFq1sQ@mail.gmail.com>
References: <1323940396.16032.2.camel@raz> <4EEA0C05.4030907@zytor.com>
	 <1323962398.11872.3.camel@raz> <4EEA10BC.3000906@zytor.com>
	 <CAPXgP12QS3jGi3pcEhSAoGcWdtjmujL-HP69Cgy9_+kRLFq1sQ@mail.gmail.com>
Organization: Manz
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-15 at 19:11 +0100, Kay Sievers wrote:
> On Thu, Dec 15, 2011 at 16:22, H. Peter Anvin <hpa@zytor.com> wrote:
> > On 12/15/2011 07:19 AM, Raz Ben Yehuda wrote:
> >>>
> >>> To which point I have to ask, once again, at which point we stop putting
> >>> this stuff in the kernel to "bypass the need for initramfs"...
> >>
> >> because there are times where we cannot use initramfs. is this a problem
> >> with way i phrase or with with the whole idea ?
> 
> I don't see why stuff needs to search a hard-coded list of stuff. That
> logic seems pretty much backwards to me. You either use the GPT stuff
> that allows to flag the right partition to boot from a set of
> partitions, or you go as far as make the kernel parse the filesystem
> UUID of partitions. But hard-coding search lists on the commandline, I
> really don't understand.
Will GPT or fs UUID parsing solve the problem of having the kernel
think that hda has the root filesystem while hdc has it ?
> > There are problems with the whole concept of "cannot use initramfs".  We
> > allow the initramfs to be integrated with the kernel image for a reason, for
> > example.
> >
> > I'm obviously ranting on this in part to make people think about what they
> > are doing, and partly to remind that the more complex the in-kernel
> > root-mounting code get, the more it might be worth reconsidering klibc in
> > the kernel build tree.
> 
> I think the whole picture of klibc is confusing and I very much don't
> want to see that busybox-style hacking in the kernel sources.
> 
> Distros can not afford to support 2 libcs at bootup, and the distro
> initramfss gets so complicated today, that a klibc-only solution does
> not really work. So we end up with 2 libcs in the same initramfs
> image, which makes zero sense. Leave alone the fact, that the klibc
> tools duplicate all the stuff that already works in the real root in a
> completely different and mostly insufficient and sometimes scary way.
> 
> The thing is, if the setup is that simple that klibc works, it is very
> likely that the current in-kernel mount code is simple, well tested
> and sufficient enough. If a distro-style intramfs is needed, klibc is
> not usable (see above). The big distros will very unlikely ever pick
> it up. The the remaining use-cases will stay a niche, that, I think,
> does not justify the kernel inclusion of klibc.
> 
> If the whole klibc approach, if not entirely rethought, I doubt it
> will ever go anywhere. In my opinion, with all what I've seen the last
> years, we either work on a full libc in the kernel tree, that can be
> used by normal userspace too, or we leave the tiny stuff to busybox
> and one of the existing tiny libcs.
> 
> Kay


