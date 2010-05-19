Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284Ab0ESRXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 13:23:30 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:50826 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160Ab0ESRX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 13:23:28 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org
Subject: [RFC] linux-input: dynamically allocate ABS axis information
Date: Wed, 19 May 2010 19:22:33 +0200
Message-Id: <1274289757-2723-1-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To support more axis on input devices, we should dynamically allocate
ABS axis information. Currently, six values (value, min, max, fuzz,
flat and resolution) are stored in arrays, each of ABS_CNT elements.

The following four patches makes the input core reuse the input_absinfo
struct and only carry one pointer per axis. These structs are allocated
on demand now, making it less painful to add new ABS axis eventually.

As everything is now nicely abstracted, we might even move over to a
more efficient storage than a linear pointer, but that can be done
later.

I successfully tested this on my desktop machine here.

Let me know what you think.

Thanks,
Daniel

[PATCH 1/4] input: use ABS_CNT rather than (ABS_MAX + 1)
[PATCH 2/4] input: add static inline helpers for ABS properties
[PATCH 3/4] input: switch to input_abs_*() access functions
[PATCH 4/4] input: dynamically allocate ABS information
