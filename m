Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584Ab1GVXVR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 19:21:17 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59538 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab1GVXVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 19:21:15 -0400
MIME-Version: 1.0
In-Reply-To: <987664A83D2D224EAE907B061CE93D5301E9FA0EE5@orsmsx505.amr.corp.intel.com>
References: <1311195386-22743-1-git-send-email-dzickus@redhat.com>
	<4E277584.1060200@intel.com>
	<20110721122731.GV3765@redhat.com>
	<987664A83D2D224EAE907B061CE93D5301E9EC9DC6@orsmsx505.amr.corp.intel.com>
	<4E28C552.8060803@intel.com>
	<20110722121302.GB9732@redhat.com>
	<987664A83D2D224EAE907B061CE93D5301E9FA0EE5@orsmsx505.amr.corp.intel.com>
Date: Fri, 22 Jul 2011 16:21:14 -0700
X-Google-Sender-Auth: 6kqpubL0cl4HhMXZ6IvXtfF-ZYU
Message-ID: <CA+8MBb+E462CVOe+5FQb62Tdi5R6cBYgFZUW7sxWDDh2QTaxxA@mail.gmail.com>
Subject: Re: [PATCH] pstore: change mutex locking to spin_locks
From: Tony Luck <tony.luck@intel.com>
To: Don Zickus <dzickus@redhat.com>, "Huang, Ying" <ying.huang@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 22, 2011 at 3:39 PM, Luck, Tony <tony.luck@intel.com> wrote:
> Yup - oops is the only one where the current kernel continues - all the
> others (halt, reboot, kexec, panic) lead to the termination of the
> current kernel - and thus no user processes that would be able to
> see the shiny new entry in the pstore file system.

Doh - I went to look at what it would take to fix this - and found that
I'd already implemented it:


                if (reason == KMSG_DUMP_OOPS && pstore_is_mounted())
                        pstore_mkfile(PSTORE_TYPE_DMESG, psinfo->name, id,
                                      psinfo->buf, hsize + l1_cpy + l2_cpy,
                                      CURRENT_TIME, psinfo);

-Tony
