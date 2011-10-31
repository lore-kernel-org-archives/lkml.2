Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934476Ab1JaPVe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 11:21:34 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64021 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933027Ab1JaPVd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 11:21:33 -0400
MIME-Version: 1.0
Date: Mon, 31 Oct 2011 16:21:32 +0100
Message-ID: <CAHzZGExE0yVou+zUivL8DMRNY5w=HO7jVNmFdspN2gNgmRBtPA@mail.gmail.com>
Subject: Virutal tty device settings problem.
From: "dpc@ucore.info" <dpc@ucore.info>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm writing a virtual console driver for paravirtualized setup.

Use case: being able to access paravirtualized guest consoles from "domain 0".

It's similar to HVCS, as I've been analyzing how it works.


Basically in my driver there's a frontend and backend. Backend is used
by domain 0 exposing tty devices: each for every other guest. One can
attach cu/minicom to such device and access guest console.

The frontend is working on the other guest side and communicate via
shared memory/virtual IRQs with backend. It exposes on tty device for
system console / getty.


Little illustration:

|               GUEST 0               |                  |
 GUEST 1                 |
tty device <--> kernel backend driver <--> magic here <--> kernel
frontend driver <--> tty device
(minicom/cu)
                  (getty)


I have the communication working and my driver transmits bytes between
domain 0 and other systems. So the "magic here" can be considered a
bytestream. But I'm lost with all the modes, cr/nl etc. conversions.

I don't understand which part of the kernel is responsible for NL / CR
conversions, what modes should I use on each side of the driver and
stuff like this. At the moment, from what I understand it seems that
some of termios flags are handled above tty driver layer, and other
should be handled inside/below it. Can anyone point me to documents
explaining this things or explain how should I handle this so that the
scenario from the illustration is working seamlessly?

Any help will be much appreciated.
-- 
Dawid Ciężarkiewicz
