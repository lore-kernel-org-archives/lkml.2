Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120Ab0DMSHL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 14:07:11 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:37728 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab0DMSHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 14:07:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=X9y1BnaHU32pEauy7hk2aXxwrOxeZPjOhyAU2pPeoes6ZHKRbcNO/sFE+N5lSXDrWL
         rz0HNpT9hvJh8AlIt7EJhL+CT4quFsZ93uDk5mYBfESAc31xx3vyPuD6R2Qbn6HhkoMX
         jb+x5c6BUeXD2UsSfAdtoMjJ/PJ0Owr/ca3go=
MIME-Version: 1.0
Date: Tue, 13 Apr 2010 20:07:05 +0200
Message-ID: <h2pd9def9db1004131107qe65c7941u5c56af331b6890ad@mail.gmail.com>
Subject: Memory Allocation/Accounting bug?
From: Markus Rechberger <mrechberger@gmail.com>
To: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was doing some leaktests with our applications and couldn't really
figure out any memory leak (neither with valgrind).
Although top shows up that the application has an increased memory usage.

The sample applications:
#include <stdio.h>
#include <unistd.h>
#include <pthread.h>
#include <stdlib.h>

void *threadfunc(void *opaque) {
        return NULL;
};

int main() {
        pthread_t thread;

        while(1) {
                pthread_create(&thread,  NULL, threadfunc, NULL);
                pthread_join(thread, NULL);
//              sleep(5);
        }
        return 0;
}

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
29931 markus    20   0 16480 460g 381g S   28 11986.0   0:53.00 test

RES shows up 460gig after some time which obviously is not correct

This was tested with Ubuntu Lucid (and Linux 2.6.34-rc2), someone
tested it with 2.6.32 and it seems to be fine.

Markus
