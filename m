Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399Ab1EDPHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 11:07:46 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49083 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab1EDPHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 11:07:46 -0400
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, cbouatmailru@gmail.com, linux@arm.linux.org.uk,
        tglx@linutronix.de, arnd@arndb.de, nico@fluxnic.net,
        alan@lxorguk.ukuu.org.uk, Jamie Iles <jamie@jamieiles.com>
Subject: [RFC PATCH 0/3] Use basic_mmio_gpio to implement a generic gpio chip
Date: Wed,  4 May 2011 16:07:34 +0100
Message-Id: <1304521657-8527-1-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is based on my earlier set of GPIO patches[1] to extend the
basic_mmio_driver to be used as a library to implement a more generic gpio
chip as initially implemented by Anton Vorontsov[2].

I've modified Anton's patch slightly to allow the bgpio_chip to be embedded
into another structure and converted two drivers over - bt8xxgpio and
langwell.  bt8xxgpio seems to play nicely, but langwell not so much as it
didn't previously use a gpio_chip per bank but it is a nice illustration.

Note that this is the same set of patches as attached in "Re: [PATCHv3 0/7]
gpio: extend basic_mmio_gpio for different controllers" but reposted as a set
of patches for convenience.

1. http://article.gmane.org/gmane.linux.kernel/1124700
2. http://lkml.org/lkml/2011/4/19/401

Jamie Iles (3):
  basic_mmio_gpio: split into a gpio library and platform device
  gpio/bt8xxgpio: convert to use basic_mmio_gpio library
  gpio/langwell: convert to use basic_mmio_gpio library

 drivers/gpio/Kconfig            |    8 +
 drivers/gpio/Makefile           |    1 +
 drivers/gpio/basic_mmio_gpio.c  |  317 +++++++++++++++++++++------------------
 drivers/gpio/bt8xxgpio.c        |  119 +++------------
 drivers/gpio/langwell_gpio.c    |  253 +++++++++++++++----------------
 include/linux/basic_mmio_gpio.h |   55 +++++++
 6 files changed, 381 insertions(+), 372 deletions(-)

-- 
1.7.4.4

