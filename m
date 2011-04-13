Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949Ab1DMGPB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 02:15:01 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50094 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab1DMGPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 02:15:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:from:date:x-google-sender-auth:message-id
         :subject:to:cc:content-type;
        b=u0VT/m9gr4lEQcnJgHk2FJzNq2EkApdqxIITQpL2ZfhHyYOT1B6SODUnFqO3KdFejw
         SJCs+TspRJLnJmZouCJavOWkPkqv4iJzZ3qZl5lA8aKaeJH1gzc8Aw0nQ5VlFcc13ulA
         RQECLV0kZVm2O3SPsbHuG8tua5uKm7ShKsWao=
MIME-Version: 1.0
From: Mike Frysinger <vapier@gentoo.org>
Date: Wed, 13 Apr 2011 02:14:39 -0400
X-Google-Sender-Auth: IzoE41DVCgXQfYzLXaaTWkjS-qM
Message-ID: <BANLkTi=F-C-vwX4PGGfbkdTBw3OWL-twfg@mail.gmail.com>
Subject: freezer: should barriers be smp ?
To: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
        linux-pm@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

when we suspend/resume Blackfin SMP systems, we notice that the
freezer code runs on multiple cores.  this is of course what you want
-- freeze processes in parallel.  however, the code only uses non-smp
based barriers which causes us problems ... our cores need software
support to keep caches in sync, so our smp barriers do just that.  but
the non-smp barriers do not, and so the frozen/thawed processes
randomly get stuck in the wrong task state.

thinking about it, shouldnt the freezer code be using smp barriers ?
the point is to make sure that the updates are seen across all cores
are not just the current one ?
-mike
