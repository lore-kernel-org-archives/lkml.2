Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab1DVByU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 21:54:20 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50399 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755764Ab1DVByT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 21:54:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=FF8yD3kQ6fFA20WeCJyKsdfsN6JSYke0fHPBfB2NEVcsMBWTBDQDs4U6YGH7UzTamr
         ag9Sol937o12KX5NAS4Cuslhk59E1wAmjvWfM18gEzE+iGhZ1jHrLIl//QRxgPrWNOho
         1jMRfS4bYx05pwHO/2ssCz4xVY/gBjFrGb/W8=
MIME-Version: 1.0
From: Paul Alfille <paul.alfille@gmail.com>
Date: Thu, 21 Apr 2011 21:53:39 -0400
Message-ID: <BANLkTimhyTLuKw90Q6HitVgLC7wyeOD5wQ@mail.gmail.com>
Subject: w1 driver for omap error -- reversed byte sequence in netlink slave message
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OWFS (one-wire filesystem -- www.owfs.org) seems to be the only user
of the w1 netlink messages. We use them to extend the kernel 1-wire
system from a simple temperature sensor to a complete 1-wire bus
master. Thus we've uncovered a bug -- byte reversal -- in one of the
sub-modules.

1-wire devices have a unique 64-bit address (including an 8-bit CRC)
that is reported by the netlink W1_CMD_SEARCH message. For the omap
bus master, and only the omap bus master, the slave addresses are
byte-order reversed. If the slave byte order is reversed in that case,
the CRC8 is then correct, the slave address then matches the actual
device address lettered on the device, and all other commands work
correctly.

The driver is in kernel/drivers/w1/masters/omap_hdq.c

Paul Alfille
