Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759723Ab0HEGVQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 02:21:16 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46164 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757668Ab0HEGVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 02:21:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=HSgNceTCto4V16yNfdCv0PUQN0y4dnrqqtM+lhb//+uXWStwlIKXI8ob1Li33MX/KW
         e9qye+9cLRumWEBE4xrTfqGEhbMAZQefcAXXCjEmk56yuQQjzLUU1jSrAWk2jDV5/cOT
         WfgnETLzNwVfytnEe5WS8CRafr3GnWXSURTOo=
MIME-Version: 1.0
Date: Thu, 5 Aug 2010 16:21:12 +1000
Message-ID: <AANLkTi=gnsPUPomCUXRLgV0PhNxtBaXiCheDU=yRV0Kx@mail.gmail.com>
Subject: lockdep and oops_in_progress
From: Dave Airlie <airlied@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

I was debugging a wierd issue with suspend/resume and fbcon/X with
some recent work Jesse and myself did to try and make sure a pinned
fbcon always gets the text on it with a panic or oops occurs.

It does this by testing the oops_in_progress flag, however once any
lockdep issue occurs it looks to me that we leave this flag set
forever, in most places I can see in oops code etc they call
bust_spinlocks(1) then bust_spinlocks(0) to balance the
oops_in_progress value, but lockdep never seems to reset it.

I'm wondering if there is an inherent reason for this or if I whip up
a patch to reset once the lockdep is printed if this would cause any
issues?

Dave.
