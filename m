Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab2LSUjK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 15:39:10 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:58799 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768Ab2LSUjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 15:39:01 -0500
MIME-Version: 1.0
In-Reply-To: <1355849302.26487.15.camel@thor.lan>
References: <1355509370-5883-1-git-send-email-peter@hurleysoftware.com>
 <CA+1xoqeRfg7iY_vS7nVG6W7hqLOmVUmJaz-c4_Sr3h_XMg++sg@mail.gmail.com> <1355849302.26487.15.camel@thor.lan>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Wed, 19 Dec 2012 15:38:39 -0500
Message-ID: <CA+1xoqdtkeuN+nAO5L56r77vrNs40mxwGkkgaCt3aA9=5G_e7g@mail.gmail.com>
Subject: Re: [PATCH v2 00/11] tty: Fix buffer work access-after-free
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Alan Cox <alan@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ilya Zykov <ilya@ilyx.ru>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 11:48 AM, Peter Hurley <peter@hurleysoftware.com> wrote:
> On Tue, 2012-12-18 at 10:44 -0500, Sasha Levin wrote:
>> I'm still seeing that warning with the new patch series:
>>
>> [  549.561769] ------------[ cut here ]------------
>> [  549.598755] WARNING: at drivers/tty/n_tty.c:160 n_tty_set_room+0xff/0x130()
>> [  549.604058] scheduling buffer work for halted ldisc
>> [  549.607741] Pid: 9417, comm: trinity-child28 Tainted: G      D W
>> 3.7.0-next-20121217-sasha-00023-g8689ef9 #219
>> [  549.652580] Call Trace:
>> [  549.662754]  [<ffffffff81c432cf>] ? n_tty_set_room+0xff/0x130
>> [  549.665458]  [<ffffffff8110cae7>] warn_slowpath_common+0x87/0xb0
>> [  549.668257]  [<ffffffff8110cb71>] warn_slowpath_fmt+0x41/0x50
>> [  549.671007]  [<ffffffff81c432cf>] n_tty_set_room+0xff/0x130
>> [  549.673268]  [<ffffffff81c44597>] reset_buffer_flags+0x137/0x150
>> [  549.675607]  [<ffffffff81c45b71>] n_tty_open+0x131/0x1c0
>
> This is a false-positive warning that means I need to refine the warning
> condition to not include this code path.
>
> Thanks again.

I'm really having a hard time doing any fuzzing after applying this
patch. I'm not sure it's related directly, but
the ldisc hangup lockup happens quite quickly and every time, so I
can't really get any good fuzzing done.

I'm not saying that this patch series is causing it, just saying that
I can't really test it at this point due to
that other lockup.


Thanks,
Sasha
