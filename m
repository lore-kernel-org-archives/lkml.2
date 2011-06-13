Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab1FMUgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 16:36:45 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:53419 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab1FMUgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 16:36:43 -0400
X-Greylist: delayed 498 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Jun 2011 16:36:43 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:x-duff:mime-version:content-type:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to:x-mailer;
        b=I5fKO0FHGK+kqElrvPTxubFJAfcZfa+pTxdPe8XDkFMUP0aXKe2+0vVcwNaNnhuf5f
         7/wqmOmiSI04NJaUZba41DNvfP3xiBtelKu5KemcUOa2YLOPMJL+TdKiJR9pL/AkyyDH
         gjUAdMvBnOAmDOuBZtCahvVnm9a1q8QZUn5JE=
Subject: Re: [PATCH] sparc, exec: remove redundant addr_limit assignment
X-Duff: Duff Lite, Duff Dry, Duff Dark, Lady Duff, Raspberry Duff, Duff Zero
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Mathias Krause <minipli@googlemail.com>
In-Reply-To: <20110611.160842.2135350880385482648.davem@davemloft.net>
Date: Mon, 13 Jun 2011 22:28:20 +0200
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <09961391-F83F-4499-A0A3-00AA5C2028CE@googlemail.com>
References: <1307642718-22257-1-git-send-email-minipli@googlemail.com> <20110609155630.0f734351.akpm@linux-foundation.org> <1307711453-17412-1-git-send-email-minipli@googlemail.com> <20110611.160842.2135350880385482648.davem@davemloft.net>
To: David Miller <davem@davemloft.net>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.06.2011, at 01:08 David Miller wrote:
> From: Mathias Krause <minipli@googlemail.com>
> Date: Fri, 10 Jun 2011 15:10:53 +0200
> 
>> The address limit is already set in flush_old_exec() so this
>> assignment of USER_DS is redundant.
>> 
>> Signed-off-by: Mathias Krause <minipli@googlemail.com>
> ...
>> @@ -368,9 +368,6 @@ void flush_thread(void)
>> 
>> 	/* Clear FPU register state. */
>> 	t->fpsaved[0] = 0;
>> -	
>> -	if (get_thread_current_ds() != ASI_AIUS)
>> -		set_fs(USER_DS);
>> }
> 
> Yeah but now you're doing it unconditionally, the guard is here
> because the %asi register write which set_fs() does is extremely
> expensive on sparc64 and %99.99999 of the time we can avoid it.

As Linus already pointed out, that set_fs() was never called because
we already had (and still have) an unconditional set_fs() in the arch
independent code. So this patch just removes some dead code.

Mathias
