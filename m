Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab0IBBEq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 21:04:46 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51957 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851Ab0IBBEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 21:04:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=R3kkXS5FioM3u6hn4gxQPYq96Yih6USULGtB6ZUWJgCkrdX62i44uS3scT5uRxusA4
         dEtJ8IfExohMEfZN4Wxkph0Bww5aeeR6fpu7hMCtSYjD53qS2EgtpSWI1z9DWe+9nXvx
         cxE4WPZyUP0bSZ1aWYtEqvGJ7ojJ5iOETsCqI=
MIME-Version: 1.0
From: David Nicol <davidnicol@gmail.com>
Date: Wed, 1 Sep 2010 20:04:24 -0500
Message-ID: <AANLkTimZnUEM6FFbgw==K3w6hURAgsAO8uRh5W1v6f_j@mail.gmail.com>
Subject: Is there a primitive to atomically release a spinlock and go to sleep?
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to do something involving multiple kthreads in an ioctl
handler, and I want to avoid the
race condition between the third and fourth steps of

    acquire mutex
    add &self to a list of threads which will get awakened by
something else that is also aware of this list
    release mutex
    go to sleep

Is there a standard atomic go-to-sleep function that takes as a
parameter a pointer to  spinlock to release after its state is set to
TASK_INTERRUPTIBLE?
