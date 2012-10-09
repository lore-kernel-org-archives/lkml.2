Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab2JIMge (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 08:36:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40644 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754699Ab2JIMgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 08:36:31 -0400
Date: Tue, 9 Oct 2012 13:36:29 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firmware: Don't attempt to allocate zero bytes with
	vmalloc()
Message-ID: <20121009123629.GB11061@opensource.wolfsonmicro.com>
References: <1349456731-19977-1-git-send-email-broonie@opensource.wolfsonmicro.com> <CACVXFVOuQosgF+w6k1RH5D360J4pTM-N=quiSCc=GmWt0102rA@mail.gmail.com> <20121009041947.GB8237@opensource.wolfsonmicro.com> <CACVXFVOT+_nWxZOV0hckVrJwafgb_qr35eKaYg9j=toEJ2DNMQ@mail.gmail.com> <20121009071343.GW8237@opensource.wolfsonmicro.com> <CACVXFVN1sL1FwUx9t1kQZHW=J-v3_9gDj+jOH2wLgP_a+ywX7g@mail.gmail.com> <20121009074138.GB8237@opensource.wolfsonmicro.com> <CACVXFVONtkA5tUq3zcvrn6+RmC0_VLgeK5aR7g8yV2dJbgCysA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVONtkA5tUq3zcvrn6+RmC0_VLgeK5aR7g8yV2dJbgCysA@mail.gmail.com>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 08:02:18PM +0800, Ming Lei wrote:

> If loading via user space, timeout or not depends on userspace,
> at least udev won't timeout on non-existent firmware image.

This may be a mdev or old udev thing...  it's definitely prevelant.

> Also looks request_firmware_nowait() is better for the case, _nowait()
> can avoid unnecessary delay and speedup firmware loading if there
> are more than one firmware to load.

It doesn't really help as the ABI is such that you can only have one
request_firmware() in play at once (unless this changed since I last
looked at it).
