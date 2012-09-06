Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526Ab2IFRVl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 13:21:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932413Ab2IFRVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 13:21:40 -0400
Date: Thu, 6 Sep 2012 12:45:36 -0400
From: Dave Jones <davej@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: 3.6-rc4 audit_log_d_path oops.
Message-ID: <20120906164536.GB30220@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Kees Cook <keescook@chromium.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>
References: <20120906134628.GA8962@redhat.com>
 <20120906151616.GB23345@redhat.com>
 <CAGXu5jL8_qDO2QfoL7SbWjrHuta8x8Xxsyt8iOevhKPnip_+=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jL8_qDO2QfoL7SbWjrHuta8x8Xxsyt8iOevhKPnip_+=w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 09:32:49AM -0700, Kees Cook wrote:
 > > I just realised, the funny thing about this is that the machine running that test
 > > had selinux/audit disabled. And yet here we are, screwing around with audit buffers.
 > 
 > The intent was to have this message show up in dmesg even if auditd
 > wasn't running, and even if the specific process wasn't being
 > explicitly audited.
 > 
 > > Should there be a test on audit_enable=0 in audit_log_link_denied() ?
 > >
 > > I'm now curious how much more of the audit code is getting run through similar lack of tests
 > 
 > What is the condition in which audit_log_start fails?

in the case of that oops, given I had booted with audit=0, I suspect it was hitting the first check...

1157         if (audit_initialized != AUDIT_INITIALIZED)
1158                 return NULL;
 
	Dave

