Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309Ab2FEQoV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 12:44:21 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40324 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836Ab2FEQoT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 12:44:19 -0400
MIME-Version: 1.0
In-Reply-To: <4FCCD58B.30000@kernel.org>
References: <4FCCD58B.30000@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 5 Jun 2012 09:43:57 -0700
X-Google-Sender-Auth: pQpUcxc6a5vrZRozcvbdNnsOCnQ
Message-ID: <CA+55aFzvj_0+kunG0fy1xDsTxrO-qBU7rg-6mpnFKoLq7XyROw@mail.gmail.com>
Subject: Re: [GIT PULL] ACPI & Power Management Patches for Linux-3.5-rc1
To: Len Brown <lenb@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-acpi <linux-acpi@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 4, 2012 at 8:34 AM, Len Brown <lenb@kernel.org> wrote:
>      Merge branch 'upstream' into bugfix-video

So I *think* this merge is a mismerge, but I want to verify with Alan.

I think the drivers/gpu/drm/gma500/psb_drv.c should be taken from
current mainline: you commented out the call to
"acpi_video_register()", and while it is true that both branches did
comment that line out, mainline actually has further changes
*afterwards* that put it back in again. Notably commit d839ede47a56
("gma500: opregion and ACPI").

So I *think* that the resolution to that merge should have been to
just take everything from mainline.

Alan? Can you check out the tree at

    git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux.git release

or are you still busy with the queen?

               Linus
