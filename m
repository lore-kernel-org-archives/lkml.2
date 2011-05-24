Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697Ab1EXFPB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 01:15:01 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43387 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab1EXFO7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 01:14:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=RBFlaLhXO+J1/IQFxq0fGP2Jtw9jbbIkKZPGJQ51TXT3QTfNzEV5Jn9nXkY5CPLESM
         E6SALaAFzydYctZFP9kU7ZCQv6oL035+l4olNAFlVQ9qCESRds+APTUCnHQJi2gJkzKA
         4w2PPs99S6NGTGB/aE8+u0wYSnHe559y+OOVw=
MIME-Version: 1.0
In-Reply-To: <00eb01cc19d0$e526a9b0$af73fd10$@org>
References: <1306132882-9668-1-git-send-email-tlinder@codeaurora.org>
 <1306132882-9668-5-git-send-email-tlinder@codeaurora.org> <20110523123135.GA10785@linutronix.de>
 <00eb01cc19d0$e526a9b0$af73fd10$@org>
From: Mike Frysinger <vapier@gentoo.org>
Date: Tue, 24 May 2011 01:14:38 -0400
X-Google-Sender-Auth: 1P2WXahfKS7yxd9kwvK8rOzOs3k
Message-ID: <BANLkTikB+9koYz6Gv4sZEhfn9kts66Rs_g@mail.gmail.com>
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

On Tue, May 24, 2011 at 01:10, Tanya Brokhman wrote:
>> >+    case USB_REQ_GET_STATUS:
>> >+            if (!gadget_is_superspeed(gadget))
>> >+                    goto unknown;
>> >+            if (ctrl->bRequestType != (USB_DIR_IN | USB_RECIP_INTERFACE))
>> >+                    goto unknown;
>> >+            value = 2;      /* This is the length of the get_status
>> >+            *((__le16 *)req->buf) = 0;
>>
>> Mike please correct me if I'm wrong bug this looks like a case for
>> put_unaligned_le16().
>> Is someone actually using gadget support on blackfin? I'm asking
>> because
>> config_buf() (same file, upstream) is using req->buf to build the
>> descriptors in place and one element is le16 which should be affected.
>
> Mike answered that you're right in your observation. I'm not familiar with
> blackfin. Could you please elaborate on this? I understand that I need to
> use put_unaligned_le16(), will do, but I would like to better understand why
> and if there is a way to test this so that blackfin won't be broken.

not all arches support unaligned accesses.  or they do, but it's done
via (non-trivial) exception processing in software.  req->buf is of
type void* and so presumably is not guaranteed to be aligned on a 2
byte boundary.
-mike
