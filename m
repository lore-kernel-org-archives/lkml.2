Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932551Ab2EIWQW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 18:16:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932519Ab2EIWQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 18:16:20 -0400
Message-ID: <4FAAECA5.8050606@redhat.com>
Date: Wed, 09 May 2012 23:16:05 +0100
From: Pedro Alves <palves@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Mike Frysinger <vapier@gentoo.org>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        pacman@kosh.dhis.org, linux-man <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Denys Vlasenko <dvlasenk@redhat.com>, Tejun Heo <tj@kernel.org>,
        Jan Kratochvil <jan.kratochvil@redhat.com>
Subject: Re: ptrace.2: PTRACE_KILL needs a stopped process too
References: <20091216004533.22261.qmail@kosh.dhis.org> <4FAAC706.6000808@redhat.com> <20120509201219.GA32051@redhat.com> <201205091241.59060.vapier@gentoo.org> <20120509211429.GA2455@redhat.com>
In-Reply-To: <20120509211429.GA2455@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2012 10:14 PM, Oleg Nesterov wrote:

>> i like to assume that my code isn't going to be bug free, so the more
>> mechanisms i have in place to protect innocent bystanders the better :)
>> -mike
> 
> From this pov PTRACE_KILL is safer, I agree ;)


Yeah, until you trip on that case where it resumes the process
instead of killing it...  At that point, it's useless.

Since I know Mike likes hacking on GDB so much ;-), FYI, this is
exercised by the gdb.base/kill-after-signal.exp test.

-- 
Pedro Alves
