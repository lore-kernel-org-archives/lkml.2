Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab1ASRh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 12:37:56 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47658 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742Ab1ASRhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 12:37:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type;
        b=oA9vDBctzO7LFnDMWPsyKjQ8qG5RHO9bvmDi0or3OXtS+b5UiFd04pe1LDycpQF+8Q
         IVS2EwrSbC6ToYOYz9/6eYWjJPb9qJatH9Db1QulfYZCF9L6djEc0R6G4Pun/XPecLsJ
         x8mcne129MhlZQwnYMgpK5i9JLDQjkiyFCdqk=
MIME-Version: 1.0
Date: Wed, 19 Jan 2011 17:36:57 +0000
X-Google-Sender-Auth: y9YVebyE_j1irbnpt-fj4MTt3ss
Message-ID: <AANLkTim3ByCpF6SrvwZcSt_WL4gEJw-df_vZa+g0gEtX@mail.gmail.com>
Subject: Re: Linux 2.6.38-rc1 -- early boot hangs (x86: Make relocatable
 kernel work with new binutils)
From: Andy Whitcroft <apw@canonical.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that the commit below is triggering early boot hangs for me,
with CONFIG_RELOCATABLE=y:

  commit 86b1e8dd83cbb0fcbf3d61d2b461df8be1f528cf
  Author: Shaohua Li <shaohua.li@intel.com>
  Date:   Tue Jan 18 08:57:49 2011 +0800

    x86: Make relocatable kernel work with new binutils

    The CONFIG_RELOCATABLE=y option is broken with new binutils, which will make
    boot panic.

Reverting that one commit sorts things out.

-apw
