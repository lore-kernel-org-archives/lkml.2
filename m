Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934497Ab0KQH0c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 02:26:32 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:33844 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933223Ab0KQH0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 02:26:31 -0500
Date: Wed, 17 Nov 2010 16:25:53 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, g.liakhovetski@gmx.de,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH 01/05] fbdev: sh_mipi_dsi: Remove request/release mem region
Message-ID: <20101117072553.GB10671@linux-sh.org>
References: <20101117064405.18139.57035.sendpatchset@t400s> <20101117064415.18139.28996.sendpatchset@t400s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117064415.18139.28996.sendpatchset@t400s>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 03:44:15PM +0900, Magnus Damm wrote:
> The driver core already manages resources for us, so
> there is no need to perform request_mem_region() and
> release_mem_region() in the MIPI-DSI driver.
> 
No. This comes up time and time again for some reason, I'm not sure why
this misconception keeps being propagated (and it's definitely a mistake
I've made myself too!)

The driver core simply takes your resources and inserts them in to the
resource tree, it has nothing to do with requesting ranges, or checking
for conflicts. The main rationale for this is that drivers (think MFDs)
may pass in a large resource range, which in turn will be broken up and
requested by individual drivers nested underneath it. Only at request
time will the requested range (which can be the entire thing, or a
subset) be flagged as busy and conflicts detected.

The current logic is quite correct in what it is doing.
