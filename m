Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab1KCOHV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 10:07:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16190 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753873Ab1KCOHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 10:07:19 -0400
Date: Thu, 3 Nov 2011 10:07:16 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: sb_edac 32-bit compile fail due to 64-bit divide
Message-ID: <20111103140716.GF19809@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It seems the newly added EDAC driver for SandyBridge won't build on
32-bit x86 because of a 64-bit divide somewhere:

	drivers/edac/sb_edac.c: In function 'get_memory_error_data':
	drivers/edac/sb_edac.c:861:2: warning: left shift count >= width of type
	[enabled by default]
	<snip>
	ERROR: "__udivdi3" [drivers/edac/sb_edac.ko] undefined!
	make[1]: *** [__modpost] Error 1
	make: *** [modules] Error 2

You can find the full build log here:

http://koji.fedoraproject.org/koji/getfile?taskID=3482579&name=build.log

Before I go digging into where this is done and what to do about it, I
do want to confirm that it is supposed to work on a 32-bit kernel,
correct?

josh
