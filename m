Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759461Ab0FPUJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 16:09:19 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:58304 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759243Ab0FPUJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 16:09:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=n+NcF9JpFqhhB+BOM8BTb9NaRoevu72nJlphcfnvoIP7G/tu8ASvaUSrPZX2R0KYRz
         KuPQsRRcRXbfHHeasaKIaVBAlYC60R7xNBFeLMYbE+uJ1+b4fQuZOu564rAHqjBFIPE3
         aqoAjJLpVkU6ytExWuY55vbJPA61x2C4XzdO0=
MIME-Version: 1.0
Date: Wed, 16 Jun 2010 13:09:10 -0700
Message-ID: <AANLkTil6JWOMEAm6JyNNtlqGx6ofsgUjg2zmbR8IrRK4@mail.gmail.com>
Subject: Reserving file descriptors per applications
From: "Leonidas ." <leonidas137@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is the scenario:

I have a shared lib which is written to profile some web servers, the
lib collects some statistics from runs and logs it to files or over
sockets.

Some of these servers close all file descriptors under some
conditions, I am not sure whether this is the right programming
proactice, but they do it.

Due to which my logging fails, I have a way here to check the validity
of file descriptor every time before I write, but this cases latency
since we are doing
two system calls instead of one.

Is there any way using which, I can tell kernel to reserver some fds
for my lib so that these fds are immune to being closed by anyone
other than my lib itself?

Any setrlimit() magic using which I can just reserve the fd and then
change back the limits and application just does not see my fds.

-Leo.
