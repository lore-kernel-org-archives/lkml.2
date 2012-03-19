Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758374Ab2CSI0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 04:26:46 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55712 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979Ab2CSI0m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 04:26:42 -0400
MIME-Version: 1.0
In-Reply-To: <20120319080402.GA15965@polaris.bitmath.org>
References: <1331640263-18935-1-git-send-email-djkurtz@chromium.org>
 <1331640263-18935-7-git-send-email-djkurtz@chromium.org> <20120319080402.GA15965@polaris.bitmath.org>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Mon, 19 Mar 2012 16:26:21 +0800
X-Google-Sender-Auth: JkjQ9v_ux1S_otULfoU31elhwGw
Message-ID: <CAGS+omBrdvwM5W31TShbBtqzdSnpQhvBA4fb6-fsy5ovYOXmNQ@mail.gmail.com>
Subject: Re: [PATCH 06/20] Input: atmel_mxt_ts - allow writing to object sysfs entry
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Iiro Valkonen <iiro.valkonen@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>,
        Yufeng Shen <miletus@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 4:04 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
>
> Hi Daniel,
>
> > Userspace can write a 24-bit value (encoded as a 6 character hex string)
> > to the 'object' sysfs entry to modify a single byte of the object table.
> > The hex string encodes a 3 bytes, in the following format:
> >  TTFFVV
> >
> > Where:
> >  TT = object type
> >  FF = object offset
> >  VV = byte value
> >
> > The object table is modified in device ram, which means the change is
> > volatile, and will be overwritten on the next device reset.  To make
> > changes permanent, the new settings should be persisted in the device's
> > Non-Voltatile Memory using the updatenv sysfs entry.
> >
> > Also, since the device driver initializes itself by reading some values
> > from the object table, the entire driver may need to be unloaded and
> > reloaded after writing the values for the driver to stay in sync.
> >  Whether
> > this is required depends on exactly which values were updated.
> >
> > Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> > ---
>
> Perhaps you could give an example of why this is needed?
>
> Thanks,
> Henrik

The idea is to allow a a device to be calibrated via userspace.  The
atmel devices have many registers for tuning properties of their
firmware.
This would be used, for example, to program an initial calibration on
a factory floor, or, to tune a device at runtime.  Currently, the only
way devices are configured and calibrated is for a system integrator
to embed the entire calibration in the kernel via a binary blob in
platform_data.

Thanks,
-Daniel
