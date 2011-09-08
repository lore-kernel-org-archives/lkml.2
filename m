Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137Ab1IHXfB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:35:01 -0400
Received: from relais.videotron.ca ([24.201.245.36]:49605 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210Ab1IHXe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:34:56 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Thu, 08 Sep 2011 16:33:00 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Kbuild: allow code re-use across different directories
In-reply-to: <CACqU3MXcksYxdV_=OR40fPeZzu1ygr-Qs79TV6kfn0DpbXhjuA@mail.gmail.com>
Message-id: <alpine.LFD.2.00.1109081617440.20358@xanadu.home>
References: <1313800642-32418-1-git-send-email-lacombar@gmail.com>
 <alpine.LFD.2.00.1109071437400.20358@xanadu.home>
 <CACqU3MVF8XSdKi0PeZF5SFaH9i2HPqCjkMqccyb83x4V_1Vs1g@mail.gmail.com>
 <alpine.LFD.2.00.1109071554480.20358@xanadu.home>
 <CACqU3MXcksYxdV_=OR40fPeZzu1ygr-Qs79TV6kfn0DpbXhjuA@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Sep 2011, Arnaud Lacombe wrote:

> you missed:
> 
>  # Make sure files are removed during clean
> -extra-y       += piggy.gzip piggy.lzo piggy.lzma lib1funcs.S
> +extra-y       += piggy.gzip piggy.lzo piggy.lzma
> 
> This confused make.

Well... that was suttle.

So yes, your patch may certainly be useful to a couple cases, and it 
works fine for this lib1func.S.

It doesn't help me much in the following situation though.  What I 
actually want to achieve is to compile arch/arm/boot/compressed/fdt_rw.o 
from scripts/dtc/libfdt/fdt_rw.c, however I want it to include my local 
version of libfdt_env.h rather than scripts/dtc/libfdt/libfdt_env.h.  I 
still haven't found a way to convince gcc to do that.


Nicolas
