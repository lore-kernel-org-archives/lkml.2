Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664Ab3AENYe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 08:24:34 -0500
Received: from mail.skyhub.de ([78.46.96.112]:41392 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755435Ab3AENYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 08:24:31 -0500
Date: Sat, 5 Jan 2013 14:24:47 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7u1 20/31] x86, kexec: replace ident_mapping_init and
 init_level4_page
Message-ID: <20130105132447.GD4297@x1.alien8.de>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Yinghai Lu <yinghai@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kiszka <jan.kiszka@web.de>,
	Jason Wessel <jason.wessel@windriver.com>,
	linux-kernel@vger.kernel.org
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
 <1357260531-11115-21-git-send-email-yinghai@kernel.org>
 <20130104210114.GA11611@x1.alien8.de>
 <CAE9FiQV+AF=Ltz7os-f+Ksvt14VXqMvCR4neO07J+_ubpkzVgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAE9FiQV+AF=Ltz7os-f+Ksvt14VXqMvCR4neO07J+_ubpkzVgw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2013 at 02:04:05PM -0800, Yinghai Lu wrote:
> On Fri, Jan 4, 2013 at 1:01 PM, Borislav Petkov <bp@alien8.de> wrote:
> > On Thu, Jan 03, 2013 at 04:48:40PM -0800, Yinghai Lu wrote:
> >>  static int init_pgtable(struct kimage *image, unsigned long start_pgtable)
> >>  {
> >> +     struct x86_mapping_info info = {
> >> +             .alloc_pgt_page = alloc_pgt_page,
> >> +             .context        = image,
> >> +             .pmd_flag       = __PAGE_KERNEL_LARGE_EXEC,
> >> +     };
> >
> > This is leaving ->kernel_mapping uninitialized to contain a random,
> > previous stack value. I don't think we want that.
> 
> that should be initialized to false by default.

So make it explicit. You can't possibly rely on what the stack contains
when you allocate that struct there.

-- 
Regards/Gruss,
Boris.
