Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab0HAJCQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 05:02:16 -0400
Received: from www17.your-server.de ([213.133.104.17]:40674 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756060Ab0HAJCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 05:02:14 -0400
From: Thomas Meyer <thomas@m3y3r.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 1 Aug 2010 11:01:00 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc6+; KDE/4.4.5; i686; ; )
MIME-Version: 1.0
Subject: 2.6.35-rc6+: i915: Bisected regression
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008011101.01429.thomas@m3y3r.de>
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit makes suspend to ram unreliable for me:

commit d1b851fc0d105caa6b6e3e7c92d2987dfb52cbe0
Author: Zou Nan hai <nanhai.zou@intel.com>
Date:   Fri May 21 09:08:57 2010 +0800

    drm/i915: implement BSD ring buffer V2
    
    The BSD (bit stream decoder) ring is used for accessing the BSD engine
    which decodes video bitstream for H.264 and VC1 on G45+.  It is
    asynchronous with the render ring and has access to separate parts of
    the GPU from it, though the render cache is coherent between the two.
    
    Signed-off-by: Zou Nan hai <nanhai.zou@intel.com>
    Signed-off-by: Xiang Hai hao <haihao.xiang@intel.com>
    Signed-off-by: Eric Anholt <eric@anholt.net>

git revert didn't work on 2.6.35-rc6 so I just changed the HAS_BSD thing to:

#define HAS_BSD(dev)            (0)

with this change applied suspend to ram is back to the reliability of 2.6.34.y

with kind regards
thomas
