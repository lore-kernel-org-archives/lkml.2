Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab1CROUT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 10:20:19 -0400
Received: from smtp-out.google.com ([74.125.121.67]:10307 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756717Ab1CROUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 10:20:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=P28r8i9SPC6rStYCvWZqT14xK4k+IX27xQI/nZddwy+XRTNDPlLbYRTP3gLWLs3oGz
         wKLXVnV9exVcg030o3vA==
MIME-Version: 1.0
Date: Fri, 18 Mar 2011 15:19:59 +0100
Message-ID: <AANLkTimjSZSvz2zPEoc3SSJUBtWVJ_mza5ujpyaM0RVi@mail.gmail.com>
Subject: [BUG] perf: cannot generate Python support without NEWT
From: Stephane Eranian <eranian@google.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        mingo@elte.hu
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo,

Looks like some define is missing during the generation of the python support.
If you don't have newt then it fails to compile:

$ make
Makefile:430: newt not found, disables TUI support. Please install
newt-devel or libnewt-dev
PERF_VERSION = 2.6.38
Makefile:430: newt not found, disables TUI support. Please install
newt-devel or libnewt-dev
...
GEN perf-archive
GEN python/perf.so
In file included from util/evsel.h:10,
                 from util/python.c:6:
util/hist.h:105: fatal error: newt.h: No such file or directory
compilation terminated.
error: command 'gcc' failed with exit status 1
