Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732Ab1J1SAr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 14:00:47 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40286 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab1J1SAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 14:00:45 -0400
MIME-Version: 1.0
In-Reply-To: <20111028163736.AEF082C0EB@topped-with-meat.com>
References: <CAGgmwq49CQKpMhhOHKTasvaRhripu87sq+wzoTQtdv4vDoE1iQ@mail.gmail.com>
	<20111028163736.AEF082C0EB@topped-with-meat.com>
Date: Fri, 28 Oct 2011 20:00:44 +0200
Message-ID: <CAGgmwq73m8fQ4tn6VGFGa=LxHO4RDdAaxaSXoZ8TF_+sXnztyw@mail.gmail.com>
Subject: Re: [PATCH 1/2] LSM: Do not apply mmap_min_addr check to PROT_NONE
From: Gregory Sahanovitch <gsahanovitch@gmail.com>
To: Roland McGrath <roland@hack.frob.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
        Stephen Smalley <sds@tycho.nsa.gov>, selinux@tycho.nsa.gov,
        John Johansen <john.johansen@canonical.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 6:37 PM, Roland McGrath <roland@hack.frob.com> wrote:
>> Since mmap_min_addr is used to prevent a *malicious* process from maping the
>> zero page and then taking advantage of a user-pointer dereference in the
>> *kernel code*, I do not see what you gain by guaranteeing that the
>> application *that you control* would never exploit such a vulnerability?
>
> The application does sandboxing of untrusted code.
>

Makes sense, thanks.

Out of curiosity, what kind of sandbox exactly? I'm guessing you need
to prevent many other operations, e.g., by intercepting some system
calls. In that case, you could also ensure that such an mmap never
occurs...

-- 
- Greg
