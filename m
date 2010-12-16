Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab0LPDMu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 22:12:50 -0500
Received: from smtp-out.google.com ([74.125.121.35]:34021 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755923Ab0LPDMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 22:12:47 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:x-system-of-record;
	b=A3SS5nuTL/HcboT5IsmnzXcDYCKCCujyyz5oYitgH61R0Ig+jbx1GJXfLw3dfBVMF
	EOyCXUXj4JgrXxBhlgeGw==
Message-Id: <20101216031016.186364650@google.com>
User-Agent: quilt/0.48-1
Date: Wed, 15 Dec 2010 19:10:16 -0800
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [patch 0/2] Fix interactivity buglet with autogroup and shares distribution re-write
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should address the interactivity issues reported by Mike Galbraith:
https://lkml.org/lkml/2010/11/28/47

The root cause turns out to be a mis-ordering of weight updates and accounting
outstanding execution time.

This is fixed by making update_curr() 'atomic' once more with respect to
accounting, this allows us to then make sure any outstanding time is charged in
the re-weight path (prior to the actual update).

Thank-you to everyone for their patience while we tracked this down,

- Paul


