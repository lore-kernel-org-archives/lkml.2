Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409Ab1LLPVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 10:21:39 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:38496 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab1LLPVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 10:21:38 -0500
MIME-Version: 1.0
In-Reply-To: <20111212150255.GA7506@kroah.com>
References: <1323693892-11570-1-git-send-email-dbaluta@ixiacom.com>
	<20111212150255.GA7506@kroah.com>
Date: Mon, 12 Dec 2011 17:21:37 +0200
X-Google-Sender-Auth: rtq4shAq540-jB9dV0O9fraONQM
Message-ID: <CAEnQRZBiVDAHH+uZ=Ugk=UP5qSvvMViGTM-bRWr+E27zivOUug@mail.gmail.com>
Subject: Re: [PATCH] kref: add function for reading kref value
From: Daniel Baluta <dbaluta@ixiacom.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, adobriyan@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 5:02 PM, Greg KH <greg@kroah.com> wrote:
> On Mon, Dec 12, 2011 at 02:44:52PM +0200, Daniel Baluta wrote:
>> We can easily get kref refcount value by accesing
>> kref->refcount but it is better to have a function
>> for this.
>
> No, you should NEVER need the value of the kref, if you do, you are
> doing something wrong.
>
> What code needs this patch?

I plan to replace raw refcount patterns from net/ with kref, and
I have noticed that there are some parts of code who need access
to kref->refcount value.

e.g:

core/neighbour.c:152:			if (atomic_read(&n->refcnt) == 1 &&
core/neighbour.c:801:			if (atomic_read(&n->refcnt) == 1 &&
sched/cls_u32.c:459:	if (ht->refcnt == 1) {


thanks,
Daniel.
