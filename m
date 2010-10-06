Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759683Ab0JFUxX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 16:53:23 -0400
Received: from xenotime.net ([72.52.115.56]:46388 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755263Ab0JFUxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 16:53:21 -0400
Message-ID: <55150.64.39.142.105.1286398399.squirrel@xenotime.net>
In-Reply-To: <B2C884FB-3933-4363-85C6-4F1206275B4C@mac.com>
References: <B2C884FB-3933-4363-85C6-4F1206275B4C@mac.com>
Date: Wed, 6 Oct 2010 13:53:19 -0700 (PDT)
Subject: Re: Kernel config option missing: 'Compile the kernel with frame 
     pointers'
From: "Randy Dunlap" <rdunlap@xenotime.net>
To: "Elvis Dowson" <elvis.dowson@mac.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, October 6, 2010 12:16 pm, Elvis Dowson wrote:
> Hi,
> When I run menuconfig on the linux-2.6.32 kernel, I can't seem to find the
> "Compile the kernel with frame pointers" option. The generated .config
> file also doesn't have a CONFIG_FRAME_POINTER variable.

Hi,

It sounds like you don't have DEBUG_KERNEL symbol set.
You can't see the FRAME_POINTER kconfig symbol unless
DEBUG_KERNEL is set/enabled and you are on a qualifying
architecture:

config FRAME_POINTER
        bool "Compile the kernel with frame pointers"
        depends on DEBUG_KERNEL && \
                (CRIS || M68K || M68KNOMMU || FRV || UML || \
                 AVR32 || SUPERH || BLACKFIN || MN10300) || \
                ARCH_WANT_FRAME_POINTERS
        default y if (DEBUG_INFO && UML) || ARCH_WANT_FRAME_POINTERS


The prompt for DEBUG_KERNEL is "Kernel debugging".
It is in the "Kernel hacking" menu.

-- 
~Randy

