Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789Ab2DGBwv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 21:52:51 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52095 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755634Ab2DGBwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 21:52:07 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2 13/13] ARM: at91: dt: remove unit-address part for memory nodes
To: Olof Johansson <olof@lixom.net>, Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: arnd@arndb.de, devicetree-discuss@lists.ozlabs.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        ludovic.desroches@atmel.com, plagnioj@jcrosoft.com,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <20120404191754.GE10603@quad.lixom.net>
References: <cover.1333437885.git.nicolas.ferre@atmel.com> <1db62b280314855c35cb7a3188fc9d9cb8501948.1333437885.git.nicolas.ferre@atmel.com> <20120404191754.GE10603@quad.lixom.net>
Date: Fri, 06 Apr 2012 18:43:30 -0700
Message-Id: <20120407014330.B6D4E3E22DF@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2012 12:17:54 -0700, Olof Johansson <olof@lixom.net> wrote:
> On Tue, Apr 03, 2012 at 09:32:57AM +0200, Nicolas Ferre wrote:
> > From: Ludovic Desroches <ludovic.desroches@atmel.com>
> > 
> > Having a unit-address different from 0 causes bad memory node detection
> > during early_init_dt_scan_memory.
> 
> Sounds like a bug in the generic code to me? But specifying a unit
> address on a non-ambiguous device node isn't necessary anyway, so this
> patch is still a reasonable thing to do.

It's actually a 'feature' of the way we're including skeleton.dtsi.
skeleton.dtsi has already set the node name, so if the next file
doesn't use exactly the same node name then the .dtb ends up with two
memory nodes, which is really bad.

It real problem is the dtc tooling.

g.

