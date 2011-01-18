Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445Ab1AREZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 23:25:44 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49161 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab1AREZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 23:25:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mE9hVDVP8YslZn2Y8gCLu6bO2j3zUJJ3C5mSHVHNDk6WMh41cdUgNZ45AhbbPGlgxz
         xPM43yXRQBFf9hE6YlFJnuhUGVm7U4qBe8+1aCsA6Z08NpOz9RPhrD7CMweZATajeGqP
         sUDVTmdA3o20dJO0jolOW2Rql1QiArDpQRPjQ=
Date: Mon, 17 Jan 2011 20:25:35 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, Cyril Chemparathy <cyril@ti.com>,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 04/16] input: tnetv107x-touchscreen: don't treat NULL clk
 as an error
Message-ID: <20110118042535.GA23781@core.coreip.homeip.net>
References: <1294749833-32019-1-git-send-email-jamie@jamieiles.com>
 <1294749833-32019-5-git-send-email-jamie@jamieiles.com>
 <20110112055640.GC22944@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110112055640.GC22944@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 09:56:41PM -0800, Dmitry Torokhov wrote:
> On Tue, Jan 11, 2011 at 12:43:41PM +0000, Jamie Iles wrote:
> > clk_get() returns a struct clk cookie to the driver and some platforms
> > may return NULL if they only support a single clock.  clk_get() has only
> > failed if it returns a ERR_PTR() encoded pointer.
> > 
> > Cc: Cyril Chemparathy <cyril@ti.com>
> > Cc: linux-input@vger.kernel.org
> > Signed-off-by: Jamie Iles <jamie@jamieiles.com>
> 
> Applied both, thank you Jamie.
> 

Actually, if we pass clk that is NULL along we going to get oops on many
arches, so I am going to change it to IS_ERR_OR_NULL.

Thanks.

-- 
Dmitry
