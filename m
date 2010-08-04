Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751186Ab0HDVlo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 17:41:44 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42596 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab0HDVli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 17:41:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=PsEG8NHt5huIz+mPBR5H4fbC6LBGaioZF00XhQjpwu/U1R49hAMncYZD7eksNoI6Cj
         5hSuNoZqc16D0kyYM+CR0QhkkipAQgKLhDUcC9w/TJiTxb5PyWhEFwYgUQt9UaAPZXnr
         XE5lpj8z/pJyHvnZNdBtR31RyZxTKI0HbSePs=
Subject: Re: [PATCH 1/2] MEMSTICK: fix hangs on unexpected device removal
 in mspro_blk
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1280940821.16380.10.camel@maxim-laptop>
References: <811063.41186.qm@web37605.mail.mud.yahoo.com>
	 <1280940821.16380.10.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Aug 2010 00:41:32 +0300
Message-ID: <1280958092.5897.2.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-04 at 19:53 +0300, Maxim Levitsky wrote: 
> On Wed, 2010-08-04 at 00:50 -0700, Alex Dubov wrote: 
> > --- On Tue, 3/8/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> > 
> > > Now that del_gendisk syncs, we better
> > > start rejecting requests right away.
> > 
> > 
> > I don't quite see why this change is needed. My understanding is, user
> > accessible interface should be marked as removed as early, as possible.
> 
> The problem here is that del_gendisk, syncs the device.
> This is new change, made after you did your drivers.
> 
> I have this problem on jMicron too (which otherwise works fine).
The problem is that card check thread explicitly calls ->stop before
removing the device.
In case of mspro_blk.c that stops the request queue.
Attempt to call del_gendisk with stopped request queue hangs due to
syncing.


> 
> 
> PS:
> 
> I have a copy of your ms_block.c.
> I would would be very happy if you share with me, what problems does it
> still have (besides need of trivial port for changes in block system,
> because I want to push it upstream too.
> 
> I have MS DUO 64M to test it against.
> 
> 
Best regards,
	Maxim Levitsky



