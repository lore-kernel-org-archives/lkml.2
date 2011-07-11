Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758581Ab1GKX5H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 19:57:07 -0400
Received: from smtp-out.google.com ([216.239.44.51]:8452 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab1GKX5F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 19:57:05 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:from:
	date:x-google-sender-auth:message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=uccHF0pN5i0UJvqh9u1Pc7WV1+SIj/qSZ+fMZp2thOnaMVPjbogfK3xy0gs9IEJZl
	PR++womI1w524Yx8Os/cQ==
MIME-Version: 1.0
In-Reply-To: <1310425070-10389-1-git-send-email-sonnyrao@chromium.org>
References: <1310425070-10389-1-git-send-email-sonnyrao@chromium.org>
From: Sonny Rao <sonnyrao@chromium.org>
Date: Mon, 11 Jul 2011 16:56:40 -0700
X-Google-Sender-Auth: 9HT7AyluSOMQX_Ez61qlVBYRb8Y
Message-ID: <CAPz6YkUNaCBoAE3cTgNd8p8kuOPg3yCqfJ0Q=EVad5bzffmk-w@mail.gmail.com>
Subject: Re: [PATCH] [RFC][PATCH] Remove /proc/kallsyms size verification
 check in perf
To: acme@redhat.com
Cc: rostedt@goodmis.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Sonny Rao <sonnyrao@chromium.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On Mon, Jul 11, 2011 at 3:57 PM, Sonny Rao <sonnyrao@chromium.org> wrote:
> The check was failing when I was trying to profile system startup
> because the modules were being loaded and causing the size of
> kallsyms to change.  At first I changed the check to simply make
> sure the size of kallsyms increased, but that wouldn't cover the
> case of a module getting removed (or some removed and larger ones
> loaded).  I can't see any purpose to checking the size
> right after reading it either, so remove the check altogether.

Ignore this patch; I just realized it is actually copying all of
kallsyms into the
trace output file.  I'll have to do something a bit smarter to fix
this problem --
I'll post a new patch when it's ready (and tested)

Sonny
