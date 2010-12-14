Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758980Ab0LNXPD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 18:15:03 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53122 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab0LNXPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 18:15:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=RIAznlaTkE85qtKbf+AFkE9LdZjXnIoT7UOyADHi+BiXXJjeB117QMqT79HwnkNmZc
         iO1+5OZ/RiQSKjiOhiV51LhO2NhEl3Xm3E5laja3GksQTWyspdGPE6gT7AF4LovnqhCV
         BzoutsEteuigVsLh8gCWtGK69zFyejLg0nMfo=
MIME-Version: 1.0
In-Reply-To: <4D07AE34.9000602@gmail.com>
References: <AANLkTin2Z5XXf-3Gkqj72+FT4rM+hpqehK8Ys=gg++c9@mail.gmail.com>
	<987664A83D2D224EAE907B061CE93D530193BBAA27@orsmsx505.amr.corp.intel.com>
	<AANLkTi=NKa6UCeYsE0Y5iWnq8XYbVtSU7XiKJSNc5tLz@mail.gmail.com>
	<AANLkTin98z8_Maa8iJfbzyjtRDLkTve7PShPAvdukqZd@mail.gmail.com>
	<4D07AE34.9000602@gmail.com>
Date: Tue, 14 Dec 2010 15:15:00 -0800
X-Google-Sender-Auth: uk6zuVEupIHTlBaWThp0niASM8k
Message-ID: <AANLkTini5XkSFjwOt55b8VG7aTWqT2tDU8ckGtE9DkN_@mail.gmail.com>
Subject: Re: [RFC] persistent store (version 3) (part 1 of 2)
From: Tony Luck <tony.luck@intel.com>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 9:49 AM, Marco Stornelli
<marco.stornelli@gmail.com> wrote:
> Yeah, maybe it wasn't really ready for mainline :) However the idea
> behind it, it was the same more or less, to have a piece of memory to
> write some persistent information.

I dug back into old linux-next trees and found the code in the
November editions.

You are right - this does look very similar to what I have done.  I
think my code
may be more adaptable to other platforms as I tried hard to separate out the
generic part that implements the file system view from the platform driver
that peeks and pokes at the hardware to access the persistent memory.
It is also accessible to user space without any custom tools.

The dream/pmem.c code might do a better job at handling larger amounts
of persistent memory than my code, but it looks like it needs some special
user tools that use the ioctl(... PMEM_*, ...) operations to set things up.

-Tony
