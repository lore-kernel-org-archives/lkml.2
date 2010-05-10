Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625Ab0EJTwQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 15:52:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990Ab0EJTwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 15:52:15 -0400
Date: Mon, 10 May 2010 21:49:17 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Cedric Le Goater <clg@fr.ibm.com>, Dave Hansen <haveblue@us.ibm.com>,
       Eric Biederman <ebiederm@xmission.com>,
       Herbert Poetzl <herbert@13thfloor.at>, Ingo Molnar <mingo@elte.hu>,
       Mathias Krause <Mathias.Krause@secunet.com>,
       Roland McGrath <roland@redhat.com>, Serge Hallyn <serue@us.ibm.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] swapper fixes (Was: kernel panic on kill(0, SIGTERM)
	with PGID == 0)
Message-ID: <20100510194917.GA5249@redhat.com>
References: <4BE01C86.3050908@secunet.com> <20100509184510.GA15219@redhat.com> <4BE7B3BD.70901@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BE7B3BD.70901@secunet.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Mathias Krause reports that a buggy (or special) /sbin/init can
crash the kernel if it sends a signal to its pgrp/sid before it
changes its initial (0,0) pids. See the changelog for 1/4.

git-bisect blames "start the global /sbin/init with 0,0 special pids"
commit 430c623121ea88ca80595c99fdc63b7f8a803ae5, but in fact the
problem was caused by another change, see 2/4.

The patches do not depend on each other, 3/4 fixes another problem,
4/4 is purely cosmetic.

Oleg.

