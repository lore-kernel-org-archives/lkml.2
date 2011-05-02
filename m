Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab1EBXZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 19:25:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34024 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751851Ab1EBXZ1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 19:25:27 -0400
MIME-Version: 1.0
In-Reply-To: <web-516671337@zbackend1.aha.ru>
References: <web-516671337@zbackend1.aha.ru>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 2 May 2011 16:24:35 -0700
Message-ID: <BANLkTikFqF1vzMq3L9zDB=MDnCOFYp+XEQ@mail.gmail.com>
Subject: Re: 2.6.39-rc5-git2 boot crashs
To: werner <w.landgraf@ru.ru>
Cc: jaxboe@fusionio.com, tj@kernel.org, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 2, 2011 at 3:28 PM, werner <w.landgraf@ru.ru> wrote:
> Also, with this configuration, sync dont work, the terminal waits endless.
> šAnd if I type in 'reboot', then after the message it would go to reboot,
> nothing happens (it's possible that for reboot, sync is called).

Yes, sync is called for reboot.

However, that should be fairly easy to figure out. Well, perhaps not
"figure out", but at least get more details of where it is hanging. A
simple

   echo w > /proc/sysrq-trigger

should give you a nice trace in the dmesg showing where 'sync' is
hanging, and that would hopefully give us a lot more clues.

                                Linus
