Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758479Ab1EaVc4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 17:32:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33587 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758252Ab1EaVcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 17:32:55 -0400
MIME-Version: 1.0
In-Reply-To: <20110531190809.GA20691@redhat.com>
References: <201105180240.56754.vda.linux@googlemail.com> <20110518095539.GU20624@htj.dyndns.org>
 <20110523124314.GA7232@redhat.com> <20110524102834.GC10334@htj.dyndns.org>
 <20110525182919.GB16575@redhat.com> <20110526091401.GD9715@htj.dyndns.org>
 <20110526150150.GD12525@redhat.com> <20110527182121.GA3212@mtj.dyndns.org>
 <20110530192255.GB20616@redhat.com> <BANLkTimupSd774N-VBoswOj+Dza=5ofvWQ@mail.gmail.com>
 <20110531190809.GA20691@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 1 Jun 2011 06:32:31 +0900
Message-ID: <BANLkTinEXW=nS6KoH7SKHbTit=nKfG7NOw@mail.gmail.com>
Subject: Re: [PATCH 03/10] ptrace: implement PTRACE_SEIZE
To: Oleg Nesterov <oleg@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, indan@nul.nu,
        Tejun Heo <tj@kernel.org>, bdonlan@gmail.com,
        linux-kernel@vger.kernel.org, jan.kratochvil@redhat.com,
        akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 1, 2011 at 4:08 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> On a seriouse note, of course you are right, but what we should do?

Have we *ever* gotten a bug-report about these kinds of things from
actual users?

IOW, it may be an annoying issue from a theoretical standpoint, but
afaik it's not an annoying issue from a practical user standpoint.

Compare it to the _practically_ annoying issue we had with ^C and
bash, where it was fundamentally impossible to know whether the child
actually exited due to the ^C or not due to the interfaces. That one
caused actual practical issues that people hit, and that were
impossible to work around in theory, and hard to work around in
practice..

In comparison, I don't think pid-vs-namespace issues for ptrace or
some subtle interaction with execve is really all that big of a
problem in practice.

Keep the eye on the ball: look around what people actually complain
about for practical reason that they hit, rather than issues that
people say "wouldn't it be nice if.." about.

             Linus
