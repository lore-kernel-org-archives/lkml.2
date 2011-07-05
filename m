Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab1GEHka (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 03:40:30 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57293 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753959Ab1GEHk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 03:40:29 -0400
Date: Tue, 5 Jul 2011 09:40:22 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrea Righi <andrea@betterlinux.com>, Len Brown <lenb@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: Fix lockdep false positives in acpi_power_off()
Message-ID: <20110705074022.GA28000@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Andrea Righi <andrea@betterlinux.com>, Len Brown <lenb@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Maciej Rutecki <maciej.rutecki@gmail.com>,
	Florian Mickler <florian@mickler.org>, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1309684450-24549-1-git-send-email-andrea@betterlinux.com>
 <201107040028.23569.rjw@sisk.pl>
 <20110704082307.GA1239@thinkpad>
 <201107050132.11996.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <201107050132.11996.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 05, 2011 at 01:32:11AM +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: ACPI: Fix lockdep false positives in acpi_power_off()
> 
> All ACPICA locks are allocated and initialized by the same function,
> acpi_os_create_lock(), with the help of a local variable called
> "lock".  Thus, when lockdep is enabled, it uses "lock" as the
> name of all those locks and regards them as instances of the same
> lock, which causes it to report possible locking problems with them
> when there aren't any.
> 
> To work around this problem, define acpi_os_create_lock() as a macro
> and make it pass its argument to spin_lock_init(), so that lockdep
> uses it as the name of the new lock.  Define this macron in a
> Linux-specific file to minimize the resulting modifications of
> the OS-independent ACPICA parts.
> 
> This change is based on an earlier patch from Andrea Righi and it
> addresses a regression from 2.6.39 tracked as
> https://bugzilla.kernel.org/show_bug.cgi?id=38152
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> Reported-by: Borislav Petkov <bp@alien8.de>
> Tested-by: Andrea Righi <andrea@betterlinux.com>

Tested-by: Borislav Petkov <bp@alien8.de>

-- 
Regards/Gruss,
    Boris.
