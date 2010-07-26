Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab0GZMTz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 08:19:55 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:34528 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152Ab0GZMTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 08:19:54 -0400
To: Cong Wang <amwang@redhat.com>
Cc: huang ying <huang.ying.caritas@gmail.com>, linux-kernel@vger.kernel.org,
        nhorman@redhat.com, akpm@linux-foundation.org
Subject: Re: [Patch] kexec: increase max of kexec segments and use dynamic allocation
References: <20100722061810.5659.87609.sendpatchset@localhost.localdomain>
	<m1wrso2foi.fsf@fess.ebiederm.org> <4C47E7C9.60608@redhat.com>
	<m1iq482duy.fsf@fess.ebiederm.org>
	<AANLkTikZTGYl2NIFzcTCG2DAaMefhnJAkSHIoJN22QoI@mail.gmail.com>
	<m1lj90p8yp.fsf@fess.ebiederm.org> <4C4D5F4F.8080002@redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 26 Jul 2010 05:19:49 -0700
In-Reply-To: <4C4D5F4F.8080002@redhat.com> (Cong Wang's message of "Mon\, 26 Jul 2010 18\:11\:27 +0800")
Message-ID: <m1iq425tay.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.188.4.80;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.4.80
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cong Wang <amwang@redhat.com> writes:

> So, what is a better number? 2048? :)

I was thinking something a little ridiculous like 10K or 64K.

Assuming the usage you care about is something like hibernate on a
machine with disjoint memory where you truly need one segment for
each memory region.

The only point of a limit at all once we introduce dynamic allocation
is to catch buggy apps.

Eric
