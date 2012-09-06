Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932836Ab2IFRu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 13:50:29 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:58029 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932280Ab2IFRu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 13:50:27 -0400
MIME-Version: 1.0
In-Reply-To: <20120906164536.GB30220@redhat.com>
References: <20120906134628.GA8962@redhat.com>
	<20120906151616.GB23345@redhat.com>
	<CAGXu5jL8_qDO2QfoL7SbWjrHuta8x8Xxsyt8iOevhKPnip_+=w@mail.gmail.com>
	<20120906164536.GB30220@redhat.com>
Date: Thu, 6 Sep 2012 10:50:27 -0700
X-Google-Sender-Auth: B2Yjc7GgTtED_LAAAj9UMaMq9mQ
Message-ID: <CAGXu5jJhuuMsfeZtKoJ7ZWgRKgs5Fcp2GgO9+UaA5kMCk_H1qQ@mail.gmail.com>
Subject: Re: 3.6-rc4 audit_log_d_path oops.
From: Kees Cook <keescook@chromium.org>
To: Dave Jones <davej@redhat.com>, Kees Cook <keescook@chromium.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 6, 2012 at 9:45 AM, Dave Jones <davej@redhat.com> wrote:
> On Thu, Sep 06, 2012 at 09:32:49AM -0700, Kees Cook wrote:
>  > > I just realised, the funny thing about this is that the machine running that test
>  > > had selinux/audit disabled. And yet here we are, screwing around with audit buffers.
>  >
>  > The intent was to have this message show up in dmesg even if auditd
>  > wasn't running, and even if the specific process wasn't being
>  > explicitly audited.
>  >
>  > > Should there be a test on audit_enable=0 in audit_log_link_denied() ?
>  > >
>  > > I'm now curious how much more of the audit code is getting run through similar lack of tests
>  >
>  > What is the condition in which audit_log_start fails?
>
> in the case of that oops, given I had booted with audit=0, I suspect it was hitting the first check...
>
> 1157         if (audit_initialized != AUDIT_INITIALIZED)
> 1158                 return NULL;

Ah-ha, okay. Yeah, I'm fine with the fix you had. If _start fails, just return.

-Kees

-- 
Kees Cook
Chrome OS Security
