Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758706Ab1IIKU6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 06:20:58 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46437 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758408Ab1IIKU5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 06:20:57 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Klaus Schwarzkopf" <schwarzkopf@sensortherm.de>,
        "Greg KH" <gregkh@suse.de>
Cc: balbi@ti.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: add new usb gadget for ACM and mass storage
References: <1315506287-31368-1-git-send-email-schwarzkopf@sensortherm.de>
 <20110908191146.GA8552@suse.de>
Date: Fri, 09 Sep 2011 12:20:53 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v1jdo3g53l0zgt@mnazarewicz-glaptop>
In-Reply-To: <20110908191146.GA8552@suse.de>
User-Agent: Opera Mail/11.51 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Sep 08, 2011 at 08:24:47PM +0200, Klaus Schwarzkopf wrote:
>> This driver provides two functions in one configuration:
>> a mass storage, and a CDC ACM (serial port) link.
>> Heavily based on multi.c and cdc2.c

On Thu, 08 Sep 2011 21:11:46 +0200, Greg KH <gregkh@suse.de> wrote:
> I thought the "composite" framework make it so that drivers like this
> were no longer needed.  Or am I mistaken somehow?

No.  Composite framework only makes it relatively simple to create such
gadgets, but one still needs some glue that binds all the functions into
a single gadget.

This seems like both a blessing and a curse (which I haven't realise when
I was creating g_multi) since with n functions implemented one can easily
came up with 2^n gadgets.

Android went half-step forward and in it you can create a gadget by
specifying list of named functions it is supposed to have.  I'm saying
“half-step” because they have no support for configurations for instance.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
