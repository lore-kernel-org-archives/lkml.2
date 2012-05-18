Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759177Ab2ERAOx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 20:14:53 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45273 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758561Ab2ERAOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 20:14:52 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxB6YSz-KEwVKtOesS7yrdvYw6sP3mfpuWBOheJVL6e+w@mail.gmail.com>
References: <4fb531069693a1b42@agluck-desktop.sc.intel.com>
	<CA+55aFxB6YSz-KEwVKtOesS7yrdvYw6sP3mfpuWBOheJVL6e+w@mail.gmail.com>
Date: Thu, 17 May 2012 17:14:51 -0700
X-Google-Sender-Auth: cFAc-8n7KzjOI7Z_HW9j-KGiqhU
Message-ID: <CA+8MBbK_xeN5HWnSvbDYwzZ+E0pSpbDte30RH2deo0r1OzYBGA@mail.gmail.com>
Subject: Re: [git pull] machine check recovery fix
From: Tony Luck <tony.luck@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 3:45 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Also, the whole "nonrestartable state flag" means - if I understood
> things correctly - that you really cannot do the "iret" even from the
> NMI handler.

Not quite ... we can "iret" ... but not back to the instruction that was
executing when the machine check occurred. We need to go some
place else .... hence we send a signal that will either kill the process,
or take them to their signal handler. [Their signal handler might try
to return, and fall into nowhere ... but that's a user programming error.
If bad things happen to the process and it gets the wrong answer, that
is their own fault].

It's the "PCC" bit (processor context corrupt) that says that we can't
iret at all. We

-Tony
