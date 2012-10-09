Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751172Ab2JIEUA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 00:20:00 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44182 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750820Ab2JIET6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 00:19:58 -0400
Date: Tue, 9 Oct 2012 13:19:50 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firmware: Don't attempt to allocate zero bytes with
 vmalloc()
Message-ID: <20121009041947.GB8237@opensource.wolfsonmicro.com>
References: <1349456731-19977-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <CACVXFVOuQosgF+w6k1RH5D360J4pTM-N=quiSCc=GmWt0102rA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVOuQosgF+w6k1RH5D360J4pTM-N=quiSCc=GmWt0102rA@mail.gmail.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 06:56:02AM +0800, Ming Lei wrote:

> Considered that zero-length firmware image doesn't make sense for drivers
> (callers), maybe it is a insane firmware image, so how about treating it as a
> failure?

It seems better to punt that decision to callers - for example, the case
I ran into this with was a driver that was using a zero length firmware
to say that it didn't want to load an optional image but also didn't
want to have to time out if that was the case.  That doesn't seem
unreasonable to me, and drivers already have to validate that what
they're getting makes sense.
