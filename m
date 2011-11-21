Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab1KUTmQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 14:42:16 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36458 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791Ab1KUTmO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 14:42:14 -0500
MIME-Version: 1.0
In-Reply-To: <20111121191811.GA24039@albatros>
References: <1319672956-17114-1-git-send-email-keescook@chromium.org>
	<20111121191811.GA24039@albatros>
Date: Mon, 21 Nov 2011 11:42:12 -0800
X-Google-Sender-Auth: YHZeLmqd3iJPNVLc-odJ0U4fPUA
Message-ID: <CAGXu5jJuoC7dgB_U2qj1Pb0-wd_D+JjLEuxS2e+uZDEugvGqXQ@mail.gmail.com>
Subject: Re: [RFC] Make Yama pid_ns aware
From: Kees Cook <keescook@chromium.org>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        kernel-hardening@lists.openwall.com,
        "Serge E. Hallyn" <serge@hallyn.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 11:18 AM, Vasiliy Kulikov <segoon@openwall.com> wrote:
> As Yama's sysctls are about defining a security policy for the system,
> it is reasonable to define it per container in case of LXC containers
> (or out-of-tree alternatives like OpenVZ).  In my opinion they belong
> to pid namespace.  With per-pid_ns sysctls it is possible to create
> multiple containers with different ptrace, /tmp, etc. policies.

Cool, this seems like a good idea. Thanks for the patch! If Serge (or
other folks thinking about per-pid_ns stuff) think this is a good
approach, I'm happy to include it in the next revision of the Yama
patchset.

> proc_pid_dointvec_minmax() is stolen from its ipc_ns equivalent in
> ipc/ipc_sysctl.c.

I wonder if this function should be moved into a common location, in
case other things will want to do similar things.

-Kees

-- 
Kees Cook
ChromeOS Security
