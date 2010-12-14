Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774Ab0LNOeC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 09:34:02 -0500
Received: from hera.kernel.org ([140.211.167.34]:56052 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754034Ab0LNOeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 09:34:00 -0500
Message-ID: <4D078052.3040800@kernel.org>
Date: Tue, 14 Dec 2010 15:33:54 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@suse.de>
CC: Linux SCSI List <linux-scsi@vger.kernel.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] scsi: don't use execute_in_process_context()
References: <4CBD95C0.6060302@kernel.org>  <4CBD95DC.8000001@kernel.org>	 <1292194113.2989.9.camel@mulgrave.site>  <4D073E9A.3000608@kernel.org>	 <1292335754.3058.2.camel@mulgrave.site>  <4D077CD9.6050907@kernel.org> <1292336798.3058.5.camel@mulgrave.site>
In-Reply-To: <1292336798.3058.5.camel@mulgrave.site>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 14 Dec 2010 14:33:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/14/2010 03:26 PM, James Bottomley wrote:
> Depends what you're doing about the flush problem.  The synchronisation
> is inherent in the use (we're holding a reference to the module within
> the executed code).  The flush is to try to speed things up so the user
> doesn't get annoyed during rmmod.  We don't need a sync, just an
> accelerator.

Hmmm, I'm confused.  How does it drop the reference then?  Something
outside of the callback should wait for its completion and drop the
reference as otherwise nothing can guarantee that the modules doesn't
go away between the reference drop and the actual completion of the
callback.

>> Compelling reason for it to exist.  Why not just use work when you
>> need execution context and the caller might or might not have one?
> 
> Because it's completely lame to have user context and not use it.

It may be lame but I think it's better than having an optimization
interface which is incomplete and, more importantly, unnecessary.

>> But, really, let's just remove it.  At this point, we either need to
>> fortify the interface or remove it and given the current usage, I
>> think we're better off with the latter.
> 
> I really don't think the open coding is a good idea.  It's complex and
> error prone; exactly the type of thing that should be in an API.

Yeah, just schedule work like everyone else.

Thanks.

-- 
tejun
