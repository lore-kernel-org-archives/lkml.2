Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295Ab0FVWBY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 18:01:24 -0400
Received: from kroah.org ([198.145.64.141]:53300 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198Ab0FVWBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 18:01:21 -0400
Date: Tue, 22 Jun 2010 15:00:03 -0700
From: Greg KH <greg@kroah.com>
To: Henri =?iso-8859-1?Q?H=E4kkinen?= <henuxd@gmail.com>
Cc: gregkh@suse.de, ossama.othman@intel.com, devel@driversdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: memrar: Moved memrar_allocator struct into
 memrar_allocator.c
Message-ID: <20100622220003.GA5121@kroah.com>
References: <1276516473-13685-1-git-send-email-henuxd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1276516473-13685-1-git-send-email-henuxd@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 02:54:33PM +0300, Henri Häkkinen wrote:
> Forward declared memrar_allocator in memrar_allocator.h and moved it
> to memrar_allocator.c file.  Implemented memrar_allocator_capacity() and
> memrar_allocator_largest_free_area().

Um, did you try building the code after this patch?  It fails in bad
ways:

  CC [M]  drivers/staging/memrar/memrar_handler.o
drivers/staging/memrar/memrar_handler.c: In function ‘memrar_init_rar_resources’:
drivers/staging/memrar/memrar_handler.c:352:2: error: dereferencing pointer to incomplete type
drivers/staging/memrar/memrar_handler.c: In function ‘memrar_get_stat’:
drivers/staging/memrar/memrar_handler.c:548:25: error: dereferencing pointer to incomplete type
drivers/staging/memrar/memrar_handler.c:550:23: error: dereferencing pointer to incomplete type
drivers/staging/memrar/memrar_handler.c:551:35: error: dereferencing pointer to incomplete type
drivers/staging/memrar/memrar_handler.c:552:25: error: dereferencing pointer to incomplete type

Please always build the patches you send out.  I can't take
this one obviously :(

Care to fix it up?

thanks,

greg k-h
