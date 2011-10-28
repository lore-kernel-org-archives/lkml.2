Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836Ab1J1Ngg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 09:36:36 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58701 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755369Ab1J1Ngf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 09:36:35 -0400
MIME-Version: 1.0
Date: Fri, 28 Oct 2011 15:36:33 +0200
Message-ID: <CAGgmwq6X5OcTvMioYT6JGXqwaX2JE0Aw_XZ9S_-1s=2fcvgRJQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] LSM: Do not apply mmap_min_addr check to PROT_NONE
From: Gregory Sahanovitch <gsahanovitch@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
        Stephen Smalley <sds@tycho.nsa.gov>, selinux@tycho.nsa.gov,
        John Johansen <john.johansen@canonical.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It's exactly the case that I did mention: an application's own attempt to
> ensure robustness by doing a PROT_NONE mmap of the [0,0x10000) region.  An
> application cannot presume that this region is already precluded from being
> used by any non-MAP_FIXED mmap across all systems and configurations, so
> it's defensive coding to explicitly block it off with a PROT_NONE mapping.

I don't see a realistic threat model in the example you give.

Since mmap_min_addr is used to prevent a *malicious* process from
maping the zero page and then taking advantage of a user-pointer
dereference in the *kernel code*, I do not see what you gain by
guaranteeing that the application *that you control* would never
exploit such a vulnerability?

Sorry if I'm being thick, but it would be helpful to me if you clarify.

-- 
- Greg
