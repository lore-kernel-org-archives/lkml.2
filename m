Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297Ab1LLPcW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 10:32:22 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:46614 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751026Ab1LLPcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 10:32:20 -0500
Message-ID: <1323703934.1765.15.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [PATCH] kref: add function for reading kref value
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Daniel Baluta <dbaluta@ixiacom.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, adobriyan@gmail.com
Date: Mon, 12 Dec 2011 16:32:14 +0100
In-Reply-To: <CAEnQRZBiVDAHH+uZ=Ugk=UP5qSvvMViGTM-bRWr+E27zivOUug@mail.gmail.com>
References: <1323693892-11570-1-git-send-email-dbaluta@ixiacom.com>
	 <20111212150255.GA7506@kroah.com>
	 <CAEnQRZBiVDAHH+uZ=Ugk=UP5qSvvMViGTM-bRWr+E27zivOUug@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 12 décembre 2011 à 17:21 +0200, Daniel Baluta a écrit :
> On Mon, Dec 12, 2011 at 5:02 PM, Greg KH <greg@kroah.com> wrote:
> > On Mon, Dec 12, 2011 at 02:44:52PM +0200, Daniel Baluta wrote:
> >> We can easily get kref refcount value by accesing
> >> kref->refcount but it is better to have a function
> >> for this.
> >
> > No, you should NEVER need the value of the kref, if you do, you are
> > doing something wrong.
> >
> > What code needs this patch?
> 
> I plan to replace raw refcount patterns from net/ with kref, and
> I have noticed that there are some parts of code who need access
> to kref->refcount value.
> 
> e.g:
> 
> core/neighbour.c:152:			if (atomic_read(&n->refcnt) == 1 &&
> core/neighbour.c:801:			if (atomic_read(&n->refcnt) == 1 &&
> sched/cls_u32.c:459:	if (ht->refcnt == 1) {
> 

Well, its not a good idea.

kref adds nothing here.



