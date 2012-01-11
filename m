Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582Ab2AKSvk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 13:51:40 -0500
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:37323 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753324Ab2AKSvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 13:51:39 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 7BsXk1YVM1mJ8Dl6b_Tr40dPsI52TOZgpp6TxTfnxg97lC_
 Tkrx1hxi8m8WatRe7PcgX2R67kcGoz3e4a9yHAgZA7PQZ85GJEXzuRHmefsL
 Q_Y_9LhsQEcwZ.OGEliHFC8NMJbkvDfQJ6NnfqhG0Aj5R0swwvK0eFXR.OF2
 yjtZxKzK_OswPw8lZlQGFieep9OuWrGt6MRwcXAAR1DGI3xCGhcSovXc_AEN
 QrdZhwQ7O.AZqgeAAfkS0zLDKGFlStWHcqInu8.2xpwhEa2I6.nnZxI.fU8i
 XV.pSzQtYAa9dMkILryg0nbTdOgcNzyfsukqlwYA9LOMO5L0Z6fE_ZPEDx4u
 hCxjQJGoBdSJrvRjbsD8v5hA50go12Ejozowa.ZMkA0lHnA--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 11 Jan 2012 12:51:34 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
cc: mgorman@suse.de, Al Viro <viro@ZenIV.linux.org.uk>,
        Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: Several bugs in latest kernel
In-Reply-To: <4F0DCFFC.5040805@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.00.1201111249510.31239@router.home>
References: <4F0DCFFC.5040805@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jan 2012, Srivatsa S. Bhat wrote:

> [ 7314.427769] kernel BUG at mm/slab.c:3111!

A typical case of memory corruption. Enable object debugging in the slab
allocator to figure out what. CONFIG_SLUB=y CONFIG_SLUB_DEBUG_ON=y will
get you to a config where you would likely get detailed reports on what is
corrupted.
