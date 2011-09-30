Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757714Ab1I3SES (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 14:04:18 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:59229 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464Ab1I3SEQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 14:04:16 -0400
Date: Fri, 30 Sep 2011 14:04:09 -0400
From: Jeff Layton <jlayton@samba.org>
To: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, LKML <linux-kernel@vger.kernel.org>,
        PWF Linux <pwf-linux@ucs.cam.ac.uk>
Subject: Re: CIFS  kernel module bug
Message-ID: <20110930140409.51c1a94c@tlielax.poochiereds.net>
In-Reply-To: <A904EFBF-CBC1-4842-9E50-2A556103B8AA@cam.ac.uk>
References: <A904EFBF-CBC1-4842-9E50-2A556103B8AA@cam.ac.uk>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Sep 2011 14:58:58 +0100
Anton Altaparmakov <aia21@cam.ac.uk> wrote:

> Hi,
> 
> Looking at the current kernel (in Linus' repository on github) there is a silly logic bug in the cifs module in fs/cifs/cifsfs.c::cifs_llseek() there is this bit of code:
> 
> 	/*
> 	 * origin == SEEK_END || SEEK_DATA || SEEK_HOLE => we must revalidate
> 	 * the cached file length
> 	 */
> 	if (origin != SEEK_SET || origin != SEEK_CUR) {
> 
> The logical or should be a logical and, i.e. this should be:
> 
> 	if (origin != SEEK_SET && origin != SEEK_CUR) {
> 
> As the code is at present that line is ALWAYS true because origin is ALWAYS either != SEEK_SET or != SEEK_CUR as if it equals one it cannot equal the other and vice versa…
> 
> So at the moment it always does the revalidation instead of only for SEEK_END, SEEK_DATA, and SEEK_HOLE.
> 
> Best regards,
> 
> 	Anton


Haha, good catch. Care to roll up a patch to fix that?

-- 
Jeff Layton <jlayton@samba.org>
