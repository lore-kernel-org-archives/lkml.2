Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726Ab2HHPH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 11:07:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:58995 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757485Ab2HHPHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 11:07:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,733,1336374000"; 
   d="scan'208";a="177542448"
Date: Wed, 8 Aug 2012 16:24:50 +0100
From: Alan Cox <alan@linux.intel.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com
Subject: Re: [PATCH 02/41] TTY: 68328serial, fix compilation
Message-ID: <20120808162450.54158ce3@bob.linux.org.uk>
In-Reply-To: <1344368886-24033-3-git-send-email-jslaby@suse.cz>
References: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
	<1344368886-24033-3-git-send-email-jslaby@suse.cz>
Organization: Intel
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  7 Aug 2012 21:47:27 +0200
Jiri Slaby <jslaby@suse.cz> wrote:

> tty_struct->termios is no longer a pointer. This was changed recently
> by "tty: move the termios object into the tty". But 68328serial was
> not changed, so we now have a compilation error:
> 68328serial.c: In function 'change_speed':
> 68328serial.c:518:22: error: invalid type argument of '->' (have
> 'struct ktermios') 68328serial.c: In function 'rs_set_ldisc':
> 68328serial.c:620:31: error: invalid type argument of '->' (have
> 'struct ktermios') 68328serial.c: In function 'rs_set_termios':
> 68328serial.c:988:20: error: invalid type argument of '->' (have
> 'struct ktermios')
> 
> Fix that now.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Alan Cox <alan@linux.intel.com>

Cool - I couldn't even find a compile chain or config to test this. I'd
assumed it was broken and really wanted dumping in staging (it still
looks that way 8))

Acked-by: Alan Cox <alan@linux.intel.com>
