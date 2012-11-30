Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab2K3Vyt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 16:54:49 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56021 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546Ab2K3Vyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 16:54:47 -0500
Date: Fri, 30 Nov 2012 13:54:06 -0800
From: Chris Moeller <kode54@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Chris Moeller <kode54@gmail.com>
Subject: [PATCH v2 0/1] Input: xpad - Implement wireless controller LED
 setting and fix connect time LED setting
Message-ID: <20121130135406.38c9bdc9@umaro.lan>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.13; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've submitted versions of this with prior patch sets, and this part
was never accepted, possibly because it depended on other patches to
work, or possibly because it wasn't so cleanly organized. This time,
I've split the LED setting command off into its own static function,
then call that on controller connect and optionally on LED setting
commands. The static function does not include any locking, because
locking inside the function which receives the incoming packets
deadlocks the driver, and does not appear to be necessary anyway.

It also removes all traces of the original bulk out function which was
designed for the purpose of setting the LED status on connect, as I
found that it actually does not work at all. It appears to try to send
the data, but nothing actually happens to the controller LEDs.
