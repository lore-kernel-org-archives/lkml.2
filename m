Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379Ab1FCWQq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 18:16:46 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34618 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab1FCWQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 18:16:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=IMPlaV412hypkz5pz7Gol9uPTZoxKLCKWSoZ3PjxJpJE5qAWn4Hu89feKPM0BOCDWk
         Gd5AE6dtjN6O70h2n8ztCo6ndZN+COzMgleLDqX+Br2N8ken3yLEUSsql+JJvx4gCJ93
         ohHeVJwRcefIP39kC8c4PcBc61Uio2FuBz420=
MIME-Version: 1.0
In-Reply-To: <1307133252-23259-3-git-send-email-wad@chromium.org>
References: <1307133252-23259-1-git-send-email-wad@chromium.org>
	<1307133252-23259-3-git-send-email-wad@chromium.org>
Date: Fri, 3 Jun 2011 18:16:42 -0400
X-Google-Sender-Auth: uVtpJkMJfDgbbCBZHIdCO9tAWrs
Message-ID: <BANLkTink868yzHYHd-FyK9BH6nybdSUCuA@mail.gmail.com>
Subject: Re: [PATCH v4 03/13] seccomp_filters: new mode with configurable
 syscall filters
From: Colin Walters <walters@verbum.org>
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, kees.cook@canonical.com,
        torvalds@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
        rostedt@goodmis.org, jmorris@namei.org, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 3, 2011 at 4:34 PM, Will Drewry <wad@chromium.org> wrote:
> (Any thoughts specifically on the mutex use would be greatly appreciated!)
>
> This change adds a new seccomp mode which specifies the allowed system
> calls dynamically.

One thing to consider (not sure if it's been discussed, but I think
not) is whether some of the LSMs should hook this.

Notably, it looks like SELinux doesn't have an access vector for prctl
at all now; it doesn't hook task_prctl from what I see, and so we fall
back to cap_task_prctl.  While I know the idea of restricting a
process' ability to enter seccomp is a bit perverse, we should
probably at least allow mandatory controls.  James?
