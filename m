Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167Ab0CXQL4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 12:11:56 -0400
Received: from senator.holtmann.net ([87.106.208.187]:46197 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070Ab0CXQLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 12:11:55 -0400
Subject: Re: [PATCH 4/6] drivers:misc: sources for Init manager module
From: Marcel Holtmann <marcel@holtmann.org>
To: Pavan Savoy <pavan_savoy@yahoo.co.in>
Cc: Greg KH <gregkh@suse.de>, PavanSavoy <pavan_savoy@ti.com>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <359814.2971.qm@web94904.mail.in2.yahoo.com>
References: <359814.2971.qm@web94904.mail.in2.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Mar 2010 09:11:45 -0700
Message-ID: <1269447105.11714.117.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavan,


> I wanted to somehow put this in staging because then it would probably have a thorough architectural review process.
> Some details about this driver - 
> 
> 1. This driver will be used by Bluetooth-BlueZ/FM-V4L2 and GPS (probably character device driver) using the EXPORTED symbols (-register/_unregister).
> 
> 2. Much like the hciattach daemon which maintains N_HCI bluetooth line discipline, this driver will also have a User-Space  N_TI_WL Init manager (UIM) maintaining the Line discipline.

can you explain why you think this is needed and we can not interface
this directly. If it is a serial port, what protocol does it talk?

> 3. Because of the UIM should know when to install/uninstall line discipline, the /sys entry is created a root called UIM (a new kobject) and UIM daemon would write it's PID to it.

I don't understand this. This sounds like a broken concept to me.

> 4. As Alan suggested, If I make it self-contained by pushing number of line disciplines to a slightly larger number, then would it be OK ?

Just from a quick look, I think within a few review cycles this might be
able to get proper upstream inclusion. No idea why bother with staging
in the first place. Lets do this correctly.

Regards

Marcel


