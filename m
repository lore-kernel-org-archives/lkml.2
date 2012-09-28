Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab2I1C2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 22:28:41 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47418 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab2I1C2k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 22:28:40 -0400
MIME-Version: 1.0
In-Reply-To: <506474D0.9020406@cs.tu-berlin.de>
References: <1348682325-8402-1-git-send-email-schnhrr@cs.tu-berlin.de>
 <20120926211526.GA30261@kroah.com> <506382B0.8040908@cs.tu-berlin.de>
 <CAPXgP11xwBDSZ9q9thzbXd5xZW_jeq-OW96hSoXFbXQBjQWbqw@mail.gmail.com> <506474D0.9020406@cs.tu-berlin.de>
From: Kay Sievers <kay@vrfy.org>
Date: Fri, 28 Sep 2012 04:28:18 +0200
Message-ID: <CAPXgP1255L5ok7Fw-sBwdxkEQ1sixLp403BGq-tPwCw+oVCiDQ@mail.gmail.com>
Subject: Re: [PATCH] printk: drop ambiguous LOG_CONT flag
To: =?UTF-8?Q?Jan_H=2E_Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 5:46 PM, "Jan H. Schönherr"
<schnhrr@cs.tu-berlin.de> wrote:
> Am 27.09.2012 15:39, schrieb Kay Sievers:

>> It is a flag that we have not been able to merge a continuation line
>> in the buffer, because we had a race with another thread, or the
>> console lock was taken for a long time and we couldn't use the merge
>> buffer.
>
> But it is also set, if we don't know yet, whether there is going to
> be a continuation (printk.c, line 1583):
>
>         log_store(facility, level, lflags | LOG_CONT, 0,
>                   dict, dictlen, text, text_len);
>
> This confuses devkmsg_read() and msg_print_text() later on.

Yeah, I can see that here too. Tested your patch and seems to behave
well with a bunch of other tests I still have available. Looks good
and worth to try:
  Tested-By: Kay Sievers <kay@vrfy.org>

Thanks,
Kay
