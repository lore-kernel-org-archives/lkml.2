Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734Ab0DRCFK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 22:05:10 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56614 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756508Ab0DRCFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 22:05:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=h27xp7haU5KGzwSTTPsXFkpodev9iEdm35lyqPItu+PIGKGHYWm/O13h35khuWi5Mf
         JSgEzlqs7LURqsm3CYfyfHj9MlpN4bqobZHESsqoJzINa7t4+/+9ncV7NEuX+2M6HmRC
         s7KNZ7CPgkN4jQUX4kjQBkcYDELY28l7RtpM8=
Date: Sat, 17 Apr 2010 22:04:56 -0400 (EDT)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: paragw@parag-laptop
To: jglisse@redhat.com
cc: linux-kernel@vger.kernel.org, airlied@redhat.com
Subject: Atombios Execution timeout
Message-ID: <alpine.DEB.2.00.1004172146310.2797@parag-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jerome,

On my laptop with a HD3650 GPU, during resume from RAM I get the 
below errors -

[   80.484213] [drm:atom_op_jump] *ERROR* atombios stuck in loop for more 
than 1sec aborting
[   80.484218] [drm:atom_execute_table_locked] *ERROR* atombios stuck 
executing FA30 (len 493, WS 0, PS 4) @ 0xFA71
[   81.497547] [drm:atom_op_jump] *ERROR* atombios stuck in loop for more 
than 1sec aborting
[   81.497552] [drm:atom_execute_table_locked] *ERROR* atombios stuck 
executing FA30 (len 493, WS 0, PS 4) @ 0xFA71
[   81.548053] PM: resume of devices complete after 2129.312 msecs
[   81.746649] PM: Finishing wakeup.
[   81.746651] Restarting tasks ... done.

Since this happens only during resume may be the current 1 second time is 
not sufficient for the resume case? I bumped it to 2 sec and it stopped 
complaining. 

May be we should increase the timeout for only the resume case?

Thanks,

Parag
