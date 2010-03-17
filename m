Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab0CQOII (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 10:08:08 -0400
Received: from mail-fx0-f219.google.com ([209.85.220.219]:63089 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667Ab0CQOIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 10:08:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type;
        b=r/md28hyVll9rSbDltWtVKEx2nE8fyTLrDIOrhup/IzosA9uqGgy8U6snMmls38HiJ
         BXXIeaLzvYvILTkfRhJcCBItpjQwnnzka9NBpXCjKJSWYu3qIIfhkNaTRLdB9a1mP3Q7
         nve9G4F68HyUPd68oFJYCBdLrAFK2aVzJSTss=
MIME-Version: 1.0
Date: Wed, 17 Mar 2010 15:08:02 +0100
X-Google-Sender-Auth: caadf7b58b0e39e1
Message-ID: <520f0cf11003170708w758d3008n515a2f8d7d8751d6@mail.gmail.com>
Subject: [BUG-REPORT] [PREEMPT_RT] Build break with DRM_I915 and 
	HAVE_ATOMIC_IOMAP
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, RT <linux-rt-users@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, tremyfr@yahoo.fr
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a compile failure on 2.6.33.1-rt9 on x86

ERROR: "iounmap_atomic" [drivers/gpu/drm/i915/i915.ko] undefined!
ERROR: "iomap_atomic_prot_pfn" [drivers/gpu/drm/i915/i915.ko] undefined!

Analysis:

i915_drv.c and i915_gem.c include i915_drv.h which includes io_mapping.h
file: io_mapping.h
     has function io_mapping_map_atomic_wc which calls iomap_atomic_prot_pfn
     has function io_mapping_unmap_atomic which calls iounmap_atomic

These functions are defined in iomap_32.c but not ifdef PREEMPT_RT
