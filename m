Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab1J0QF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 12:05:29 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35738 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835Ab1J0QF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 12:05:28 -0400
MIME-Version: 1.0
Date: Thu, 27 Oct 2011 18:05:28 +0200
Message-ID: <CAHyw2gzeo0_tL1yKt0C7maVgjkFkvfJxp6oGFqqgV4WBSLcseQ@mail.gmail.com>
Subject: NFS v3 client random-writes slowdown since around 2.6.17 ?
From: David Le Corfec <dlecorfec@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While investigating a strange MySQL performance regression (amongst an
overall improvement) going from an older hardware running SLES10 SP1
(2.6.16.54) to a newer one running RHEL5 (2.6.18-274), I noticed that
random NFS v3 writes in "big" (2+ GB) files were apparently slower in
"recent" kernels. Stracing MySQL showed me the time taken by the
pwrite() calls was much different between the two OSes.

Stracing a simple pwrite() loop using random offsets, write to the
same NFS volume (on a NetApp server), I had that kind of value for a
single call to pwrite on physical x86_64 servers:
* CentOS 4.9 (2.6.9-100): < 0.02 ms
* SLES10 SP1 (2.6.16-54): < 0.02 ms
* RHEL 5.7 (2.6.18-274): > 0.2 ms
* CentOS 6.0 (2.6.32.?): > 0.2 ms
* openSUSE 11.4 (2.6.37.1): > 0.2 ms

The time taken by the calls in the 2.6.18+ kernels can sometimes even
be greater than 1 ms.
You can find my test program here: http://pastebin.com/VY4WhQPj

I didn't see any problem with sequential writes, random reads, or a
local ext3/4 volume. I tried to vary hardware and nfs server but it
didn't have an noticeable effect.
Mount options: rw,noatime,nolock,noacl,tcp,nfsvers=3,bg,hard,intr,rsize=32768,wsize=32768

Has someone any information/pointer about what happened ? Is it
related to the various NFS and SUNRPC counters added in 2.6.17 ?

David
