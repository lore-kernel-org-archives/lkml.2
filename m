Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820Ab0F0QKx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 12:10:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39794 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755735Ab0F0QKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 12:10:50 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Sergey Temerkhanov <temerkhanov@cifronik.ru>
Cc: Sergey Temerkhanov <temerkhanov@yandex.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-aio" <linux-aio@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Benjamin LaHaise <bcrl@kvack.org>, Zach Brown <zach.brown@oracle.com>,
       Suparna Bhattacharya <suparna@in.ibm.com>
Subject: Re: [PATCH][RFC] AIO: always reinitialize iocb->ki_run_list at the end of aio_run_iocb()
References: <201004280251.43430.temerkhanov@yandex.ru>
	<201005271406.36489.temerkhanov@yandex.ru>
	<x49iq62lak7.fsf@segfault.boston.devel.redhat.com>
	<201006242131.21463.temerkhanov@cifronik.ru>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Sun, 27 Jun 2010 12:10:32 -0400
In-Reply-To: <201006242131.21463.temerkhanov@cifronik.ru> (Sergey
	Temerkhanov's message of "Thu, 24 Jun 2010 21:31:21 +0400")
Message-ID: <x49sk48318n.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergey Temerkhanov <temerkhanov@cifronik.ru> writes:

> The problem with kick_iocb() is exactly as this: If retry() method 
> returns -EIOCBQUEUED to aio_run_iocb() then any subsequent call to 
> kick_iocb() results in failure. Is it expected behavior?

 * If ki_retry returns -EIOCBQUEUED it has made a promise that aio_complete()
 * will be called on the kiocb pointer in the future.  The AIO core will
 * not ask the method again -- ki_retry must ensure forward progress.

Does that answer your question?

Cheers,
Jeff
