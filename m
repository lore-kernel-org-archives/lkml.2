Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721Ab1DIDFX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 23:05:23 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:51726 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab1DIDFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 23:05:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:reply-to:date:x-google-sender-auth:message-id
         :subject:from:to:content-type;
        b=LWFu2h9pkUesup0XkRnsiUrCnzppvFc1TmCdXlcYMXG8446hbGVOEwgKG3U/sroc1h
         s60NmB/1xQQa8fYu03c5vmZ+IEPyNR6nNrCstL8OGfuurUN7CDmmF13ltciQUhOKvTCV
         gbxDwIRHleOvQU956Mzl1fCTHvmiNwXPKQ9g8=
MIME-Version: 1.0
Reply-To: pengcheng.chen@acm.org
Date: Fri, 8 Apr 2011 19:55:42 -0700
X-Google-Sender-Auth: RxJsojWH9XgKo0vieXvkm4Pyv-Q
Message-ID: <BANLkTimRW62H2MbRnWHkSbsx9Z+RyGHsAQ@mail.gmail.com>
Subject: Time window between process dying and its proc directory going way
From: Pengcheng <pengcheng.chen@acm.org>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear folks,

I'm experimenting 2.6.3x kernel on some network test boxes. Under very
heavy network traffic, the proc directory of a process *seems* not
going away within a short time window  after the process dies.

In our system, we have a daemon launching many processes, a watchdog
monitoring  heartbeats of each process. If  a process stopped
heartbeat for a while, the daemon will get a request from watchdog to
kill the process and restart it.

To kill a process, we send a SIGQUIT for it to exit gracefully. If it
is still around after 10 seconds, we send a SIGKILL. We waitpid(-1,
WNOHANG) before trying to start a new process.

We found a problem in our testing: after a process was killed,  its
/proc/<pid> directory (*we suspect*) might still be there for a while
(at least 4 seconds) and we could still read files in it.

Any thoughts on how to reproduce this problem easily (without heavy
networking traffic)?

Thanks in advance!
Pengcheng
