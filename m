Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933345Ab0I0SbD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 14:31:03 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:58402 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932448Ab0I0SbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 14:31:01 -0400
Subject: Staging: vt6655/vt6656 security issues
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: gregkh@suse.de
Cc: security@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Sep 2010 14:30:56 -0400
Message-ID: <1285612256.10963.44.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on a brief glance looking for security issues, I just wanted to
mention that these drivers are nowhere near ready to be added to the
main kernel.  I'm not interested in developing these drivers further,
but there are at least six stack buffer overflows:

vt6655/wpactl.c: wpa_set_keys(), line 239
vt6655/wpactl.c: wpa_set_keys(), line 280
vt6655/wpactl.c: wpa_set_associate(), line 770 (reported by Dan
Carpenter)

vt6656/wpactl.c: wpa_set_keys(), line 239
vt6656/wpactl.c: wpa_set_keys(), line 279
vt6656/wpactl.c: wpa_set_associate(), line 779

And four heap corruption issues due to integer overflow in the
allocation size:

vt6655/ioctl.c: private_ioctl(), line 329
vt6655/ioctl.c: private_ioctl(), line 625

vt6656/ioctl.c: private_ioctl(), line 326
vt6656/ioctl.c: private_ioctl(), line 615

They are all caused by unchecked copy_from_user() calls with
user-provided length fields or kmalloc() calls with arithmetic on
user-provided sizes.  This kind of sloppiness suggests there are almost
certainly other major security issues in this code.

Regards,
Dan

