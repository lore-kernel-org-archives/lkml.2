Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758348Ab2DJBiA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 21:38:00 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54315 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab2DJBh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 21:37:58 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1204091831040.15391@chino.kir.corp.google.com>
References: <CA+55aFwTFXtMLhXo7g9F7uyHc3W8SCw7z1gTm9jbWXM3Nqc_ZA@mail.gmail.com>
	<20120408195044.13ea6c8e.akpm@linux-foundation.org>
	<CA+55aFw7GsiZbNW84WVMUMT6C0Sw82jxaYxeaaB8qq=41Ep5Wg@mail.gmail.com>
	<alpine.DEB.2.00.1204090235350.14879@chino.kir.corp.google.com>
	<CA+55aFxUQJC+_aA0qnj0b-LoGfCjfFoG3HXgQ+7LND7y8dFDhw@mail.gmail.com>
	<alpine.DEB.2.00.1204091355280.10873@chino.kir.corp.google.com>
	<CAMbhsRRUNVn9_eL_obZxcZv7LqDW_8SeRApdKzDePbaW_Y4uvg@mail.gmail.com>
	<alpine.DEB.2.00.1204091636160.21813@chino.kir.corp.google.com>
	<CAMbhsRSV9Oy5n-GBjyhCtfCd=3_S9iif+qzEk0Oyy0EBC9AF6w@mail.gmail.com>
	<alpine.DEB.2.00.1204091724590.21813@chino.kir.corp.google.com>
	<CAMbhsRSch1gJLRzPo1p8pCySsB9AJ01wUeVYKXf+zw31pnxumw@mail.gmail.com>
	<alpine.DEB.2.00.1204091831040.15391@chino.kir.corp.google.com>
Date: Mon, 9 Apr 2012 18:37:58 -0700
Message-ID: <CAMbhsRQmkW=Bz-rxy_8gs1qUsgjdsMJ+YLaNHetPoFQq1AgKMQ@mail.gmail.com>
Subject: Re: v3.4-rc2 out-of-memory problems (was Re: 3.4-rc1 sticks-and-crashs)
From: Colin Cross <ccross@google.com>
To: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Christian Bejram <christian.bejram@stericsson.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 9, 2012 at 6:33 PM, David Rientjes <rientjes@google.com> wrote:
> On Mon, 9 Apr 2012, Colin Cross wrote:
>
>> Before Anton's fix, iterating the tasklist involved taking every task
>> lock, which probably made it very expensive.
>
> I'm not sure of the fix you're referring to, but it's not in 3.4-rc2
> because lowmem_shrink() still does find_lock_task_mm() for every user
> process on the system, which is necessary to safely do get_mm_rss().

I confused "staging: android/lowmemorykiller: Don't grab
tasklist_lock" and "staging: android/lowmemorykiller: Better mm
handling".  You're right, it still grabs the task lock.
