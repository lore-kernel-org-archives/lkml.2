Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935757Ab1JFJA3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 05:00:29 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37931 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932321Ab1JFJA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 05:00:27 -0400
MIME-Version: 1.0
Date: Thu, 6 Oct 2011 18:00:26 +0900
Message-ID: <CAFPAmTQnKv_kQBHP_97fwkEAF0b-QmcqH-1=v5Ce6kSgFe1TUw@mail.gmail.com>
Subject: Query about coredump image generation for multi-threaded apps.
From: "kautuk.c @samsung.com" <consul.kautuk@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: chungki0201.woo@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All,

We are running a multi-threaded embedded application on a uniprocessor
ARM system.

We encountered a memory corruption due to which the application crashed.
The crashing thread accessed a pointer variable whose value was
corrupted and so the
application crashed.

However, there are multiple threads writing to that corrupted pointer
variable at the same instant
as the crash occurs on the crashing thread.
( As per the application logic, only proper writeable virtual memory
addresses are written to that
  variable, so this is a random corruption from some other module in
the process virtual address
  space. )

The result is that the coredump image generated does not contain the
same corrupted value inside
the pointer variable.

Also, various other variables' values are changed as a result of the
delay between the actual crash
and the actions of other threads on the shared global variables.

Query:
=====
Is there any way we can get the image of the process virtual memory in
the coredump at the exact time
of crash ?
Can someone describe possible solutions or workarounds to this problem
for both uniprocessor and SMP
systems ?

Note:
-------
I understand that this problem probably won't happen if we use a
pthread_mutex to protect those global
variables.
In that event, if there is a crash, the other threads will not be able
to access the shared global variables
as the mutex would not have been released.
However, this is currently not an option for us due to certain official reasons.
We would appreciate it if someone could find a way to solve this
without having to introduce any
pthread_mutexes.

Thanks,
Kautuk.
