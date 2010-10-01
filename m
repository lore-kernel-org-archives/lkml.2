Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab0JAUrz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 16:47:55 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38961 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756052Ab0JAUry convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 16:47:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=YuxVAJbrv89GG8ZhoZM0sH+7PuRAl/HpL3WcSoLjfsNZh08DISJ/LRzKhf0bTS0cYm
         +gto4XAJS7gcOzzPwNY5VKCTWV30CzObXd8Xz9SIU0WJZ9Ep6ze2SO/ZLyNYnAuTt9n7
         7GaZt4YEUmVbG5P9VEfH0Ki2WsAsG6hHYLuag=
MIME-Version: 1.0
In-Reply-To: <1285735279-2952-1-git-send-email-rahul.ruikar@gmail.com>
References: <1285735279-2952-1-git-send-email-rahul.ruikar@gmail.com>
Date: Fri, 1 Oct 2010 13:47:52 -0700
X-Google-Sender-Auth: RiKx6kC_x2cahDxktO7LdJZef8Y
Message-ID: <AANLkTinGZEc7V1MH=xyhdKy5=Pg1NRC9xjVEuqBSWNFL@mail.gmail.com>
Subject: Re: [PATCH] serial: ioc3_serial: release resources in error return path
From: Tony Luck <tony.luck@intel.com>
To: Rahul Ruikar <rahul.ruikar@gmail.com>
Cc: Pat Gefre <pfg@sgi.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        linux-mips@linux-mips.org, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 9:41 PM, Rahul Ruikar <rahul.ruikar@gmail.com> wrote:
> -                       goto out4;
> +                       goto out3;

> -               goto out4;
> +               goto out3;

you changed *all* uses of out4 to out3, so with this patch I see:

drivers/serial/ioc3_serial.c:2152: warning: label ‘out4’ defined but not used

So I dropped the first hunks, and changed the last one to this:

>   out4:
> +       for (cnt = 0; cnt < phys_port; cnt++)
> +               kfree(ports[cnt]);
> +
>        kfree(card_ptr);
>        return ret;

Applied with this change.

Thanks

-Tony
