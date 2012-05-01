Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872Ab2EAXLf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 19:11:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60893 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755231Ab2EAXLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 19:11:34 -0400
Date: Tue, 1 May 2012 16:11:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Doug Ledford <dledford@redhat.com>, linux-kernel@vger.kernel.org,
        sfr@canb.auug.org.au
Subject: Re: [Patch 3/4] ipc/mqueue: strengthen checks on mqueue creation
Message-Id: <20120501161131.90a9967a.akpm@linux-foundation.org>
In-Reply-To: <4FA06C15.7000500@gmail.com>
References: <1335894655-11398-1-git-send-email-dledford@redhat.com>
	<d280fa846e9093a3cc82d9e75da4bb8074c7d4c7.1335894230.git.dledford@redhat.com>
	<4FA04131.2040004@gmail.com>
	<4FA04373.6090100@redhat.com>
	<CAHGf_=p34t2jrqr1V_TP0UiXLE8g1p6UXOV25SwWC8C9h2BVBQ@mail.gmail.com>
	<4FA06BA2.7020703@redhat.com>
	<4FA06C15.7000500@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 May 2012 19:04:53 -0400
KOSAKI Motohiro <kosaki.motohiro@gmail.com> wrote:

> > OK, then would EOVERFLOW suit things better?
> 
> I have no seen to any confusion source this. thank you.

--- a/ipc/mqueue.c~ipc-mqueue-strengthen-checks-on-mqueue-creation-fix
+++ a/ipc/mqueue.c
@@ -687,13 +687,13 @@ static int mq_attr_ok(struct ipc_namespa
 	}
 	/* check for overflow */
 	if (attr->mq_msgsize > ULONG_MAX/attr->mq_maxmsg)
-		return -ENOMEM;
+		return -EOVERFLOW;
 	mq_treesize = attr->mq_maxmsg * sizeof(struct msg_msg) +
 		min_t(unsigned int, attr->mq_maxmsg, MQ_PRIO_MAX) *
 		sizeof(struct posix_msg_tree_node);
 	total_size = attr->mq_maxmsg * attr->mq_msgsize;
 	if (total_size + mq_treesize < total_size)
-		return -ENOMEM;
+		return -EOVERFLOW;
 	return 0;
 }
 
_

