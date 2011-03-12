Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab1CLST3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 13:19:29 -0500
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:57057 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754923Ab1CLST2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 13:19:28 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: linux-media@vger.kernel.org
Subject: radio-maestro broken (conflicts with snd-es1968)
Date: Sat, 12 Mar 2011 19:19:00 +0100
User-Agent: KMail/1.9.10
Cc: alsa-devel@alsa-project.org,
        Kernel development list <linux-kernel@vger.kernel.org>,
        jirislaby@gmail.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201103121919.05657.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
the radio-maestro driver is badly broken. It's intended to drive the radio on 
MediaForte ESS Maestro-based sound cards with integrated radio (like 
SF64-PCE2-04). But it conflicts with snd_es1968, ALSA driver for the sound 
chip itself.

If one driver is loaded, the other one does not work - because a driver is 
already registered for the PCI device (there is only one). This was probably 
broken by conversion of PCI probing in 2006: 
ttp://lkml.org/lkml/2005/12/31/93

How to fix it properly? Include radio functionality in snd-es1968 and delete 
radio-maestro?

-- 
Ondrej Zary
