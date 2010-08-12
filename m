Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934060Ab0HLSnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 14:43:18 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:59637 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934044Ab0HLSnR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 14:43:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=L4qY/ZuH5FvVjD23KiRGn9t4O0wvXwukadRnHzhpzDZfAeQDaG+82I2X8E+3OiGcXW
         9jTV1Jtj64ETtV3KvvJ97wr/PBLisq9mWp3mLrJQYu/rSzK4z9Z/Do6tFeqzm49ps8fu
         LVy4rIb8tUIe2uYk21TI3YWQ5UmaclFxc9lfU=
MIME-Version: 1.0
In-Reply-To: <1281477570-18944-56-git-send-email-gregkh@suse.de>
References: <20100810214425.GB17385@kroah.com>
	<1281477570-18944-56-git-send-email-gregkh@suse.de>
Date: Thu, 12 Aug 2010 11:43:15 -0700
X-Google-Sender-Auth: SYSetEZeyKdYgHcRO7Au9KhTMkQ
Message-ID: <AANLkTinc6px4BD7CnuvaBE5kWgZGc9cN45QebjfcbgVb@mail.gmail.com>
Subject: Re: [PATCH 56/68] serial: MMIO32 support for 8250_early.c
From: Tony Luck <tony.luck@intel.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Samium Gromoff <_deepfire@feelingofgreen.ru>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 10, 2010 at 2:59 PM, Greg Kroah-Hartman <gregkh@suse.de> wrote:
> +       if (mmio || mmio32)
> +               printk(KERN_INFO
> +                      "Early serial console at MMIO%s 0x%llu (options '%s')\n",
> +                       mmio32 ? "32" : "",
> +                       (unsigned long long)port->mapbase,
> +                       device->options);
> +       else
> +               printk(KERN_INFO
> +                     "Early serial console at I/O port 0x%lu (options '%s')\n",
> +                       port->iobase,
> +                       device->options);
> +

This change looks to be responsible for some confusing dmesg output. Here's some
diff between v2.6.35 and current Linus tree:


< Early serial console at I/O port 0x3f8 (options '115200')
---
> Early serial console at I/O port 0x1016 (options '115200')

Note that my serial port didn't move to a different address. Hex(3f8)
== Decimal(1016)

I think those two printk formats should be using 'x' format rather than 'u' :-)

-Tony
