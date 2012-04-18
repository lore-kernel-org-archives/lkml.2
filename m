Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab2DRXkU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 19:40:20 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38123 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab2DRXkS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 19:40:18 -0400
MIME-Version: 1.0
Date: Wed, 18 Apr 2012 16:40:18 -0700
X-Google-Sender-Auth: 3gXlhC2WscESo76c8rM2IivjcC4
Message-ID: <CA+8MBbKYXV6e0u5bOgr1GUs0ng0F-vGv5rVxnM26B8Dv+2RyLw@mail.gmail.com>
Subject: ia64 build broken by patch to security/commoncap.c
From: Tony Luck <tony.luck@intel.com>
To: Eric Paris <eparis@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        James Morris <james.l.morris@oracle.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit d52fc5dde171f030170a6cb78034d166b13c9445
fcaps: clear the same personality flags as suid when fcaps are used

just appeared in Linus's tree and broke the ia64 build with:

security/commoncap.c: In function ‘cap_bprm_set_creds’:
security/commoncap.c:510: error: ‘PER_CLEAR_ON_SETID’ undeclared
(first use in this function)

Cause seems to be a missing:

#include <linux/personality.h>

-Tony
