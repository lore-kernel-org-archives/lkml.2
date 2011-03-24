Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934028Ab1CXQCe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 12:02:34 -0400
Received: from smtp-out.google.com ([74.125.121.67]:4825 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933939Ab1CXQCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 12:02:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:organization:message-id:in-reply-to
         :user-agent;
        b=M9mOxFMSmj0jSIhKWl4X2MZ7xo50OJs1/ZiJ2wKqU4Oyw7CIsiTQ794AIXgQUN41r7
         xO5tDkBk2RcEOzXTlCjg==
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Alan Stern" <stern@rowland.harvard.edu>
Cc: "Sergey Senozhatsky" <sergey.senozhatsky@gmail.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        "Chris Wright" <chrisw@sous-sol.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: core: Change usb_create_sysfs_intf_files()' return
 type to void
References: <Pine.LNX.4.44L0.1103241150210.2006-100000@iolanthe.rowland.org>
Date: Thu, 24 Mar 2011 17:02:10 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mnazarewicz@google.com>
Organization: Google
Message-ID: <op.vsuutwfyvgw7ix@mnazarewicz-glaptop>
In-Reply-To: <Pine.LNX.4.44L0.1103241150210.2006-100000@iolanthe.rowland.org>
User-Agent: Opera Mail/11.01 (Linux)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 24 Mar 2011, Michal Nazarewicz wrote:
>> The usb_create_sysfs_intf_files() function always returned zero even
>> if it failed to create sysfs fails.  Since this is a desired behaviour
>> there is no need to return return code at all.  This commit changes
>> function's return type (form int) to void.
[...]
>> The below patch has not been tested (not even compiled), just a quick  
>> scatch.

On Thu, 24 Mar 2011 16:52:36 +0100, Alan Stern wrote:
> If you had compiled it, you would have seen why it's not a good idea to
> remove retval.  :-)

I must be getting blind...  I explicitly checked if device_create_file()
has __must_check attribute but somehow missed it.

> On the other hand, changing the function's return type to void is okay.
> I think the reason it returns int is historical; there used to be a
> failure mode but it got removed.

In that case I can prepare a v2 later today (unless Sergey feels like
doing that).

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
