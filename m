Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab1DQOJb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 10:09:31 -0400
Received: from 8bytes.org ([88.198.83.132]:34871 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905Ab1DQOJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 10:09:25 -0400
Date: Sun, 17 Apr 2011 16:09:24 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Jerome Glisse <j.glisse@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Tejun Heo <tj@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
        alexandre.f.demers@gmail.com
Subject: Re: Linux 2.6.39-rc3
Message-ID: <20110417140924.GU18463@8bytes.org>
References: <BANLkTinud+4nUkZtnYRrU_gAFaMDWRa_AA@mail.gmail.com> <4DA655E7.3000904@zytor.com> <BANLkTimqR_M5keMqr5WAuz-t+1BkCZbwCg@mail.gmail.com> <BANLkTincU4rM+SqhzGOK_Rgxgg8fqJOOdQ@mail.gmail.com> <20110415131152.GJ18463@8bytes.org> <20110415131650.GB18660@elte.hu> <20110415154604.GN18463@8bytes.org> <BANLkTim23SQiyb4R+QA7=fpPZrnQw9_PRQ@mail.gmail.com> <20110416163509.GS18463@8bytes.org> <BANLkTimxG3QoLx0vqw9YgE_s4qyzcEoEaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimxG3QoLx0vqw9YgE_s4qyzcEoEaQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 16, 2011 at 02:54:04PM -0400, Jerome Glisse wrote:

> If you want to go the printk way you can add printk before each test
> ring_test, ib_test in r600.c this 2 functions are the own that might
> trigger the first GPU gart activities.

Okay, I found the place in source that triggers this. It happens in the
function r600_ib_test. The interesting thing is that not the ib-command
itself is responsible but the fence that is emitted afterwards (proved
by removing the fence command, where the problem went away).
I don't know enough about the command semantics to make a guess what
goes wrong there. But maybe you GPU folks have an idea?

	Joerg

