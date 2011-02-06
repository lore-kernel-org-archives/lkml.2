Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab1BFQtZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 11:49:25 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51352 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297Ab1BFQtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 11:49:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=sD/VfFmOLHQhNQdGL0Bu2MJjKuHRSwrd5vIQXMK5px+M9oMIvVS46g5HvJ9noTH4c1
         386nXXqPvarmjGFNjTUDr53W1TIou0wd4ULmkeZntgARFxXC/pSVmXeDqXiVbhqDeNnl
         AChFoOWE+COcK/eZKOtf/lGF207sNSMn5aCLM=
MIME-Version: 1.0
Date: Sun, 6 Feb 2011 17:49:23 +0100
Message-ID: <AANLkTi=vBv_a+X3MrgyDevss9H92vBJ51eON_qyMJW4=@mail.gmail.com>
Subject: [PATCH] uinput strnlen bugfix
From: David Herrmann <dh.herrmann@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: aris@cathedrallabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The uinput device driver (drivers/input/misc/uinput.c) incorrectly
computes the size of new device names. This patch fixes this. The diff
is against 2.6.37 but the bug also exists in the most recent git
sources.

strnlen() never returns negative numbers so the result should be
incremented after checking for zero. Otherwise the test will always be
false. This bug allows empty input device names.

Please CC me, I'm not subscribed to the mailing list.

David
