Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab2JIHN5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 03:13:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43612 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751235Ab2JIHNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 03:13:54 -0400
Date: Tue, 9 Oct 2012 16:13:45 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firmware: Don't attempt to allocate zero bytes with
 vmalloc()
Message-ID: <20121009071343.GW8237@opensource.wolfsonmicro.com>
References: <1349456731-19977-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <CACVXFVOuQosgF+w6k1RH5D360J4pTM-N=quiSCc=GmWt0102rA@mail.gmail.com>
 <20121009041947.GB8237@opensource.wolfsonmicro.com>
 <CACVXFVOT+_nWxZOV0hckVrJwafgb_qr35eKaYg9j=toEJ2DNMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVOT+_nWxZOV0hckVrJwafgb_qr35eKaYg9j=toEJ2DNMQ@mail.gmail.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 03:05:30PM +0800, Ming Lei wrote:
> On Tue, Oct 9, 2012 at 12:19 PM, Mark Brown

> > It seems better to punt that decision to callers - for example, the case

> In fact, -ENOENT is returned to caller for non-direct loading situation,
> see_request_firmware_load().

> I understand drivers(caller) may be cheated if a zero-length firmware
> image is obtained. In normal situation, one firmware image should
> include something, instead of nothing, :-)

Hrm, that didn't seem to be happening for me - the firmware load
completed successfully.  Have to check how that happened.

> > I ran into this with was a driver that was using a zero length firmware
> > to say that it didn't want to load an optional image but also didn't
> > want to have to time out if that was the case.  That doesn't seem

> If so, I am wondering why the driver has to call request_firmware()?
> Looks just bypassing request_firmware() is fine for the driver, doesn't it?

A driver has no way to tell if the firmware is there or not without
asking for it.
