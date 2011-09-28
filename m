Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab1I1KKf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 06:10:35 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43961 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab1I1KKd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 06:10:33 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1109221524560.10719@utopia.booyaka.com>
References: <1316691479-1849-1-git-send-email-keshava_mgowda@ti.com>
	<1316691479-1849-2-git-send-email-keshava_mgowda@ti.com>
	<alpine.DEB.2.00.1109221213500.10719@utopia.booyaka.com>
	<4E7B8C68.7020407@ti.com>
	<alpine.DEB.2.00.1109221524560.10719@utopia.booyaka.com>
Date: Wed, 28 Sep 2011 18:10:31 +0800
Message-ID: <CACVXFVOVv_AeQv_834ca9FM2BK8Hd4jgggLDAGdhbeVyhiaycw@mail.gmail.com>
Subject: Re: [PATCH 1/5 v11] arm: omap: usb: ehci and ohci hwmod structures
 for omap4
From: Ming Lei <tom.leiming@gmail.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: "Cousson, Benoit" <b-cousson@ti.com>,
        "Munegowda, Keshava" <keshava_mgowda@ti.com>,
        "parthab@india.ti.com" <parthab@india.ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Balbi, Felipe" <balbi@ti.com>, "Gadiyar, Anand" <gadiyar@ti.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "Hilman, Kevin" <khilman@ti.com>,
        "johnstul@us.ibm.com" <johnstul@us.ibm.com>,
        "Sripathy, Vishwanath" <vishwanath.bs@ti.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Fri, Sep 23, 2011 at 7:31 AM, Paul Walmsley <paul@pwsan.com> wrote:

> The idea of the main_clk was not intended to be PRCM or OCP or even
> OMAP-specific.  It's just intended to represent a clock that is used to
> drive the register logic inside the IP block.  Therefore it must be
> enabled before any register access may occur.  Even if clock gating is
> handled by some higher-level interface (e.g., at the IP block level), the
> main_clk has a rate, so it also implies an upper limit on how quickly
> register operations can occur.  I suppose that all of the IP block's
> clocks could be "optional clocks," but we know that every IP block with
> registers requires at least one clock to work, and that should be the
> main_clk.

I am a bit confused about you comment on "main_clk".

>From hwmod related source code, main_clk is the function clock
of one module(hwmod), such as: on omap4, for uart3, main_clk is
uart3_fck.

But from[1] and [2] of omap4 PRM, we can find that interface clock
is required to provide register access instead of function clock.

This is a bit conflictive with what you description, so could you
give a further comments about main_clk, function clock and interface
clock?


[1], 23.3.4.2 Clock Configuration
	Each UART uses a 48-MHz functional clock for its logic
	and to generate external interface signals. Each UART
	uses an interface clock for register accesses.

[2], 3.1.1.1.1 Module Interface and Functional Clocks
	The interface clocks have the following characteristics:
	• They ensure proper communication between any module/subsystem
	and the interconnect.
	• In most cases, they supply the system interconnect interface
	and registers of the module.

thanks,
-- 
Ming Lei
