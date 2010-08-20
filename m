Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751626Ab0HTCZr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 22:25:47 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:50400 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab0HTCZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 22:25:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=qlExdfV7YJq3shwyr6/fvUH4/eTkSDuQnDKsAE9k3jEEWFK1uzHZYo0IoplkxL3tF+
         appjh2r2AZb2nbT+05m6N4EZC3EfXayUjZXWLZ9guxQr6Jak7uw0mbnG7OjlfGumLMzj
         K71mQ7Xn782lqS2hg0+sVvJ7+yCM3dc0ytiSM=
Message-ID: <4C6DE7E3.4030702@lwfinger.net>
Date: Thu, 19 Aug 2010 21:26:43 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>
CC: "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Regression in 2.6.36-rc1 bisected to commit 9d8888c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With 2.6.36-rc1 from the mainline git tree, my x86_64 system running on an AMD
Turion 64 x2 TL-60 has required pressing keys to get booting to advance. This
behavior begins as soon as the kernel is loaded. I bisected the problem to:

commit 9d8888c2a214aece2494a49e699a097c2ba9498b
Author: Hans Rosenfeld <hans.rosenfeld@amd.com>
Date:   Wed Jul 28 19:09:31 2010 +0200

    x86, cpu: Clean up AMD erratum 400 workaround

    Remove check_c1e_idle() and use the new AMD errata checking framework
    instead.

    Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
    LKML-Reference: <1280336972-865982-2-git-send-email-hans.rosenfeld@amd.com>
    Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>

Reverting this patch allows the current 2.6.36-rc1+ to boot normally.

This problem is entered into the Kernel Bugzilla as Bug #16636.

Larry
