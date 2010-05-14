Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757815Ab0ENNBH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 09:01:07 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56077 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825Ab0ENNBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 09:01:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=if+jNlCXLBQFa432qrEuyjelkMjaQwJGSC/qA5STCjdHD/6Q4JKsVcUiT+Z9Cdi+ig
         /FQw5gfq7GHi7hfOiCxlvSTZnNkHWPRzCV33DHkUVtVvRQ5eLoavBs7iYnUd2o98g9rb
         3fnufy6eCpQMmfkdIjoIHbGa+4O00zIudxGnE=
MIME-Version: 1.0
From: dave b <db.pub.mail@gmail.com>
Date: Fri, 14 May 2010 22:53:51 +1000
Message-ID: <AANLkTimAF1zxXlnEavXSnlKTkQgGD0u9UqCtUVT_r9jV@mail.gmail.com>
Subject: PROBLEM: oom killer and swap weirdness on 2.6.3* kernels
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 2.6.3* kernels (test case was performed on the 2.6.33.3 kernel)
when physical memory runs out and there is a large swap partition -
the system completely stalls.

I noticed that when running debian lenny using dm-crypt  with
encrypted / and swap with a  2.6.33.3 kernel (and all of the 2.6.3*
series iirc) when all physical memory is used (swapiness was left at
the default 60) the system hangs and does not respond. It can resume
normal operation some time later - however it seems to take a *very*
long time for the oom killer to come in. Obviously with swapoff this
doesn't happen - the oom killer comes in and does its job.


free -m
             total       used       free     shared    buffers     cached
Mem:          1980       1101        879          0         58        201
-/+ buffers/cache:        840       1139
Swap:        24943          0      24943


My simple test case is

dd if=/dev/zero of=/tmp/stall
and wait till /tmp fills...
