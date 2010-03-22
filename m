Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755Ab0CVVP1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 17:15:27 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:62239 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736Ab0CVVP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 17:15:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=aarUmRGO8SxSFP4u2PvqFdR2gUn4D81nkx88JbUfPmcGlc85zjEcFe5yJzMOlYIYi8
         wolD29IkIJ4Qq9VsxRb5OMcPLoY9Pun/r/Zj2zSM40NO0Xn9CzwkLohMymBlHfojsdR0
         G+5rkgbD8hjK02hkbrhtKBPdLdVLh5tNI2rFQ=
From: Chris Clayton <chris2553@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: Build error with v2.6.34-rc2-51-g7b1f513
Date: Mon, 22 Mar 2010 21:15:21 +0000
User-Agent: KMail/1.9.10
Cc: anton@samba.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003222115.21861.chris2553@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Commit 45575f5a426c01ec68cd33d998267ba2f6278fac seems to be causing the build 
error shown below on i386:

  CC      ipc/syscall.o
  ipc/syscall.c:17: error: conflicting types for 'sys_ipc'
  include/linux/syscalls.h:691: note: previous declaration of 'sys_ipc' was 
here
  make[1]: *** [ipc/syscall.o] Error 1
  make: *** [ipc] Error 2
  make: *** Waiting for unfinished jobs....

I can see that changing the type of the third arg to sys_ipc in 
include/linux/syscalls.h would probably avoid the error, but I am not 
knowledgeable enough to know whether that would be the right thing to do.

Happy to test a patch, but please cc me as I'm not subscribed.

Chris
-- 
Beauty is in the eye of the beerholder
