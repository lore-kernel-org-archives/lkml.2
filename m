Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab0G1Gu7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 02:50:59 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44179 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579Ab0G1Guz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 02:50:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=B/4oAgUl3+7geFmwrxJe/Jm1NHpAFi3qK+y85In2hvN7VLXNgbUUwT/aEhz0jLKzRH
         wuqcpFqek86tC7o/hx8NXhvH5/o/mMexN4yS5L6fgGSYQhSFHrioYEalZLjzKVo9LPfG
         rrWkCdrocxANH1IiBNQ2/ikD+JOO1phL2Fj6k=
MIME-Version: 1.0
Date: Wed, 28 Jul 2010 14:50:54 +0800
Message-ID: <AANLkTiniwW+r1G40QvA+oja=1YDkykNWRahHL4LuiCAU@mail.gmail.com>
Subject: BUG: 'Unknown symbol in module' happens after reloading ehci-hcd 
	module
From: Ming Lei <tom.leiming@gmail.com>
To: linux-kernel@vger.kernel.org, linux-usb <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

'Unknown symbol in module'  happens after the actions below:

         rmmod ehci-hcd
         modprobe ehci-hcd

kernel version: 2.6.35-rc6+gregkh tree+wireless tree

dmsg info:
[  689.025428] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[  689.025431] Warning! ehci_hcd should always be loaded before
uhci_hcd and ohci_hcd, not after
[  689.025434] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96

>From source code of ehci-hcd, seems debugfs_create_dir or usb_debug_root
in ehci_hcd_init is thought as unknown symbol mistakenly by kernel.

-- 
Lei Ming
