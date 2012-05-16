Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965336Ab2EPTrw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 15:47:52 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:32995 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965259Ab2EPTrt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 15:47:49 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1205162133180.8796@pobox.suse.cz>
References: <alpine.LNX.2.00.1205160932280.8796@pobox.suse.cz>
 <20120516170124.GA21275@google.com> <alpine.LNX.2.00.1205162133180.8796@pobox.suse.cz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 16 May 2012 12:47:27 -0700
X-Google-Sender-Auth: 8vtPVFeT6lDAM60ILDHYIi844Q8
Message-ID: <CA+55aFw-us7LnG-iq5EQmSDJ7xH9hiOMmCryAGobReko4LkVWg@mail.gmail.com>
Subject: Re: [PATCH] floppy: convert to delayed work and single-thread wq
To: Jiri Kosina <jkosina@suse.cz>
Cc: Stephen Hemminger <shemminger@vyatta.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 12:37 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> +       cancel_delayed_work_sync(&fd_timeout);
> +       cancel_delayed_work_sync(&fd_timer);
> +       destroy_workqueue(system_nrt_wq);

Well, *that* doesn't look right.

I think just a "flush_workqueue()" is in order.

                    Linus
