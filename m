Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab2DPUkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:40:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41286 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928Ab2DPUkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:40:01 -0400
Date: Mon, 16 Apr 2012 15:39:57 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: James Le Cuirot <chewi@aura-online.co.uk>
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: Re: toshiba-acpi: =?utf-8?Q?Port=C3=A9g?= =?utf-8?B?w6k=?= 3500
 function keys broken since 2.6.33
Message-ID: <20120416203957.GC3959@thinkpad-t410>
Mail-Followup-To: James Le Cuirot <chewi@aura-online.co.uk>,
	linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
References: <20120414224512.5f943f31@symphony.aura-online.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120414224512.5f943f31@symphony.aura-online.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2012 at 10:45:12PM +0100, James Le Cuirot wrote:
> Following a kernel git bisect, I have found that commit
> 6335e4d56681f6f08f24f4b812a72d402793d393 broke the function keys on the
> Toshiba Portégé 3500. Details of that commit can be seen at
> https://lkml.org/lkml/2009/3/31/440.
> 
> Apart from fnfxd not responding to key presses, the hotkey_ready and
> hotkey values found in /proc/acpi/toshiba/keys remain stuck on 0
> whereas before they used to change after a single function key press.
> 
> Some months after the commit, a patch was proposed in response to fix
> the multimedia keys on the Toshiba Satellite A40. Unfortunately this
> patch didn't fix the problem in my case. Regardless, the patch can be
> found at https://lkml.org/lkml/2010/2/27/138.
> 
> Matthew Garrett initially requested an acpidump in order to diagnose
> the above problem so I have attached mine here. I also attempted to get
> the ACPI debug output but it more than filled my entire dmesg buffer
> and I wasn't even sure it was relevant. Let me know if you wish to see
> that anyway.
> 
> Please CC me in your replies.

Toshibas are extremely inconsistent in how they report hotkeys. Some
models report them on the legacy keyboard port, but a subset of these
will stop reporting them on this port when certain actions are taken on
the ACPI interface. Yours appears to be one of these. Unfortunately the
action that breaks hotkeys on your machine is required to make hotkeys
work on other machines.

I did some work on toshiba_acpi to support additional interfaces for
supporting hotkeys that went into 3.4. Based on your ACPI tables this
might help you, but I can't be certain, so you should give the latest
3.4-rc a try to see if it helps.

Seth
