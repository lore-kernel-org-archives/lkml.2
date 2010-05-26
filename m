Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289Ab0EZO4a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 10:56:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:49528 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290Ab0EZO43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 10:56:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,304,1272870000"; 
   d="scan'208";a="625005351"
Date: Wed, 26 May 2010 15:11:52 +0100
From: Alan Cox <alan@linux.intel.com>
To: Frank Pan <frankpzh@gmail.com>
Cc: Gerardo Exequiel Pozzi <vmlinuz386@yahoo.com.ar>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Daniel Mack <daniel@caiaq.de>, Tejun Heo <tj@kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>, Jochen Hein <jochen@jochen.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Dave Airlie <airlied@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] Enlarge the storage of chars in virtual terminal
Message-ID: <20100526151152.28deaa6c@linux.intel.com>
In-Reply-To: <AANLkTikBrXROMvNKrhgxQ1jVh6aOsx3nIrNXTznXInV1@mail.gmail.com>
References: <AANLkTikBrXROMvNKrhgxQ1jVh6aOsx3nIrNXTznXInV1@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010 14:55:04 +0800
Frank Pan <frankpzh@gmail.com> wrote:

> Greetings
> 
> The motivation is display much more characters on the
> framebuffer console than 512. If this is done, foreign
> languages can be easily rendered with currently supported
> utf-8 encoding.

This has been suggested a couple of times but unfortunately it's not
enough to use bigger fonts. Rendering many non western languages is far
far more complex. In addition the text mode vt driver is limited to 512
symbols by the hardware.

Doing it right means putting the entirity of Pango into the kernel. I'd
rather not do that when the job can be done better via a user space
application and pty/tty pair.

Alan
