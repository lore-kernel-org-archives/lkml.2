Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab1IVR5O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 13:57:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20685 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370Ab1IVR5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 13:57:13 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: jens.axboe@fusionio.com
Cc: linux-kernel@vger.kernel.org
Subject: blk_classic tracing horribly broken
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 22 Sep 2011 13:57:11 -0400
Message-ID: <x491uv8h348.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've stared at the code for a while, and I've come up empty.  Would
anyone care to take a stab at fixing this?

To reproduce:

mount -t debugfs none /sys/kernel/debug
cd /sys/kernel/debug/tracing
echo blk > current_tracer
echo 1 > events/block/enable
echo 1 > options/blk_classic
echo 1 > tracing_on

dd if=/dev/<device> of=/dev/null bs=1M count=1 iflag=direct
cat trace

This is what I see:

# tracer: blk
#
# DEV   CPU TIMESTAMP     PID ACT FLG
#  |     |     |           |   |   |
Unknown action 52
Unknown action 52
Unknown action bce
Unknown action 52
Unknown action 52
Unknown action 52
Unknown action 52
Unknown action 52
Unknown action 52
Unknown action 0
Unknown action 0
Unknown action 0
Unknown action 0
Unknown action 0
Unknown action 0
Unknown action 0
Unknown action 0
Unknown action 0
Unknown action 0
Unknown action 0
Unknown action 0
Unknown action 0
  0,0    2   110.941937315  2584  F   R [pgrep]
Unknown action 52
Unknown action 52
Unknown action 231
Unknown action 0
Unknown action 0
Unknown action 0
Unknown action 0
  0,0    0   110.949383287  2584  F   R [pgrep]
Unknown action 52
Unknown action 52
Unknown action 7fd1
Unknown action 0
Unknown action 0
Unknown action 0
Unknown action 0
  0,0    3   110.984565328  2581  F   R [ps]
Unknown action 52
Unknown action 52
Unknown action 5ad1
Unknown action 0
Unknown action 0
Unknown action 0
Unknown action 0
  0,0    3   111.003843579  2581  F   R [ps]
Unknown action 52
Unknown action 52
Unknown action 7551
Unknown action 0
Unknown action 0
Unknown action 0
Unknown action 0

Cheers,
Jeff
