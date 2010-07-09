Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab0GIH5b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 03:57:31 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49068 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab0GIH53 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 03:57:29 -0400
MIME-Version: 1.0
In-Reply-To: <82tyo9i0n2.fsf@mid.bfk.de>
References: <AANLkTimvsaoOm_QEUnvlZf2EKuiMpOr9PdQt_Ga0Z97D@mail.gmail.com> 
	<20100708012120.GB11419@auslistsprd01.us.dell.com> <D3F292ADF945FB49B35E96C94C2061B90C317EA2@nsmail.netscout.com> 
	<82tyo9i0n2.fsf@mid.bfk.de>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 9 Jul 2010 09:57:14 +0200
Message-ID: <AANLkTilRdnjShlB2JA1TjxMklTjw4ASl3BhwUWtKRdMW@mail.gmail.com>
Subject: Re: nic enumeration
To: Florian Weimer <fweimer@bfk.de>
Cc: "Loke, Chetan" <Chetan.Loke@netscout.com>,
       Matt Domsch <Matt_Domsch@dell.com>,
       Michael Di Domenico <mdidomenico4@gmail.com>, linux-net@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 9, 2010 at 09:18, Florian Weimer <fweimer@bfk.de> wrote:
>> Ok, but can we achieve the renaming w/o a reboot?
>
> "udev-trigger" or "udevadm trigger" works for renaming network
> interfaces.  The kernel has some restrictions on renaming interfaces
> which are in use, so this might not work in your case.

On older systems it would be:
  udevtrigger
on newer systems it would be:
  udevadm trigger

On recent systems you need to add:
  udevadm trigger --action=add
otherwise 'change' events will be triggered, which don't rename any
netif. The default 'add' events caused too many problems with tools
with not well integrated tools.

And you should always limit the trigger to the subsystem you want to work with:
  udevadm trigger --action=add --subsystem-match=net
otherwise you run events for all devices on the system, which may
cause completely unrelated trouble.

Anyway, it's not recommended to do anything like this. On many distros
it will cause trouble with the network scripts/services, which are run
again for already active interfaces. Using the udevadm trigger
'hammer' on the running system may lead to all sorts of problems. This
tool is usually only used at coldplug time during bootup.

Also, busy interfaces which might be included in the rename attempt
will cause ethX_rename failures if names need to be swapped.

In general, there is no safe way, or a tool to do this. You have to
know very well what you are doing. It's pretty common, that you
disconnect yourself from a remote box if you try anything like this.

Kay
