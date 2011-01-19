Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314Ab1ASQQX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 11:16:23 -0500
Received: from cantor.suse.de ([195.135.220.2]:56496 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754113Ab1ASQQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 11:16:22 -0500
Date: Wed, 19 Jan 2011 17:16:17 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Chris Wilson <chris@chris-wilson.co.uk>, David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: drm:i915_report_and_clear_eir -- *ERROR* EIR stuck: 0x00000010,
 masking
Message-ID: <alpine.LNX.2.00.1101191709260.29002@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am getting this during boot with current Linus' tree on x200s thinkpad:

[    8.312007] [drm:i915_report_and_clear_eir] *ERROR* EIR stuck: 0x00000010, masking

head -39 /sys/kernel/debug/dri/64/i915_error_state shows:

Time: 1295452835 s 347238 us
PCI ID: 0x2a42
EIR: 0x00000010
PGTBL_ER: 0x00000001
Render command stream:
  ACTHD: 0x00534024
  IPEIR: 0x00000000
  IPEHR: 0x02000000
  INSTDONE: 0xffffffff
  INSTDONE1: 0xbfbbffff
  INSTPS: 0x8001e025
  INSTPM: 0x00000000
  seqno: 0x00000000
  fence[0] = 00000000
  fence[1] = 00000000
  fence[2] = 00000000
  fence[3] = 00000000
  fence[4] = 00000000
  fence[5] = 00000000
  fence[6] = 00000000
  fence[7] = 00000000
  fence[8] = 00000000
  fence[9] = 00000000
  fence[10] = 00000000
  fence[11] = 00000000
  fence[12] = 00000000
  fence[13] = 00000000
  fence[14] = 00000000
  fence[15] = 00000000
Active [3]:
  00534000    16384 0009 0000 00000001 dirty render uncached
  00042000  5185536 0043 0000 00000001 P render uncached (name: 1)
  00538000 20971520 0002 0000 00000002 P X dirty render uncached
Pinned [4]:
  00000000     4096 0001 0001 00000000 P snooped
  00001000   131072 0001 0001 00000000 P uncached
  00021000     4096 0001 0001 00000000 P snooped
  00022000   131072 0001 0001 00000000 P uncached

Apart from the error in the kernel buffer, graphics seems to work 
normally.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
