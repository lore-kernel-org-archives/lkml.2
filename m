Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894Ab0DZTkO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 15:40:14 -0400
Received: from tex.lwn.net ([70.33.254.29]:58492 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754764Ab0DZTkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 15:40:12 -0400
Date: Mon, 26 Apr 2010 13:40:08 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Harald Welte <laforge@gnumonks.org>, linux-kernel@vger.kernel.org,
       Deepak Saxena <dsaxena@laptop.org>, linux-fbdev@vger.kernel.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn
Subject: Re: [PATCH 10/11] viafb: rework the I2C support in the VIA
 framebuffer driver
Message-ID: <20100426134008.0276261b@bike.lwn.net>
In-Reply-To: <4BD46619.5010701@gmx.de>
References: <1271614873-5952-1-git-send-email-corbet@lwn.net>
	<1271614873-5952-11-git-send-email-corbet@lwn.net>
	<4BD20D56.7080402@gmx.de>
	<20100423155725.7d3b2d2d@bike.lwn.net>
	<4BD221E7.7060705@gmx.de>
	<20100423165256.654ca5eb@bike.lwn.net>
	<4BD22B96.5020102@gmx.de>
	<4BD2CC46.4060908@gmx.de>
	<20100424073359.349b4397@bike.lwn.net>
	<20100424135316.GR24811@prithivi.gnumonks.org>
	<20100425083858.269bf0d8@bike.lwn.net>
	<4BD46619.5010701@gmx.de>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Apr 2010 17:56:09 +0200
Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:

> +		if (viafb_lvds_identify_vt1636(VIA_I2C_ADAP_26)) {
> which should rather be
> -		viaparinfo->shared->i2c_stuff.i2c_port = GPIOPORTINDEX;
> -		if (viafb_lvds_identify_vt1636()) {
> +		if (viafb_lvds_identify_vt1636(VIA_I2C_ADAP_2C)) {
> after which your patches including this work fine (on VX800 and CLE266).

Two bugs, actually...I wouldn't expect things to work with the wrong
port, but neither should it crash.  The crash is fixed in the second
series (where I added checks to ensure that the adapter was active) so
I'll probably leave it as-is in between.  The port number needs to be
fixed, though, thanks for catching that.

jon
