Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab2FRP2Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 11:28:25 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46506 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab2FRP2X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 11:28:23 -0400
MIME-Version: 1.0
In-Reply-To: <4FDF4345.40508@itdev.co.uk>
References: <1339992522-22073-1-git-send-email-djkurtz@chromium.org>
 <1339992522-22073-15-git-send-email-djkurtz@chromium.org> <4FDF4345.40508@itdev.co.uk>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Mon, 18 Jun 2012 23:28:01 +0800
X-Google-Sender-Auth: c2xhhJKWFvY0_2l15uSK-EFul64
Message-ID: <CAGS+omB9kixY29f7awPDaRc-t9t0LJ+Lwz=gBzUoXro5f9jYXg@mail.gmail.com>
Subject: Re: [PATCH 14/22 v4] Input: atmel_mxt_ts - don't re-read matrix after
 applying pdata
To: Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, linux-input@vger.kernel.org,
        Iiro Valkonen <iiro.valkonen@atmel.com>,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Olof Johansson <olofj@chromium.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 11:03 PM, Nick Dyer <nick.dyer@itdev.co.uk> wrote:
>
> Daniel Kurtz wrote:
> > The matrix x/y size in the Info ID Block represents the number of x/y
> > trace lines on the device.  There is no need to re-read them after
> > applying pdata config, since pdata only configures the object table
> > etnries.  The matrix size read from the ID can only be updated by a
> > firmware update.
>
> This isn't correct. For example, mXT224 can be configured as 16x14, 17x13,
> 18x12, etc. This only takes effect when the chip is reset, which is why it
> is necessary to re-read them after applying the config.

Ah, so is that what T46.1 (Mode) does?  I hadn't played with that yet.
Ok, I'll move this patch into the next series which cleans up all of
the configuration stuff.

-Dan

>
>
> cheers
>
> --
> Nick Dyer
> Software Engineer, ITDev Ltd
> Hardware and Software Development Consultancy
> Website: http://www.itdev.co.uk
