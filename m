Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114Ab0HDQsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 12:48:38 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38600 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263Ab0HDQsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 12:48:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=VkF4VzbDg/U4kVKlWCUU1nDz2yxqmK6Slny7e1n0gc3+TjvMwMQcczjzrt4L0WF7BH
         ApiAjuU0Fph7TKcC5Gcw+tWCNmosT21hpGQRmOn5TJMhp9V08QyGnumHOnYZbj02Nhjq
         Hw4sQounqThkLLV2VXNuDJoNLv1MaWs8NDZXk=
Subject: Re: [PATCH 2/2] MEMSTICK: Add driver for Ricoh R5C592 Card reader.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <441366.48179.qm@web37605.mail.mud.yahoo.com>
References: <441366.48179.qm@web37605.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Aug 2010 19:48:32 +0300
Message-ID: <1280940512.16380.4.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-04 at 00:57 -0700, Alex Dubov wrote: 
> I see two immediate problems with this patch:
> 
> 1. On cosmetic level, custom debug macros should not be employed. Device
> core already have this functionality (dynamic debug levels and such). Please,
> use dev_dbg and friends for print-outs.
This allows much easier control for debug.
Single module parameter is enough to adjust it.
This helps me help users.
(Eg, kernel compilation is out of question)


> 
> 2. On a structural level, I'd rather prefer host drivers to not start their
> own threads. If you look at both current host implementations, they operate
> in callback fashion. Apart from saving some resources, this reduces the
> amount of problems encountered during suspend/resume and shutdown.
This isn't possible.
Hardware doesn't support interrupts on memstick bus changes, it only
supports DMA done from/to internal FIFO, and DMA it only possible for
512 byte TPCs.


Best regards,
Maxim Levitsky

