Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab1LLVD6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 16:03:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15046 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753963Ab1LLVDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 16:03:55 -0500
Date: Mon, 12 Dec 2011 22:03:28 +0100
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: t cheney <cdmalord@gmail.com>
Cc: gdb <gdb@sourceware.org>, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        crash-catcher@lists.fedorahosted.org
Subject: Re: [PATCH 1/1] x86: Add process memory layout to coredump file
Message-ID: <20111212210328.GA29248@host2.jankratochvil.net>
References: <CAE04G=Bu4WnU9SYU9u3-ap6OrBEjWONK8TA8bYBy5OSCCzzDqg@mail.gmail.com>
 <CAE04G=D_OzrDRUOj-iVPJY5sNTLMfUKAeikks8TWMYOWvh6HeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE04G=D_OzrDRUOj-iVPJY5sNTLMfUKAeikks8TWMYOWvh6HeA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Dec 2011 15:10:00 +0100, t cheney wrote:
> This patch just add memory layout(same as /proc/pid/maps) to
> coredump file. The layout is appended to corenote segment with
> flag NT_MAPS=7.

FYI this has been solved by ABRT - Automated Bug-Reporting Tool
	https://fedorahosted.org/abrt/
	(it is distro-neutral despite its homepage)

Core file is there a subdirectory where the core file is just one of the many
associated files:
/var/spool/abrt/ccpp-*:
	abrt_version analyzer architecture cmdline component coredump count
	dso_list environ executable hostname kernel maps os_release package
	pid pwd reason time uid username uuid var_log_messages

More info files are being continually added, such as /proc/PID/fd{,info}/
mapping at the crash dump time etc.  You would need to add many more core file
notes to make the core files useful for later analysis.


Regards,
Jan
