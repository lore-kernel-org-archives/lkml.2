Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758592Ab2C2IrK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 04:47:10 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51705 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab2C2IrA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 04:47:00 -0400
MIME-Version: 1.0
In-Reply-To: <1332960093_131068@CP5-2952>
References: <1332959199-32161-1-git-send-email-djkurtz@chromium.org>
 <1332959199-32161-3-git-send-email-djkurtz@chromium.org> <1332960093_131068@CP5-2952>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Thu, 29 Mar 2012 16:46:39 +0800
X-Google-Sender-Auth: ce0V32naYuo9kyJEWL6z36l3D68
Message-ID: <CAGS+omBkrjdrweGxS5r7KFyqx=JFVxy7_tqZsWTaGgfXu-VgtQ@mail.gmail.com>
Subject: Re: [PATCH 2/7 v6] drm/i915/intel_i2c: use double-buffered writes
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel@ffwll.ch>, Keith Packard <keithp@keithp.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>,
        Yufeng Shen <miletus@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 2:41 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Thu, 29 Mar 2012 02:26:34 +0800, Daniel Kurtz <djkurtz@chromium.org> wrote:
>> The GMBUS controller GMBUS3 register is double-buffered.  Take advantage
>> of this  by writing two 4-byte words before the first wait for HW_RDY.
>> This helps keep the GMBUS controller from becoming idle during long writes.
>>
>> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
>
> "For byte counts that are greater than four bytes, this register will be
> written with subsequent data only after the HW_RDY status bit is set"
>
> Hmm, I had interpretted that as should only be. But if you take into
> account that the register is indeed double-buffered, it does make sense
> that the hardware itself is only updated after the HW_RDY signal.
> Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>

In fact, during my experiments using the GMBUS interrupts, the HW_RDY
interrupt would only trigger for transactions > 4 bytes after 2 writes
to GMBUS3.


> -Chris
>
> --
> Chris Wilson, Intel Open Source Technology Centre
