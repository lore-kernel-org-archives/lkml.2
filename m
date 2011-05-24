Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab1EXRMy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 13:12:54 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42301 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab1EXRMw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 13:12:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=bHUTir9M7X53gD56byscI1AJzeT7EuDHUT6TCp8hKzz2Fv5f91DeoXjYpT5xYMjUIw
         YnfAnOKJ0WRO9Uh3iL942GzfdvHnPY9dQMVCPylF7e26oDhramIUR4QNocxJl1hm+mHt
         DSC44xN9qTGhflAZyM4r9oEkinv4nJZdWnLuo=
MIME-Version: 1.0
In-Reply-To: <00ec01cc19d4$b6c75660$24560320$@org>
References: <1306132882-9668-1-git-send-email-tlinder@codeaurora.org>
 <1306132882-9668-5-git-send-email-tlinder@codeaurora.org> <20110523123135.GA10785@linutronix.de>
 <00eb01cc19d0$e526a9b0$af73fd10$@org> <BANLkTikB+9koYz6Gv4sZEhfn9kts66Rs_g@mail.gmail.com>
 <00ec01cc19d4$b6c75660$24560320$@org>
From: Mike Frysinger <vapier@gentoo.org>
Date: Tue, 24 May 2011 13:12:31 -0400
X-Google-Sender-Auth: 2RBTSV0O2Gp-i59RIMPpf2R6uj0
Message-ID: <BANLkTikWXUf8vHZM4G4D83ismBVpRr8rOg@mail.gmail.com>
Subject: Re: [PATCH v12 4/8] usb:gadget: Add SuperSpeed support to the Gadget Framework
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, greg@kroah.com,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org, balbi@ti.com,
        ablay@codeaurora.org, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 01:37, Tanya Brokhman wrote:
>> > Mike answered that you're right in your observation. I'm not familiar
>> > with blackfin. Could you please elaborate on this? I understand that
>> > I need to use put_unaligned_le16(), will do, but I would like to better
>> > understand why and if there is a way to test this so that blackfin
>> > won't be broken.
>>
>> not all arches support unaligned accesses.  or they do, but it's done
>> via (non-trivial) exception processing in software.  req->buf is of
>> type void* and so presumably is not guaranteed to be aligned on a 2
>> byte boundary.
>
> Thanks for the explanation, Mike! I'll update the patch.

also, for arches where unaligned accesses work (like x86), the
unaligned macros will simply expand to direct accesses like the code
you had originally.
-mike
