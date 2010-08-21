Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385Ab0HUDol (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 23:44:41 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:53129 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab0HUDoj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 23:44:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=BuA/2mHa3mbKqtNDTeHIflK76g1pGxCGS1t+g8NDj9NCjzoUVDgwaSnG9ncqteyN8v
         yx+1+tWVe1l2HBBA373yGdhFz/oEPRl5/HRPu5zZGAEXnzKMPzFxbaFjtRMpb4A8IooU
         1bSG3f2Y1v6XGIG8sh48GWl9vEiAC6Jyd71pE=
MIME-Version: 1.0
Date: Fri, 20 Aug 2010 23:44:38 -0400
Message-ID: <AANLkTi=Kd303+KV6+QHVuZnLq23czS_5W0yYtX-FdRJT@mail.gmail.com>
Subject: Linux 2.6.35.3
From: Mark Stanovich <mrktimber@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After updating to the 2.6.35.3 stable release, my machine was
rebooting automatically during the first few seconds of boot.

I bisected to the first bad commit of

commit 568132624386f53e87575195d868db
9afb2e9316
Author: H. Peter Anvin <hpa@zytor.com>
Date:   Tue Jul 27 17:01:49 2010 -0700

    x86: Add memory modify constraints to xchg() and cmpxchg()

    commit 113fc5a6e8c2288619ff7e8187a6f556b7e0d372 upstream.

    xchg() and cmpxchg() modify their memory operands, not merely read
    them.  For some versions of gcc the "memory" clobber has apparently
    dealt with the situation, but not for all.

I noticed that the latest version pulled from Linus's git tree did not
have the problem.  After looking at the changes to
arch/x86/include/asm/cmpxchg_32.h, I cherry-picked two patches from
Linus's tree that seemed to make a difference, namely:

69309a05907546fb686b251d4ab041c26afe1e1d
4532b305e8f0c238dd73048068ff8a6dd1380291

Applying these patches solved the rebooting problem on 2.6.35.3

I believe the same problem also happens for the latest stable version
of 2.6.34, but did not verify the fix worked for the 2.6.34 stable
releases.

I don't know if this is helpful, but I thought I would let you know in
case someone else is having the same problem.

If you need any further information, just let me know.

    - Mark
