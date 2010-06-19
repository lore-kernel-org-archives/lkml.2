Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644Ab0FSSgz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 14:36:55 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38055 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756605Ab0FSSgx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 14:36:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=ZMnxjUFnaoJbORI3Y8Du6FHS7ULMUQxQaABnaS6EzpU7gjMMZrhGJ/nuUCVw8ZQ6BU
         McE61qCUx64aEDn5ix943Ey8FXbfspCy+LL6MHyw1croUJ/aCftcHRCYE7teEjXUtNNl
         T6pSxfHtS6SIZttnFUkzCNYCKEYP7OUjeaIgM=
MIME-Version: 1.0
Date: Sun, 20 Jun 2010 00:06:52 +0530
Message-ID: <AANLkTil7YgW3eQZ-WQ3R8k2OowZt491boAuxjPe18oFy@mail.gmail.com>
Subject: Help in understanding the tasklets
From: Hari LKML <hari.lkml@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After reading some of the books and the codes here is my understanding
about the tasklet_action function

the function statrs some thing like this

1. If the tasklet is not running in another processor set the Bit
TASKLET_STATE_RUN;     <<if (tasklet_trylock(t))>>
2. clear the TASKLET_STATE_SCHED bit;       <<if (!test_and_clear_bit(TASKLET_
STATE_SCHED, &t->state))>>
3. start the tasklet     <<(    t->func(t->data))>>


Now when the tasklets function is running and the same interrupt is
raised again but now handled by a different processor (in a SMP
system) the tasklet is now scheduled in a different processor (because
the TASKLET_STATE_SCHED is already cleared in step 2)
and there are every chance of the same type of  taklet running
concurently in different processors thus braking the promise that same
types of tasklets do not ever run simultaniously.

I think i have misunderstood one or the other concept so please
correct me and help me in understanding the Linux Kernel code more
clearly.


Please personally CC me all answers/comments posted to the list, to my
mail id hari.lkml@gmail.com.

Hari
