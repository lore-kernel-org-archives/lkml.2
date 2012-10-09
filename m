Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105Ab2JIHFd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 03:05:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41755 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab2JIHFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 03:05:31 -0400
MIME-Version: 1.0
In-Reply-To: <20121009041947.GB8237@opensource.wolfsonmicro.com>
References: <1349456731-19977-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	<CACVXFVOuQosgF+w6k1RH5D360J4pTM-N=quiSCc=GmWt0102rA@mail.gmail.com>
	<20121009041947.GB8237@opensource.wolfsonmicro.com>
Date: Tue, 9 Oct 2012 15:05:30 +0800
Message-ID: <CACVXFVOT+_nWxZOV0hckVrJwafgb_qr35eKaYg9j=toEJ2DNMQ@mail.gmail.com>
Subject: Re: [PATCH] firmware: Don't attempt to allocate zero bytes with vmalloc()
From: Ming Lei <ming.lei@canonical.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 9, 2012 at 12:19 PM, Mark Brown
> It seems better to punt that decision to callers - for example, the case

In fact, -ENOENT is returned to caller for non-direct loading situation,
see_request_firmware_load().

I understand drivers(caller) may be cheated if a zero-length firmware
image is obtained. In normal situation, one firmware image should
include something, instead of nothing, :-)

> I ran into this with was a driver that was using a zero length firmware
> to say that it didn't want to load an optional image but also didn't
> want to have to time out if that was the case.  That doesn't seem

If so, I am wondering why the driver has to call request_firmware()?
Looks just bypassing request_firmware() is fine for the driver, doesn't it?

Thanks,
--
Ming Lei
