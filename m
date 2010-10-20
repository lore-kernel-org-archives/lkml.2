Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab0JTOhQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 10:37:16 -0400
Received: from flmx07.ccur.com ([173.221.59.12]:11836 "EHLO flmx07.ccur.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134Ab0JTOhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 10:37:14 -0400
X-Greylist: delayed 324 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Oct 2010 10:37:14 EDT
Date: Wed, 20 Oct 2010 10:31:44 -0400
From: Tom Horsley <tom.horsley@ccur.com>
To: <linux-kernel@vger.kernel.org>
CC: "Horsley, Tom" <Tom.Horsley@ccur.com>
Subject: Re: [PATCH -mm 42/43] x86 core dump TLS
Message-ID: <20101020103144.673c6bdc@tomh>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Way back in 2007 this patch started wending its way into the
kernel:

http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg242889.html

That adds the NT_386_TLS NOTE segment entries to core files, which
are quite handy for recovering the pthread_self() values for
multiple threads in a core file from a 32 bit x86 threaded program.

Does anyone know why there doesn't appear to be any similar info
dumped for the thread info in 64 bit x86_64 threaded programs?
The pthread library uses the arch_prctl() service to setup the
segment registers there, and it would be handy for debuggers
to be able to recover the thread info in 64 bit core files as well.
