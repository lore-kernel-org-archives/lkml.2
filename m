Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758912Ab2C2JZC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 05:25:02 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38764 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758842Ab2C2JYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 05:24:50 -0400
Date: Thu, 29 Mar 2012 11:25:32 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Daniel Vetter <daniel@ffwll.ch>,
        Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>
Subject: Re: [PATCH 5/7 v6] drm/i915/intel_i2c: use INDEX cycles for i2c read
 transactions
Message-ID: <20120329092532.GF4106@phenom.ffwll.local>
Mail-Followup-To: Daniel Kurtz <djkurtz@chromium.org>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	Benson Leung <bleung@chromium.org>,
	Yufeng Shen <miletus@chromium.org>
References: <1332959199-32161-1-git-send-email-djkurtz@chromium.org>
 <1332959199-32161-6-git-send-email-djkurtz@chromium.org>
 <1332960747_131180@CP5-2952>
 <CAGS+omBWDoc2YiKPmBJ7=iEr+1DFBZp0EDCpPwP9c7FcbC4iew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGS+omBWDoc2YiKPmBJ7=iEr+1DFBZp0EDCpPwP9c7FcbC4iew@mail.gmail.com>
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 04:37:18PM +0800, Daniel Kurtz wrote:
> On Thu, Mar 29, 2012 at 2:52 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> > On Thu, 29 Mar 2012 02:26:37 +0800, Daniel Kurtz <djkurtz@chromium.org> wrote:
> >> It is very common for an i2c device to require a small 1 or 2 byte write
> >> followed by a read.  For example, when reading from an i2c EEPROM it is
> >> common to write and address, offset or index followed by a reading some
> >> values.
> >
> > Hmm, I have
> >
> > "gmbus1, bits 8-15: 8-bit GMBUS slave register
> > This field is redundant and should not be used."
> >
> > Scary. :)
> 
> Perhaps INDEX ops are only available on some chipsets?
> Is this something you can double check?

I think index ops are available, the text sounds more like a hint to the
programmer that for VCH devices you should use word reg index access (i.e.
gmbus 5). We'll see when it blows up.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
