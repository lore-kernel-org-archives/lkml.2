Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab1HQOUK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 10:20:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753865Ab1HQOUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 10:20:07 -0400
Date: Wed, 17 Aug 2011 16:16:41 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        lennart@poettering.net, linux-man@vger.kernel.org,
        roland@hack.frob.com, torvalds@linux-foundation.org
Subject: Re: +
	prctl-add-pr_setget_child_reaper-to-allow-simple-process-supervision
	.patch added to -mm tree
Message-ID: <20110817141641.GA15503@redhat.com>
References: <201108162011.p7GKBcY0023134@imap1.linux-foundation.org> <20110817115543.GA8745@redhat.com> <20110817130531.GA12204@redhat.com> <CAPXgP10A4rcQLht--h1d3PJE=oOrm=MSjGXTUSKVF+ssnkt_gw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPXgP10A4rcQLht--h1d3PJE=oOrm=MSjGXTUSKVF+ssnkt_gw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17, Kay Sievers wrote:
>
> On Wed, Aug 17, 2011 at 15:05, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > But, I seem to remember, that patch cleared ->child_reaper on exec,
>
> I don't think he original patch did.
>
> > I think this makes sense.
>
> Why would it? Systemd can serialize its state and properly re-exec
> itself as many times as needed during its lifetime. Why would the
> kernel take something away from a process, which it explicitly asked
> for?
>
> > And I am not sure about security. No, I do not see any problems, just
> > I don't know. Say, should we check the creds during reparenting? I
> > dunno.
>
> Hmm, I don't see why that would be necessary. It's just one of our
> parents that aks for our signals.

Oh, I do not know. I do not pretend I understand the security ;)

For example. I simply can't understand why do we have security_task_wait().
Why waitpid(my_natural_child) can fail for security reasons? But we have
selinux_task_wait().



So, once again. I am not arguing. I am only asking the questions.
I didn't mean I see any problem here.

Oleg.

