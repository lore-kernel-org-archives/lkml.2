Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab1AQCvc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 21:51:32 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60004 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751515Ab1AQCv3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 21:51:29 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTinets0TKJmODLB4u9kH1v_KS3UWfxhvP-UQ=vmP@mail.gmail.com>
References: <1295183333-13802-1-git-send-email-akinobu.mita@gmail.com>
 <AANLkTikWZYOqxD_CyJ=zF2Lp2Mnt6Z2E1aPUspwMjrz_@mail.gmail.com> <AANLkTinets0TKJmODLB4u9kH1v_KS3UWfxhvP-UQ=vmP@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 16 Jan 2011 18:50:39 -0800
Message-ID: <AANLkTimvUaGJ1eps5thgBUKjAjXuNN-6O4i-oBXZtQsd@mail.gmail.com>
Subject: Re: [PATCH v4 00/24] Introduce little endian bitops
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org, Russell King <rmk@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 16, 2011 at 6:37 PM, Akinobu Mita <akinobu.mita@gmail.com> wrote:
>
> Changing *_bit_le() to take "void *" instead of "unsigned long *"
> makes this patch series acceptable?

That would seem to at least make all the filesystem code happier, and
they can continue to do just something like

   #define ext2_set_bit __set_bit_le

(or whatever the exact sequence ends up being).

> Or do we also need to change *_bit_le() to handle unaligned address
> correctly?  (i.e. not only long aligned address but also byte aligned
> address)

No, I don't think that is required. We've never done it before, and
we've never had the type-safety for the little-endian (aka "minix")
bitops historically. So I'd just keep the status quo.

              Linus
