Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab2D2M0q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 08:26:46 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55608 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637Ab2D2M0o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 08:26:44 -0400
MIME-Version: 1.0
In-Reply-To: <1335681937-3715-1-git-send-email-levinsasha928@gmail.com>
References: <1335681937-3715-1-git-send-email-levinsasha928@gmail.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Sun, 29 Apr 2012 14:26:24 +0200
Message-ID: <CA+1xoqeFZHrqov=Tw=spnPbBSiPR6k1xGHFUXPmjfeL70BO4AA@mail.gmail.com>
Subject: Re: [PATCH 01/14] sysctl: provide callback for write into ctl_table entry
To: viro@zeniv.linux.org.uk, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, paulus@samba.org,
        acme@ghostprotocols.net, james.l.morris@oracle.com,
        ebiederm@xmission.com, akpm@linux-foundation.org, tglx@linutronix.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-security-module@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2012 at 8:45 AM, Sasha Levin <levinsasha928@gmail.com> wrote:
> +
> +       if (!error && write && table->callback)
> +               error = table->callback();
> +

Tetsuo Handa has pointed out that 'error' is actually the amount of
bytes read/written in the success case. I'll fix that for V2.
